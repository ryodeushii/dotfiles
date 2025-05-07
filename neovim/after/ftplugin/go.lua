local set = vim.opt_local

set.expandtab = false
set.tabstop = 4
set.shiftwidth = 4

if not vim.fn.executable("golangci-lint") then
  error("golangci-lint not installed")
end

vim.api.nvim_command("command! GolangciLintFix !golangci-lint run --fix")
vim.api.nvim_command(
  "command! GolangciLintFixWorkspace !go work edit -json | jq -r '.Use[].DiskPath'  | xargs -I{} golangci-lint run --fix {}/..."
)

vim.keymap.set(
  "n",
  "<leader>lf",
  -- "<cmd>silent! GolangciLintFix<CR>",
  "<cmd>GolangciLintFix<CR>",
  { silent = true, desc = "Run golangci-lint with fix" }
)
