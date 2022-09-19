-- installed lsp server list
local servers = {
	'jsonls',
	'sumneko_lua',
	'cmake',
	'ccls',
	'bashls',
	'tsserver',
	'vuels',
	'html',
	'cssls'
}

require 'user.plugins.lsp.mason'

require 'mason-lspconfig'.setup {
	ensure_installed = servers,
	automatic_installation = true,
}

-- require 'user.plugins.lsp.null-ls'
local handlers = require 'user.plugins.lsp.handlers'
local lspconfig = require 'lspconfig'

for _, server in pairs(servers) do
	local opts = {
		on_attach = handlers.on_attach,
		capabilities = handlers.capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, 'user.plugins.lsp.settings.' .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend('force', opts, server_custom_opts)
	end
	lspconfig[server].setup(opts)
end

handlers.setup()

