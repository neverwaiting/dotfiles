-- This script copy virtual text to clipboard
local M = {}

function M.yank()
  local str = require('utils').get_visual_selection()
  -- avoid expand var in shell(example: $HOME)
  str = string.gsub(str, "\\", "\\\\")
  str = string.gsub(str, "%$", "\\%$")
  if (not str) then return end
  io.popen("cat <<EOF > /tmp/vimcopyfile && xclip -selection clipboard /tmp/vimcopyfile\n".. str.. "\nEOF\n", "w")
end

return M
