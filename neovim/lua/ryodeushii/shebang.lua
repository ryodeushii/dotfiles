local M = {}

M.detect_shell = function()
  local shebang = vim.fn.getline(1)
  if shebang:sub(1, 2) ~= "#!" then
    return
  end

  local shebang_parts = vim.split(shebang, "/")
  local shell = shebang_parts[#shebang_parts]
  local filetype = "sh"
  local shells = {
    "bash",
    "zsh",
    "fish",
    "bash2",
    "sh",
  }
  if shell == nil then
    return
  end

  if vim.tbl_contains(shells, shell) then
    filetype = shell
  end

  vim.cmd("set filetype=" .. filetype)
  -- print("Detected shell: " .. filetype)
end

return M
