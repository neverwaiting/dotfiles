-- load snip engine
local luasnip = require 'luasnip'

-- load friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()
-- load snippets from $HOME/.config/nvim/mysnips
require('luasnip.loaders.from_vscode').load({ paths = { './mysnips' } })

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function custom_format(entry, vim_item)
  local max_width = 0
  local kind_icons = {
		Namespace = "",
		Text = " ",
		Method = " ",
		Function = " ",
		Constructor = " ",
		Field = "ﰠ ",
		Variable = " ",
		Class = "ﴯ ",
		Interface = " ",
		Module = " ",
		Property = "ﰠ ",
		Unit = "塞 ",
		Value = " ",
		Enum = " ",
		Keyword = " ",
		Snippet = " ",
		Color = " ",
		File = " ",
		Reference = " ",
		Folder = " ",
		EnumMember = " ",
		Constant = " ",
		Struct = "פּ ",
		Event = " ",
		Operator = " ",
		TypeParameter = " ",
		Table = "",
		Object = " ",
		Tag = "",
		Array = "[]",
		Boolean = " ",
		Number = " ",
		Null = "ﳠ",
		String = " ",
		Calendar = "",
		Watch = " ",
		Package = "",
	}
	local source_names = {
		nvim_lsp = '[LSP]',
		nvim_lua = '[API]',
		treesitter = '[TS]',
		emoji = '[Emoji]',
		path = '[Path]',
		calc = '[Calc]',
		cmp_tabnine = '[Tabnine]',
		vsnip = '[Snip]',
		luasnip = '[Snip]',
		buffer = '[Buffer]',
		spell = '[Spell]',
	}
	if max_width ~= 0 and #vim_item.abbr > max_width then
		vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. "…"
	end
	vim_item.kind = kind_icons[vim_item.kind] .. vim_item.kind
	vim_item.menu = source_names[entry.source.name]
	return vim_item
end
-- set up nvim-cmp
local cmp = require 'cmp'
cmp.setup {
	-- enabled = function()
	-- 	-- disable completion if the cursor is `Comment` syntax group.
	-- 	-- return not cmp.config.context.in_syntax_group('Comment')
	-- end,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
	completion = {
		-- The number of characters needed to trigger auto-completion.
		keyword_length = 1
		-- match pattern
		-- keyword_pattern : string
	},
	mapping = {
		-- `i` = insert mode, `c` = command mode, `s` = select mode
		['<C-h>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
			elseif has_words_before() then
				cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
		['<C-l>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
				cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
		['<C-e>'] = cmp.mapping(function(fallback)
      if luasnip.choice_active() then
        luasnip.change_choice()
      else
        fallback()
      end
    end, { "i", "s" }),
		['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
		['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
		['<C-p>'] = cmp.mapping(cmp.mapping.scroll_docs(-2), { 'i', 'c' }),
		['<C-n>'] = cmp.mapping(cmp.mapping.scroll_docs(2), { 'i', 'c' }),
		['<C-;>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		-- ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		-- ["<C-e>"] = cmp.mapping {
		-- 	i = cmp.mapping.abort(),
		-- 	c = cmp.mapping.close(),
		-- },
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		-- ['<C-j>'] = cmp.mapping.confirm({ select = true }),
	},
  formatting = {
    format = custom_format
  },
	sources = cmp.config.sources({
		{ name = 'nvim_lua' },
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'treesitter' },
		{ name = 'buffer' },
		{ name = 'path' },
		-- { name = 'spell' },
	}),
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
	-- view = {
	-- 	entries = 'native'
	-- },
  experimental = {
    ghost_text = false,
  },
}

-- Use buffer source for `/`
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- vim.opt.spell = true
-- vim.opt.spelllang = { 'en_us' }

-- vim.keymap.set('n', '<leader><leader>j', '<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>')
