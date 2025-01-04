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

local neotest = require("neotest")
neotest.setup({
  adapters = {
    require("neotest-golang"),
  }
})
