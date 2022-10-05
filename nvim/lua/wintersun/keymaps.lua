local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c'

-- better save(quit,refresh) file
keymap('n', '<leader>w', ':w<CR>', term_opts)
keymap('n', '<leader>q', ':q<CR>', term_opts)
keymap('n', '<leader>a', ':qall<CR>', term_opts)
keymap('n', '<leader>r', ':source %<CR>', term_opts)

-- split window operations
keymap('n', 'sr', ':set splitright<CR>:vsp<CR>', term_opts)
keymap('n', 'sl', ':set nosplitright<CR>:vsp<CR>', term_opts)
keymap('n', 'su', ':set nosplitbelow<CR>:sp<CR>', term_opts)
keymap('n', 'sd', ':set splitbelow<CR>:sp<CR>', term_opts)

-- move window
keymap('n', '<leader>l', '<C-w>l', term_opts)
keymap('n', '<leader>k', '<C-w>k', term_opts)
keymap('n', '<leader>j', '<C-w>j', term_opts)
keymap('n', '<leader>h', '<C-w>h', term_opts)

-- resize with arrows
keymap('n', '<up>', ':resize -3<CR>', term_opts)
keymap('n', '<down>', ':resize +3<CR>', term_opts)
keymap('n', '<left>', ':vertical resize -3<CR>', term_opts)
keymap('n', '<right>', ':vertical resize +3<CR>', term_opts)

-- quick move, move half screen
-- keymap('n', '<S-h>', '<S-h>zz', term_opts)
-- keymap('n', '<S-l>', '<S-l>zz', term_opts)

-- table
keymap('n', 'tu', ':tabe<CR>', term_opts)
keymap('n', 'tl', ':+tabnext<CR>', term_opts)
keymap('n', 'th', ':-tabnext<CR>', term_opts)

-- nvim-tree
keymap('n', '<leader>t', ':NvimTreeToggle<CR>', term_opts)
keymap('n', '<leader>f', ':NvimTreeFindFile<CR>', term_opts)

-- symbols-outoine
keymap('n', 'so', ':SymbolsOutline<CR>', term_opts)

-- bufferline
keymap('n', '<C-h>', ':BufferLineCyclePrev<CR>', term_opts)
keymap('n', '<C-l>', ':BufferLineCycleNext<CR>', term_opts)

-- telescope
keymap('n', 'sj', ':Telescope find_files<CR>', term_opts)
keymap('n', 'sk', ':Telescope treesitter<CR>', term_opts)
keymap('n', 'sh', ':Telescope current_buffer_fuzzy_find<CR>', term_opts)

-- toggle terminal
keymap('n', 'sfl', ':ToggleTerm direction=vertical<CR>', term_opts)
keymap('n', 'sfj', ':ToggleTerm direction=horizontal<CR>', term_opts)
