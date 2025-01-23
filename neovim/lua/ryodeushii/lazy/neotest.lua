return {
  {
    "nvim-neotest/neotest",
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- "rouge8/neotest-rust",
      { "fredrikaverpil/neotest-golang", version = "*" }, -- Installation
      "nvim-neotest/neotest-jest",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-golang"),
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

      vim.keymap.set("n", "<leader>tc", function()
        neotest.run.run()
      end)

      vim.keymap.set("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end)
    end,
  },
}
