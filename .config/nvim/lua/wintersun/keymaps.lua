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
keymap('n', '<leader>w', '<cmd>w<CR>', term_opts)
keymap('n', '<leader>q', '<cmd>q<CR>', term_opts)
keymap('n', '<leader>a', '<cmd>qall<CR>', term_opts)
-- keymap('n', '<leader>r', '<cmd>source %<CR>', term_opts)

-- split window operations
keymap('n', 'sr', '<cmd>set splitright<CR><cmd>vsp<CR>', term_opts)
keymap('n', 'sl', '<cmd>set nosplitright<CR><cmd>vsp<CR>', term_opts)
keymap('n', 'su', '<cmd>set nosplitbelow<CR><cmd>sp<CR>', term_opts)
keymap('n', 'sd', '<cmd>set splitbelow<CR><cmd>sp<CR>', term_opts)

-- move window
keymap('n', '<leader>l', '<C-w>l', term_opts)
keymap('n', '<leader>k', '<C-w>k', term_opts)
keymap('n', '<leader>j', '<C-w>j', term_opts)
keymap('n', '<leader>h', '<C-w>h', term_opts)

-- resize with arrows
keymap('n', '<up>', '<cmd>resize -3<CR>', term_opts)
keymap('n', '<down>', '<cmd>resize +3<CR>', term_opts)
keymap('n', '<left>', '<cmd>vertical resize -3<CR>', term_opts)
keymap('n', '<right>', '<cmd>vertical resize +3<CR>', term_opts)

-- line numbers
-- keymap('n', '<leader>n', '<cmd>set nu!<CR>', term_opts)
keymap('n', '<leader>n', '<cmd>set rnu!<CR>', term_opts)

-- quick move, move half screen
-- keymap('n', '<S-h>', '<S-h>zz', term_opts)
-- keymap('n', '<S-l>', '<S-l>zz', term_opts)

-- table
keymap('n', 'tu', '<cmd>tabe<CR>', term_opts)
keymap('n', 'tl', '<cmd>+tabnext<CR>', term_opts)
keymap('n', 'th', '<cmd>-tabnext<CR>', term_opts)

-- netrw
keymap('n', '<leader>t', '<cmd>Ex<CR>', term_opts)
-- format
keymap('n', '<leader>f', 'gg=G<C-o>', term_opts)

-- bufferline
keymap('n', '<C-h>', '<cmd>BufferLineCyclePrev<CR>', term_opts)
keymap('n', '<C-l>', '<cmd>BufferLineCycleNext<CR>', term_opts)

-- telescope
keymap('n', 'sj', '<cmd>Telescope find_files<CR>', term_opts)
keymap('n', 'sk', '<cmd>Telescope treesitter<CR>', term_opts)
keymap('n', 'sh', '<cmd>Telescope current_buffer_fuzzy_find<CR>', term_opts)

-- toggle terminal
keymap('n', 'sfl', '<cmd>ToggleTerm direction=vertical<CR>', term_opts)
keymap('n', 'sfj', '<cmd>ToggleTerm direction=horizontal<CR>', term_opts)

-- unhighlight search
keymap('n', '<esc>', '<cmd>noh<CR>', term_opts)
