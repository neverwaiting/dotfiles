require('tokyonight').setup({
  style = 'moon',
  transparent = true,
  lualine_bold = true,
  on_colors = function(colors)
    colors.hint = colors.orange
    colors.error = "#ff0000"
  end
})
