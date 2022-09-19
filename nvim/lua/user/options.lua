local options = {
	wrap = true,
	number = true,
	cursorline = true,
	incsearch = true,
	ignorecase = true,
	smartcase = true,
	hlsearch = true,
	encoding = 'utf-8',
	backspace = 'indent,eol,start',
	foldmethod = 'syntax',
	foldlevelstart = 99,
	tabstop = 2,
	shiftwidth = 2,
	softtabstop = 2
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
