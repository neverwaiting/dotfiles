local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!.git/*")

telescope.setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
		vimgrep_arguments = vimgrep_arguments,
		prompt_prefix = "  ",
    selection_caret = " ",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
		color_devicons = true,
		-- path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		results_title = '',
    mappings = {
			-- i: insert, n: normal
			--[[
				<C-C>        -> close                           i -> <Up>    -> move_selection_previous         i -> <CR>    -> select_default                  i -> <C-Q>   -> send_to_qflist + open_qflist
				i -> <C-L>   -> complete_tag                    i -> <C-D>   -> preview_scrolling_down          i -> <C-X>   -> select_horizontal               i -> <S-Tab> -> toggle_selection + move_selec…
				i -> <C-N>   -> move_selection_next             i -> <C-U>   -> preview_scrolling_up            i -> <C-T>   -> select_tab                      i -> <Tab>   -> toggle_selection + move_selec…
				i -> <Down>  -> move_selection_next             i -> <PageD… -> results_scrolling_down          i -> <C-V>   -> select_vertical
				i -> <C-P>   -> move_selection_previous         i -> <PageU… -> results_scrolling_up            i -> <M-q>   -> send_selected_to_qflist + ope…
			]]
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        -- ['<C-/>'] = 'which_key',
				['<C-d>'] = false,
				['<C-c>'] = false,
				['<C-x>'] = false,
				['<C-v>'] = false,
				['<C-m>'] = false,
				['<C-J>'] = 'move_selection_next',
				['<C-k>'] = 'move_selection_previous',
				['<C-n>'] = 'preview_scrolling_down',
				['<C-p>'] = 'preview_scrolling_up',
				['<C-u>'] = 'close',
				['<C-l>'] = 'select_vertical',
				['<C-h>'] = 'select_horizontal',
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
		find_files = {
			find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/*' },
		}
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
		fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = 'smart_case',        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

require('telescope').load_extension('fzf')
