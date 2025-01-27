local M = {}



local is_ft_correct = function()
  local ft = vim.opt.filetype:get()
  local correct_fts = {
    "bash",
    "zsh",
    "fish",
    "bash2",
    "sh",
  }
  if ft == nil then
    return true
  end

  if vim.tbl_contains(correct_fts, ft) then
    return true
  end

  return false
end

M.detect_shell = function()
  if not is_ft_correct() then
    return
  end

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
