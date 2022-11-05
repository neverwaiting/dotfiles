-- Automatically install packer
local function ensure_packer()
  local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
			'git',
			'clone',
			'--depth',
			'1',
			(vim.g.mirror_github_url or 'https://github.com/') .. 'wbthomason/packer.nvim',
			install_path
		})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save the 'packer-startup.lua' file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer-startup.lua source <afile> | PackerCompile
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- useage: use plugin table info
-- use {
--   'myusername/example',        -- The plugin location string
--   -- The following keys are all optional
--   disable = boolean,           -- Mark a plugin as inactive
--   as = string,                 -- Specifies an alias under which to install the plugin
--   installer = function,        -- Specifies custom installer. See "custom installers" below.
--   updater = function,          -- Specifies custom updater. See "custom installers" below.
--   after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
--   rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
--   opt = boolean,               -- Manually marks a plugin as optional.
--   bufread = boolean,           -- Manually specifying if a plugin needs BufRead after being loaded
--   branch = string,             -- Specifies a git branch to use
--   tag = string,                -- Specifies a git tag to use. Supports '*' for "latest tag"
--   commit = string,             -- Specifies a git commit to use
--   lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
--   run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
--   requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
--   rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
--   config = string or function, -- Specifies code to run after this plugin is loaded.
--   -- The setup key implies opt = true
--   setup = string or function,  -- Specifies code to run before this plugin is loaded.
--   -- The following keys all imply lazy-loading and imply opt = true
--   cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
--   ft = string or list,         -- Specifies filetypes which load this plugin.
--   keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
--   event = string or list,      -- Specifies autocommand events which load this plugin.
--   fn = string or list          -- Specifies functions which load this plugin.
--   cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
--   module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
--                                -- with one of these module names, the plugin will be loaded.
--   module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When requiring a string which matches one of these patterns, the plugin will be loaded.
-- }

-- local util = require 'packer.util'
-- local join_paths = util.join_paths
-- local stdpath = vim.fn.stdpath
-- local myconfig = {
--   ensure_dependencies   = true, -- Should packer install plugin dependencies?
--   snapshot = nil, -- Name of the snapshot you would like to load at startup
--   snapshot_path = join_paths(stdpath 'cache', 'packer.nvim'), -- Default save directory for snapshots
--   package_root   = join_paths(stdpath 'data', 'site', 'pack'),
--   compile_path = join_paths(stdpath 'config', 'plugin', 'packer_compiled.lua'),
--   plugin_package = 'packer', -- The default package for plugins
--   max_jobs = nil, -- Limit the number of simultaneous jobs. nil means no limit
--   auto_clean = true, -- During sync(), remove unused plugins
--   compile_on_sync = true, -- During sync(), run packer.compile()
--   disable_commands = false, -- Disable creating commands
--   opt_default = false, -- Default to using opt (as opposed to start) plugins
--   transitive_opt = true, -- Make dependencies of opt plugins also opt by default
--   transitive_disable = true, -- Automatically disable dependencies of disabled plugins
--   auto_reload_compiled = true, -- Automatically reload the compiled file after creating it.
--   preview_updates = false, -- If true, always preview updates before choosing which plugins to update, same as `PackerUpdate --preview`.
--   git = {
--     cmd = 'git', -- The base command for git operations
--     subcommands = { -- Format strings for git subcommands
--       update         = 'pull --ff-only --progress --rebase=false',
--       install        = 'clone --depth %i --no-single-branch --progress',
--       fetch          = 'fetch --depth 999999 --progress',
--       checkout       = 'checkout %s --',
--       update_branch  = 'merge --ff-only @{u}',
--       current_branch = 'branch --show-current',
--       diff           = 'log --color=never --pretty=format:FMT --no-show-signature HEAD@{1}...HEAD',
--       diff_fmt       = '%%h %%s (%%cr)',
--       get_rev        = 'rev-parse --short HEAD',
--       get_msg        = 'log --color=never --pretty=format:FMT --no-show-signature HEAD -n 1',
--       submodules     = 'submodule update --init --recursive --progress'
--     },
--     depth = 1, -- Git clone depth
--     clone_timeout = 60, -- Timeout, in seconds, for git clones
--     default_url_format = 'https://github.91chi.fun/https://github.com/%s.git' -- 'https://github.com/%s.git' Lua format string used for "aaa/bbb" style plugins
--   },
--   display = {
--     non_interactive = false, -- If true, disable display windows for all operations
--     compact = false, -- If true, fold updates results by default
--     open_fn  = nil, -- An optional function to open a window for packer's display
--     open_cmd = '65vnew \\[packer\\]', -- An optional command to open a window for packer's display
--     working_sym = '⟳', -- The symbol for a plugin being installed/updated
--     error_sym = '✗', -- The symbol for a plugin with an error in installation/updating
--     done_sym = '✓', -- The symbol for a plugin which has completed installation/updating
--     removed_sym = '-', -- The symbol for an unused plugin which was removed
--     moved_sym = '→', -- The symbol for a plugin which was moved (e.g. from opt to start)
--     header_sym = '━', -- The symbol for the header line in packer's display
--     show_all_info = true, -- Should packer show all update details automatically?
--     prompt_border = 'double', -- Border style of prompt popups.
--     keybindings = { -- Keybindings for the display window
--       quit = 'q',
--       toggle_update = 'u', -- only in preview
--       continue = 'c', -- only in preview
--       toggle_info = '<CR>',
--       diff = 'd',
--       prompt_revert = 'r',
--     }
--   },
--   luarocks = {
--     python_cmd = 'python' -- Set the python command to use for running hererocks
--   },
--   log = { level = 'warn' }, -- The default print log level. One of: "trace", "debug", "info", "warn", "error", "fatal".
--   profile = {
--     enable = false,
--     threshold = 1, -- integer in milliseconds, plugins which load faster than this won't be shown in profile output
--   },
--   autoremove = false, -- Remove disabled or unused plugins without prompting the user
-- }

packer.startup {
  function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    ---------------------------
    ----- my plugins here -----
    ---------------------------
    use "lewis6991/impatient.nvim" -- Speed up loading Lua modules
    -- use "rcarriga/nvim-notify" -- notify
    use "nvim-lua/plenary.nvim" -- useful lua functions used any lots of plugins
    use "kyazdani42/nvim-web-devicons" -- nerd font icons

    -- LSP
    -- ---
    -- simple to use language server installer	
    use 'williamboman/mason.nvim'
    -- closes some gaps that exist between mason.nvim and lspconfig
    use 'williamboman/mason-lspconfig.nvim'
    -- configurations for nvim LSP
    use 'neovim/nvim-lspconfig'
    -- show function signature when you type
    use 'ray-x/lsp_signature.nvim'
    -- for formatters and linters
    use	'jose-elias-alvarez/null-ls.nvim'
    -- a format runner for Neovim written in Lua.
    use 'mhartington/formatter.nvim'
    -- standalone UI for nvim-lsp progress
    use 'j-hui/fidget.nvim'

    -- CMP
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'f3fora/cmp-spell' -- spell check
    use 'saadparwaiz1/cmp_luasnip'

    use 'folke/neodev.nvim' -- neovim bultin function help

    -- snippet engine and snippet collections
    use 'L3MON4D3/LuaSnip' -- snippets engine written in lua
    use 'rafamadriz/friendly-snippets' -- a bunch of snippets to use

    -- code action
    use {
      'kosayoda/nvim-lightbulb',
      requires = 'antoinemadec/FixCursorHold.nvim'
    }
    use {
      'numToStr/Comment.nvim',
      config = function()
        require 'Comment'.setup()
      end
    }

    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
    }

    -- display all diagnostics list
    use {
      'folke/trouble.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
    }
    use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
        require('nvim-treesitter.install').update({ with_sync = true })
      end
    }
    -- automatically highlighting other uses of the word under the cursor
    use 'RRethy/vim-illuminate'
    -- indent line
    use 'lukas-reineke/indent-blankline.nvim'
    -- a color highlighter
    use 'NvChad/nvim-colorizer.lua'

    -- a very nice tools for c/c++ user
    use 'Shatur/neovim-cmake'
    -- use 'Civitasv/cmake-tools.nvim'
    -- display calltree
    use 'ldelossa/litee.nvim'
    use 'ldelossa/litee-calltree.nvim'
    -- run program in editor
    use {
      'michaelb/sniprun',
      run = 'bash ./install.sh'
    }

    -- workspace restore manager
    use 'Shatur/neovim-session-manager'
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.0' }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }
    -- a search panel for neovim.(can replace)
    use 'windwp/nvim-spectre'
    -- float terminal
    use {
      'akinsho/toggleterm.nvim',
      tag = '*'
    }
    -- file explorer
    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    -- buffer tag
    use {
      'akinsho/bufferline.nvim', tag = "v2.*",
      requires = 'kyazdani42/nvim-web-devicons'
    }
    -- symbols display
    use 'simrat39/symbols-outline.nvim'
    -- status line on bottom
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- colorscheme or theme
    use 'projekt0n/github-nvim-theme' -- nvim-theme
    use { 'catppuccin/nvim', as = 'catppuccin' }
    use 'sainnhe/gruvbox-material'

    -- dashboard
    -- use 'goolord/alpha-nvim'

    -- smooth scrolling
    -- use 'karb94/neoscroll.nvim'

    -- easy movesition
    -- use {
    -- 	'phaazon/hop.nvim',
    -- 	branch = 'v2', -- optional but strongly recommended
    -- }
    use 'godlygeek/tabular' -- align text
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    -- easy to change split windows position
    use 'sindrets/winshift.nvim'

    -- query all keymaps
    use 'folke/which-key.nvim'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end,

  config = {
    -- Have packer use a popup window
    display = {

      open_fn = function()
        local result, win, buf = require('packer.util').float({border = "rounded"})
        vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:Normal')
        return result, win, buf
      end,
    },

    git = {
      default_url_format = (vim.g.mirror_github_url or 'https://github.com/') .. "%s.git"
    }
  }
}

return packer_bootstrap
