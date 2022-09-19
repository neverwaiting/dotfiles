local plugins = {
	'theme',
	'notify',
	'alpha',
	'lualine',
	'cmp',
	'illuminate',
	'lsp',
	'formatter',
	'fidget',
	'litee',
	'sniprun',
	'telescope',
	'nvim-spectre',
	'nvim-lightbulb',
	'nvim-tree',
	'nvim-treesitter',
	'symbols-outline',
	'bufferline',
	'toggleterm',
	'nvim-session-manager',
	'todo-comments',
	'nvim-colorizer',
	'hop',
	'neoscroll',
	'indent-blankline',
	'winshift',
	'which-key'
}

local current_dir = 'user.plugins'

local function ensure_install_module()
	for _, plugin in ipairs(plugins) do
		local module = current_dir .. '.' .. plugin
		local status_ok, err_or_plugin = pcall(require, module)
		if not status_ok then
			vim.notify(plugin .. ' module not found, please ensure install it! error: ' .. err_or_plugin, 'error')
		end
	end
end

local status_ok, err_or_impatient = pcall(require, 'impatient')
if not status_ok then
	vim.notify('impatient module not found, please ensure install it! error: ' .. err_or_impatient, 'error')
else
	err_or_impatient.enable_profile()
end

ensure_install_module()
