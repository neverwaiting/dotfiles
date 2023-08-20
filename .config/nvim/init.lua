vim.g.user_dir = 'wintersun'

-- if not set mirror_github_url, default github_url="https://github.com/"
-- vim.g.mirror_github_url = "https://github.91chi.fun/https://github.com/"
vim.g.mirror_github_url = "https://ghproxy.com/https://github.com/"
vim.g.github_url = vim.g.mirror_github_url or 'https://github.com/'

local require_module = function(mod)
	local user_dir = vim.g.user_dir or 'user'
	require(user_dir.. '.'.. mod)
end

require_module('options')
require_module('keymaps')
require_module('lazy')
