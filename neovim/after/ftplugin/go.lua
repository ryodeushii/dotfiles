local set = vim.opt_local

set.expandtab = false
set.tabstop = 4
set.shiftwidth = 4

vim.keymap.set(
  "n",
  "<space>td",
  function()
    require("dap-go").debug_test()
  end,
  {
    buffer = 0, desc = "[Golang] Debug test"
  }
)

if not vim.fn.executable("golangci-lint") then
  error("golangci-lint not installed")
end


vim.api.nvim_command("command! GolangciLintFix !golangci-lint run --fix")
vim.keymap.set(
  "n",
  "<leader>lf",
  -- "<cmd>silent! GolangciLintFix<CR>",
  "<cmd>GolangciLintFix<CR>",
  { silent = true, desc = "Run golangci-lint with fix" }
)

-- when lsp format used in go, it should call lsp format commadn and then call GolangciLintFix
vim.keymap.del("n", "<leader>f")
vim.keymap.set(
  "n",
  "<leader>f",
  function()
    vim.lsp.buf.format()
    -- vim.cmd("GolangciLintFix")
    vim.cmd("silent! GolangciLintFix")
  end,
  { desc = "[go] Format buffer and golangci-lint-fix", silent = true }
)

