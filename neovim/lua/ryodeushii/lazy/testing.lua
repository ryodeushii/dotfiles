---@diagnostic disable: unused-local
return {
  {
    "nvim-neotest/neotest",
    ft = {
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "rust",
      "go",
      "lua",
      "python",
    },
    dependencies = {
      {
        "marilari88/neotest-vitest",
      },
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust",
      { "fredrikaverpil/neotest-golang", version = "*" }, -- Installation
      "MuntasirSZN/neotest-jest",
      -- "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-plenary"),
          require("neotest-rust"),
          require("neotest-vitest")({
            filter_dir = function(name, rel_path, root)
              return name ~= "node_modules"
            end,
          }),
          require("neotest-golang"),
          require("neotest-jest")({
            jestCommand = "npx -y jest --json --no-coverage",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
            jestConfigFile = "",
            jest_test_discovery = false,
          }),
        },
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
