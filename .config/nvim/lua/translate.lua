-- This script translates virtual text
vim.api.nvim_create_user_command("TransVtext", function()
  local str = require('utils').get_visual_selection()
  if (not str) then return end
  io.popen("cat <<EOF > /tmp/vimcopyfile && xclip -selection clipboard /tmp/vimcopyfile\n".. str.. "\nEOF\n", "w")
end, {})
