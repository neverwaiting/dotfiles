-- Autocompile for dwm dwmblocks dmenu st slock after saving the config file
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*config.def.h", "*config.h" },
  callback = function()
    local path = vim.fn.expand("%:h") -- get the path of the file
    vim.api.nvim_command("!sudo make install clean -C ".. path)
  end
})
