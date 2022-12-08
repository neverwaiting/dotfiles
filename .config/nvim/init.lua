vim.g.user_dir = "wintersun"

-- if not set mirror_github_url, default github_url="https://github.com/"
vim.g.mirror_github_url = "https://github.91chi.fun/https://github.com/"

-- 指定lua脚本加载的优先级，值越大代表优先级越高
-- NOTE: 优先级值的设置必须大于或等于200
vim.g.plugins_priority = {
  -- ['packer-startup'] = 999,
  ['keymaps'] = 998,
  ['options'] = 997,
  ['impatient'] = 996,
  ['notify'] = 888,
  ['theme'] = 800,
  ['cmp'] = 700,
  ['neodev'] = 610,
  ['lsp'] = 600
}

-- 可以通过此列表来禁用一些脚本的加载
-- NOTE: 只需要脚本名，不需要带路径和“.lua”后缀
vim.g.plugins_disable = {
  'packer-startup'
}

local packer_bootstrap = require((vim.g.user_dir or 'user') .. '.packer-startup')
if not packer_bootstrap then
  -- 递归加载所有的文件夹中所有lua脚本
  -- 如果文件夹中有init.lua，则只加载init.lua并且不会再往下递归加载目录中的lua脚本，否则加载全部的lua脚本
  require("utils").load_all_plugins()
end
