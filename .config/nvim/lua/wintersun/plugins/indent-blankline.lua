vim.opt.listchars:append "space:·"

require("indent_blankline").setup {
	indentLine_enabled = 1,
	filetype_exclude = {
		'help',
		'alpha',
		'packer',
		'lspinfo',
		'TelescopePrompt',
		'TelescopeResults',
		'mason',
		'neogitstatus',
		'NvimTree',
		'Trouble'
	},
	buftype_exclude = { 'terminal', 'nofile' },
	show_trailing_blankline_indent = false,
	show_first_indent_level = false,
	show_current_context = true,
	-- show_current_context_start = true,
	context_patterns = {
		"class",
		"return",
		"function",
		"method",
		"^if",
		"^while",
		"jsx_element",
		"^for",
		"^object",
		"^table",
		"block",
		"arguments",
		"if_statement",
		"else_clause",
		"jsx_element",
		"jsx_self_closing_element",
		"try_statement",
		"catch_clause",
		"import_statement",
		"operation_type",
	},
	space_char_blankline = " ",
	-- char_highlight_list = {
	-- 	-- 'IndentBlanklineIndent1',
	-- 	-- 'IndentBlanklineIndent2',
	-- 	-- 'IndentBlanklineIndent3',
	-- 	-- 'IndentBlanklineIndent4',
	-- 	-- 'IndentBlanklineIndent5',
	-- 	'IndentBlanklineIndent3',
	-- },
}

