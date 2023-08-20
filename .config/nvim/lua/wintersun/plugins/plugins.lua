-- load plugins
local require_module = function(mod)
	local user_dir = vim.g.user_dir or 'user'
	require(user_dir.. '.'.. mod)
end

return {
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  { 'folke/which-key.nvim', lazy = false },

  {
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require_module('plugins.lualine')
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      require_module('plugins.nvim-treesitter')
    end
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end
  },

  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require_module('plugins.telescope')
    end
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },

  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- CMP
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'f3fora/cmp-spell' },-- spell check
  { 'saadparwaiz1/cmp_luasnip' },

  -- neovim bultin function help
  { 'folke/neodev.nvim' },

  -- snippet engine and snippet collections
  { 'L3MON4D3/LuaSnip' }, -- snippets engine written in lua
  { 'rafamadriz/friendly-snippets' }, -- a bunch of snippets to use

  -- comment
  {
    'numToStr/Comment.nvim',
    config = function()
      require 'Comment'.setup()
    end
  },

  -- align text
  { 'godlygeek/tabular' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },

  {
    'iamcco/markdown-preview.nvim',
    config = function ()
      vim.cmd[[pwd]]
      vim.fn["mkdp#util#install"]()
    end
  }
}
