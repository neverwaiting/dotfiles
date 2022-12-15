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
keymap('n', '<leader>w', '<cmd>w<CR>', opts)
keymap('n', '<leader>q', '<cmd>q<CR>', opts)
keymap('n', '<leader>a', '<cmd>qall<CR>', opts)
keymap('n', '<leader>z', '<cmd>source %<CR>', {})

-- split window operations
keymap('n', 'sr', '<cmd>set splitright<CR><cmd>vsp<CR>', opts)
keymap('n', 'sl', '<cmd>set nosplitright<CR><cmd>vsp<CR>', opts)
keymap('n', 'su', '<cmd>set nosplitbelow<CR><cmd>sp<CR>', opts)
keymap('n', 'sd', '<cmd>set splitbelow<CR><cmd>sp<CR>', opts)

-- move window
keymap('n', '<leader>l', '<C-w>l', opts)
keymap('n', '<leader>k', '<C-w>k', opts)
keymap('n', '<leader>j', '<C-w>j', opts)
keymap('n', '<leader>h', '<C-w>h', opts)

-- resize with arrows
keymap('n', '<up>', '<cmd>resize -3<CR>', opts)
keymap('n', '<down>', '<cmd>resize +3<CR>', opts)
keymap('n', '<left>', '<cmd>vertical resize -3<CR>', opts)
keymap('n', '<right>', '<cmd>vertical resize +3<CR>', opts)

-- line numbers
-- keymap('n', '<leader>n', '<cmd>set nu!<CR>', opts)
keymap('n', '<leader>n', '<cmd>set rnu!<CR>', opts)

-- table
keymap('n', 'tu', '<cmd>tabe<CR>', opts)
keymap('n', 'tl', '<cmd>+tabnext<CR>', opts)
keymap('n', 'th', '<cmd>-tabnext<CR>', opts)

-- netrw
keymap('n', '<leader>t', '<cmd>Ex<CR>', opts)
-- format
keymap('n', '<leader>f', 'gg=G<C-o>', opts)
-- copy virtual text to system clipboard
-- keymap('v', '<leader>p', ":w !xclip -selection clipboard<CR><CR>:echo 'Already copy to system clipboard!'<CR>", opts) -- don't use <cmd>

-- bufferline
-- keymap('n', '<C-h>', '<cmd>BufferLineCyclePrev<CR>', opts)
-- keymap('n', '<C-l>', '<cmd>BufferLineCycleNext<CR>', opts)

-- telescope
keymap('n', 'sj', '<cmd>Telescope find_files<CR>', opts)
keymap('n', 'sk', '<cmd>Telescope treesitter<CR>', opts)
keymap('n', 'sh', '<cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
keymap('n', 'sv', '<cmd>lua require("wintersun.plugins.telescope").nvim_config()<CR>', opts)
keymap('n', 'sz', '<cmd>lua require("wintersun.plugins.telescope").zsh_config()<CR>', opts)
keymap('n', 'sx', '<cmd>lua require("wintersun.plugins.telescope").xconfig()<CR>', opts)

-- toggle terminal
keymap('n', 'sfl', '<cmd>ToggleTerm direction=vertical<CR>', opts)
keymap('n', 'sfj', '<cmd>ToggleTerm direction=horizontal<CR>', opts)

-- unhighlight search
keymap('n', '<esc>', '<cmd>noh<CR>', opts)

keymap('v', '<leader>y', ':lua require("clipboard").yank()<CR>:echo "Already copy to clipboard!"<CR>', opts)
keymap('v', '<leader>b', ':lua require("translate").trans()<CR>', opts)

-- winshift
keymap('n', '<C-h>', ':WinShift<CR>Jq<leader>k', term_opts)
keymap('n', '<C-l>', ':WinShift<CR>Lq<leader>h', term_opts)
