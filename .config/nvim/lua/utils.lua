local M = {}

local function find_in_disable_tables(item)
  for _,v in ipairs(vim.g.plugins_disable) do
    if (v == item) then return true end
  end
  return false
end

local function require_plugin(plugin)
  local status_ok, errmsg = pcall(require, plugin)
  if not status_ok then
    vim.notify(plugin .. ' module require error!' .. errmsg, vim.log.levels.ERROR)
  end
  return status_ok
end

local function load_plugins_for_path(path, priority)
  local pri = priority or 200
  local plugins = {}
  local command_prefix = 'find ' .. path .. ' -maxdepth 1 '
  local command_find_init_lua = command_prefix .. '-type f -name "init.lua"'
  local init_lua_path = vim.fn.system(command_find_init_lua)
  if init_lua_path:len() ~= 0 then
    local require_file = init_lua_path:match('/lua/(.+)/init%.lua\n$'):gsub('/', '.')
    local plugin_name = require_file:match('.*%.(.+)$')
    if not find_in_disable_tables(plugin_name) then
      if vim.g.plugins_priority[plugin_name] then
        plugins[require_file] = vim.g.plugins_priority[plugin_name]
      else
        pri = pri - 1
        plugins[require_file] = pri
      end
    end
    return plugins, pri
  end

  local command_find_lua = command_prefix .. '-type f -name "*.lua"'
  local files = io.popen(command_find_lua)
  if files then
    for file in files:lines() do
      local require_file = file:match('/lua/(.+)%.lua$'):gsub('/', '.')
      local plugin_name = require_file:match('.*%.(.+)$')
      if not find_in_disable_tables(plugin_name) then
        if vim.g.plugins_priority[plugin_name] then
          plugins[require_file] = vim.g.plugins_priority[plugin_name]
        else
          pri = pri - 1
          plugins[require_file] = pri
        end
      end
    end
  end

  local command_find_dir = command_prefix .. '-type d'
  local dirs = io.popen(command_find_dir)
  if dirs then
    local p = pri
    for dir in dirs:lines() do
      if dir ~= path then
        local plgs, pp = load_plugins_for_path(dir, p)
        for k,v in pairs(plgs) do
          plugins[k] = v
        end
        p = pp
      end
    end
  end
  return plugins
end

local function pairs_by_values (t, f)
  local rt = {}
  for k,v in pairs(t) do
    rt[v] = k
  end
  local a = {}
  for k,_ in pairs(rt) do table.insert(a, k) end
  table.sort(a, f)
  local i = 0      -- iterator variable
  local iter = function ()   -- iterator function
    i = i + 1
    if a[i] == nil then return nil
    else return a[i], rt[a[i]]
    end
  end
  return iter
end

local function sort_compare(a, b)
  return b < a
end

-- ???????????????????????????????????????lua??????
-- ?????????????????????init.lua???????????????init.lua?????????????????????????????????????????????lua??????????????????????????????lua??????
function M.load_all_plugins()
  local user_dir = vim.g.user_dir or "user"
  local path = vim.fn.stdpath('config') .. '/lua/' .. user_dir
  local plugins = load_plugins_for_path(path)
  for _,plugin in pairs_by_values(plugins, sort_compare) do
    if not require_plugin(plugin) then
      return
    end
  end
end

function M.get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

return M
