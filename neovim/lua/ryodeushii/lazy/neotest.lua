return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      { lazy = true, "rouge8/neotest-rust", },
      { lazy = true, "fredrikaverpil/neotest-golang", version = "*" }, -- Installation
      { lazy = true, "nvim-neotest/neotest-plenary", },
      { lazy = true, "nvim-neotest/neotest-jest", },
      { lazy = true, "marilari88/neotest-vitest", },
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          -- require("neotest-golang"),
          -- require("neotest-vitest"),
          -- require("neotest-rust") {
          --   args = { "--no-capture" },
          --   dap_adapter = "lldb"
          -- },
          -- require("neotest-jest")({
          --   jestCommand = "npx jest --json --no-coverage",
          --   env = { CI = true },
          --   cwd = function(path)
          --     return vim.fn.getcwd()
          --   end,
          --   jestConfigFile = '',
          --   jest_test_discovery = false,
          -- }),
          require("neotest-plenary")
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
