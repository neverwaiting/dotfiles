require 'hop'.setup {
	keys = 'etovxqpdygfblzhckisuran'
}

keymap = vim.api.nvim_set_keymap

keymap('', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
keymap('', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", {})
keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", {})

keymap('n', '<leader><leader>s', '<cmd>HopChar1<cr>', {})
keymap('n', '<leader><leader>w', '<cmd>HopWord<cr>', {})
keymap('n', '<leader><leader>p', '<cmd>HopPattern<cr>', {})
keymap('n', '<leader><leader>l', '<cmd>HopLineStart<cr>', {})
