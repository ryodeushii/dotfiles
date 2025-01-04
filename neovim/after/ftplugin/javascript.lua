local set = vim.opt_local

set.shiftwidth = 2

local neotest = require("neotest")
neotest.setup({
  adapters = {
    require("neotest-vitest"),
    require("neotest-jest")({
      jestCommand = "npx jest --json --no-coverage",
      env = { CI = true },
      cwd = function(path)
        return vim.fn.getcwd()
      end,
      jestConfigFile = '',
      jest_test_discovery = false,
    }),
  }
})
