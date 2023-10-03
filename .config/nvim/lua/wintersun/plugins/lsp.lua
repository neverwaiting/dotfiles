-- for diagnostics
local signs = {
  { name = 'DiagnosticSignError', text = '' },
  { name = 'DiagnosticSignWarn', text = '' },
  { name = 'DiagnosticSignHint', text = '' },
  { name = 'DiagnosticSignInfo', text = '' },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

local config = {
  -- disable virtual text
  virtual_text = false,
  -- show signs
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
}

vim.diagnostic.config(config)

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'rounded',
})

-- Diagnostic keymaps
vim.keymap.set('n', '<c-K>', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<c-J>', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local function nmap(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    local options = { noremap = true, silent = true, desc = desc }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', keys, func, options)
  end

  -- client.resolved_capabilities.code_action = 
  nmap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', '[R]e[n]ame')
  nmap('<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', '[C]ode [A]ction')

  nmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>', '[G]oto [D]efinition')
  nmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', '[G]oto [I]mplementation')
  nmap('gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', '[G]oto [R]eferences')
  nmap('<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type [D]efinition')
  nmap('<leader>ds', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', '[D]ocument [S]ymbols')
  nmap('<leader>ws', '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>', '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover Documentation')
  -- nmap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', '[G]oto [D]eclaration')
  nmap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- rust_analyzer = {},

  gopls = {},
  pyright = {},
  html = { filetypes = { 'html', 'twig', 'hbs'} },
  tsserver = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  cmake = {},
  jsonls = {},
  ccls = {
    init_options = {
      -- compilationDatabaseDirectory = "build",
      -- index = {
      --   threads = 0;
      -- },
      -- clang = {
      --   excludeArgs = { "-frounding-math"} ;
      -- },
      cache = {
        directory = '/tmp/ccls_cache'
      }
    },

    cmd = { 'ccls' },

    filetypes = { 'c', 'cc', 'cpp', 'objc', 'objcpp', 'cuda' },

    offset_encoding = 'utf-8',

    -- root_dir = root_pattern('compile_commands.json', '.ccls', '.git'),

    -- ccls does not support sending a null root directory
    single_file_support = false,
  }
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require 'mason'.setup {
  max_concurrent_installers = 10,
  github = { download_url_template = vim.g.github_url.. '%s/releases/download/%s/%s' }
}
-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  -- local servers = vim.tbl_keys(servers)
  ensure_installed = { "lua_ls", "cmake", "jsonls", "tsserver", "gopls", "html" },
}

for server_name, _ in pairs(servers) do
  require('lspconfig')[server_name].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = servers[server_name],
    filetypes = (servers[server_name] or {}).filetypes,
  }
end
