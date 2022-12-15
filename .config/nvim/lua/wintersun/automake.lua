-- Autocompile for dwm dwmblocks dmenu st after saving config
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*config.def.h", "*config.h" },
  callback = function()
    local path = vim.fn.expand("%:h")
    vim.api.nvim_command("!sudo make install clean -C ".. path)
  end
})
