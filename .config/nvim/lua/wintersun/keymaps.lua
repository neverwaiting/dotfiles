local keymap = vim.api.nvim_set_keymap -- Shorten function name
-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c'

local noremap_opts = { noremap = true, silent = true }
local slient_opts = { silent = true }

local allnoremap = function(lhs, rhs)
  keymap('', lhs, rhs, noremap_opts)
end
local nnoremap = function(lhs, rhs)
  if type(rhs) == "function" then
    vim.keymap.set('n', lhs, rhs)
  else
    keymap('n', lhs, rhs, noremap_opts)
  end
end
local vnoremap = function(lhs, rhs)
  keymap('v', lhs, rhs, noremap_opts)
end
local xnoremap = function(lhs, rhs)
  keymap('x', lhs, rhs, noremap_opts)
end
local nmap = function(lhs, rhs)
  keymap('n', lhs, rhs, slient_opts)
end

--Remap space as leader key
allnoremap('<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- better save(quit,refresh) file
nnoremap('<leader>w', '<cmd>w<CR>')
nnoremap('<leader>q', '<cmd>q<CR>')
nnoremap('<leader>a', '<cmd>qall<CR>')
nnoremap('<leader>z', '<cmd>source %<CR><cmd>echo "This file is sourced!"<CR>')

-- split window operations
nnoremap('sr', '<cmd>set splitright<CR><cmd>vsp<CR>')
nnoremap('sl', '<cmd>set nosplitright<CR><cmd>vsp<CR>')
nnoremap('su', '<cmd>set nosplitbelow<CR><cmd>sp<CR>')
nnoremap('sd', '<cmd>set splitbelow<CR><cmd>sp<CR>')

-- move window
nnoremap('<leader>l', '<C-w>l')
nnoremap('<leader>k', '<C-w>k')
nnoremap('<leader>j', '<C-w>j')
nnoremap('<leader>h', '<C-w>h')

-- resize with arrows
nnoremap('<up>', '<cmd>resize -3<CR>')
nnoremap('<down>', '<cmd>resize +3<CR>')
nnoremap('<left>', '<cmd>vertical resize -3<CR>')
nnoremap('<right>', '<cmd>vertical resize +3<CR>')

-- line numbers
-- nnoremap('<leader>n', '<cmd>set nu!<CR>')
nnoremap('<leader>n', '<cmd>set rnu!<CR>')

-- table
nnoremap('tu', '<cmd>tabe<CR>')
nnoremap('tl', '<cmd>+tabnext<CR>')
nnoremap('th', '<cmd>-tabnext<CR>')

-- netrw
nnoremap('<leader>t', '<cmd>Ex<CR>')

-- format
nnoremap('<leader>f', vim.lsp.buf.format)

-- unhighlight search
nnoremap('<esc>', '<cmd>noh<CR>')

-- copy with clipboard
vnoremap('<leader>y', [["+y]])
nnoremap('<leader>y', [["+y]])
nnoremap('<leader>Y', [["+Y]])

-- greatest remap ever
xnoremap('<leader>p', [["_dP]])

-- keep the cursor position unchanged
nnoremap('J', 'mzJ`z')

-- keep the cursor in the middle of the screen
nnoremap('<C-u>', '<C-u>zz')
nnoremap('<C-d>', '<C-d>zz')
nnoremap('n', 'nzzzv')
nnoremap('N', 'Nzzzv')

-- move visual text to anywhere
vnoremap('J', ":m '>+1<CR>gv=gv")
vnoremap('K', ":m '<-2<CR>gv=gv")

-- replace string
nnoremap('<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make excuteable
nnoremap('<leader>x', '<cmd>!chmod +x %<CR>')


vnoremap('<leader>b', ':lua require("translate").trans()<CR>')

-- winshift
nmap('<C-h>', ':WinShift<CR>Jq<leader>k')
nmap('<C-l>', ':WinShift<CR>Lq<leader>h')

-- telescope
nnoremap('sj', '<cmd>Telescope find_files<CR>')
nnoremap('sk', '<cmd>Telescope treesitter<CR>')
nnoremap('sh', '<cmd>Telescope current_buffer_fuzzy_find<CR>')
nnoremap('sv', '<cmd>lua require("wintersun.plugins.telescope").nvim_config()<CR>')
nnoremap('sz', '<cmd>lua require("wintersun.plugins.telescope").zsh_config()<CR>')
nnoremap('sx', '<cmd>lua require("wintersun.plugins.telescope").xconfig()<CR>')

-- toggle terminal
nnoremap('sfl', '<cmd>ToggleTerm direction=vertical<CR>')
nnoremap('sfj', '<cmd>ToggleTerm direction=horizontal<CR>')
