local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

-- If you're reading this file for the first time, best skip to around line 190
-- where the actual snippet-definitions start.

-- Every unspecified option will be set to the default.
ls.setup({
  history = true,
  -- Update more often, :h events for more info.
  update_events = "TextChanged,TextChangedI",
  -- Snippets aren't automatically removed if their text is deleted.
  -- `delete_check_events` determines on which events (:h events) a check for
  -- deleted snippets is performed.
  -- This can be especially useful when `history` is enabled.
  delete_check_events = "TextChanged",
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "choiceNode", "Comment" } },
      },
    },
  },
  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- minimal increase in priority.
  ext_prio_increase = 1,
  enable_autosnippets = true,
  -- mapping for cutting selected text so it's usable as SELECT_DEDENT,
  -- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
  store_selection_keys = "<Tab>",
  -- luasnip uses this function to get the currently active filetype. This
  -- is the (rather uninteresting) default, but it's possible to use
  -- eg. treesitter for getting the current filetype by setting ft_func to
  -- require("luasnip.extras.filetype_functions").from_cursor (requires
  -- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
  -- the current filetype in eg. a markdown-code block or `vim.cmd()`.
  ft_func = function()
    return vim.split(vim.bo.filetype, ".", true)
  end,
})

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
  return args[1]
end

-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
  return sn(
  nil,
  c(1, {
    -- Order is important, sn(...) first would cause infinite loop of expansion.
    t(""),
    sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
  })
  )
end

-- complicated function for dynamicNode.
local function jdocsnip(args, _, old_state)
  -- !!! old_state is used to preserve user-input here. DON'T DO IT THAT WAY!
  -- Using a restoreNode instead is much easier.
  -- View this only as an example on how old_state functions.
  local nodes = {
    t({ "/**", " * " }),
    i(1, "A short Description"),
    t({ "", "" }),
  }

  -- These will be merged with the snippet; that way, should the snippet be updated,
  -- some user input eg. text can be referred to in the new snippet.
  local param_nodes = {}

  if old_state then
    nodes[2] = i(1, old_state.descr:get_text())
  end
  param_nodes.descr = nodes[2]

  -- At least one param.
  if string.find(args[2][1], ", ") then
    vim.list_extend(nodes, { t({ " * ", "" }) })
  end

  local insert = 2
  for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
    -- Get actual name parameter.
    arg = vim.split(arg, " ", true)[2]
    if arg then
      local inode
      -- if there was some text in this parameter, use it as static_text for this new snippet.
      if old_state and old_state[arg] then
        inode = i(insert, old_state["arg" .. arg]:get_text())
      else
        inode = i(insert)
      end
      vim.list_extend(
      nodes,
      { t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) }
      )
      param_nodes["arg" .. arg] = inode

      insert = insert + 1
    end
  end

  if args[1][1] ~= "void" then
    local inode
    if old_state and old_state.ret then
      inode = i(insert, old_state.ret:get_text())
    else
      inode = i(insert)
    end

    vim.list_extend(
    nodes,
    { t({ " * ", " * @return " }), inode, t({ "", "" }) }
    )
    param_nodes.ret = inode
    insert = insert + 1
  end

  if vim.tbl_count(args[3]) ~= 1 then
    local exc = string.gsub(args[3][2], " throws ", "")
    local ins
    if old_state and old_state.ex then
      ins = i(insert, old_state.ex:get_text())
    else
      ins = i(insert)
    end
    vim.list_extend(
    nodes,
    { t({ " * ", " * @throws " .. exc .. " " }), ins, t({ "", "" }) }
    )
    param_nodes.ex = ins
    insert = insert + 1
  end

  vim.list_extend(nodes, { t({ " */" }) })

  local snip = sn(nil, nodes)
  -- Error on attempting overwrite.
  snip.old_state = param_nodes
  return snip
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
local function bash(_, _, command)
  local file = io.popen(command, "r")
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end

-- Returns a snippet_node wrapped around an insertNode whose initial
-- text value is set to the current date in the desired format.
local date_input = function(args, snip, old_state, fmt)
  local fmt = fmt or "%Y-%m-%d"
  return sn(nil, i(1, os.date(fmt)))
end

-- snippets are added via ls.add_snippets(filetype, snippets[, opts]), where
-- opts may specify the `type` of the snippets ("snippets" or "autosnippets",
-- for snippets that should expand directly after the trigger is typed).
--
-- opts can also specify a key. By passing an unique key to each add_snippets, it's possible to reload snippets by
-- re-`:luafile`ing the file in which they are defined (eg. this one).

ls.add_snippets("lua", {
  s("lf", fmt("local function {}({})\n\t{}\nend", { i(1, "fname"), i(2), i(3) })),
  s("lreq", fmt("local {} = require(\"{}\")", { i(1, "module"), rep(1) })),
  s("req", fmt("require(\"{}\")", { i(1, "module") })),
}, { key = "lua" })

local function get_file_name()
  return vim.fn.expand("%:t:r"):upper()
end

local function snip_for_stl(name)
  local headers = {
    {
      include_name = "memory",
      components = { "unique_ptr", "shared_ptr", "make_shared" }
    }, {
      include_name = "map",
      components = { "multimap", "map" }
    }, {
      include_name = "queue",
      components = { "priority_queue", "queue" }
    }, {
      include_name = "iostream",
      components = { "cout", "endl" }
    }, {
      include_name = "fstream",
      components = { "fstream", "ifstream", "ofstream" }
    }, {
      include_name = "sstream",
      components = { "stringstream", "istreamstring", "ostringstream" }
    }
  }
  local include_name = nil
  for _, item in ipairs(headers) do
    if include_name then break end
    for _, comp in ipairs(item.components) do
      if comp == name then
        include_name = "#include <".. item.include_name.. ">"
        break
      end
    end
  end
  if not include_name then
    include_name = "#include <".. name.. ">"
  end

  local callback = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local include = true
    local add_blank_line = true
    local insert_line_no = 0
    for line_no, line in ipairs(lines) do
      if line:match(include_name) then
        include = false
        break
      elseif line:match("#ifndef.*_H_") then
        insert_line_no = line_no + 2
      elseif line:match("#include") then
        insert_line_no = line_no
        add_blank_line = false
      end
    end
    if include then
      local content = { include_name }
      if add_blank_line then
        table.insert(content, "")
      end
      vim.api.nvim_buf_set_lines(0, insert_line_no, insert_line_no, false, content)
    end
  end

  local other_keywords = {
    "string", "cout", "endl", "fstream", "ifstream", "ofstream",
    "stringstream", "istreamstring", "ostringstream"
  }

  local find_keywords = function()
    for _, keyword in ipairs(other_keywords) do
      if keyword == name then return true end
    end
    return false
  end

  if find_keywords() then
    return s(name, { t("std::".. name.. " "), i(0) }, {
      callbacks = {
        [-1] = { [events.leave] =  callback }
      }
    });
  else
    return s(name, fmt("std::".. name.. "<{}> {}", { i(1), i(0) }), {
      callbacks = {
        [-1] = { [events.leave] =  callback }
      }
    })
  end
end

ls.add_snippets("cpp", {
  -- header define macro
  s("hdef", fmt("#ifndef {}_H_\n#define {}_H_\n\n{}\n\n#endif //{}_H_", {
    i(1, get_file_name()),
    rep(1),
    i(2),
    rep(1)
  })),

  -- namespace
  s("ns", fmt("namespace {} {{\n{}\n}} // namespace {}", {
    i(1),
    i(2),
    rep(1),
  })),

  -- class
  s("cls", fmt("class {} {{\n public:\n\t{}();\n\t~{}();\n\n private:\n\t{}\n}};", {
    i(1),
    rep(1),
    rep(1),
    i(2),
  })),

  -- for
  s("for", fmt("for ({}; {}; {}) {{\n\t{}\n}}", {
    i(1),
    i(2),
    i(3),
    i(4)
  })),
  s("fora", fmt("for (const auto& {} : {}) {{\n\t{}\n}}", {
    i(1, "item"),
    i(2),
    i(3),
  })),
  s("fori", fmt("for (auto it = {}.begin(); it != {}.end(); ++it) {{\n\t{}\n}}", {
    i(1),
    rep(1),
    i(2),
  })),
  s("foric", fmt("for (auto it = {}.cbegin(); it != {}.cend(); ++it) {{\n\t{}\n}}", {
    i(1),
    rep(1),
    i(2),
  })),
  s("forir", fmt("for (auto it = {}.rbegin(); it != {}.rend(); ++it) {{\n\t{}\n}}", {
    i(1),
    rep(1),
    i(2),
  })),

  -- while
  s("while", fmt("while ({}) {{\n\t{}\n}}", {
    i(1),
    i(2)
  })),
  s("dowhile", fmt("do {{\n\t{}\n}} while({});", {
    i(1),
    i(2)
  })),

  -- main
  s("main", fmt("int main(int argc, char** argv) {{\n\t{}\n\n\treturn 0;\n}}", i(1))),

  -- container (string list vector queue priority_queue stack map set multi_set multi_map unordered_map unordered_set)
  snip_for_stl("string"),
  snip_for_stl("fstream"),
  snip_for_stl("ifstream"),
  snip_for_stl("ofstream"),
  snip_for_stl("stringstream"),
  snip_for_stl("istringstream"),
  snip_for_stl("ostringstream"),
  snip_for_stl("cout"),
  snip_for_stl("endl"),
  snip_for_stl("vector"),
  snip_for_stl("list"),
  snip_for_stl("queue"),
  snip_for_stl("priority_queue"),
  snip_for_stl("stack"),
  snip_for_stl("set"),
  snip_for_stl("map"),
  snip_for_stl("multiset"),
  snip_for_stl("multimap"),
  snip_for_stl("unordered_set"),
  snip_for_stl("unordered_map"),
  snip_for_stl("shared_ptr"),
  snip_for_stl("unique_ptr"),
  snip_for_stl("make_shared"),

  -- snips for third library (muduo)
}, {
  key = "cc"
})
