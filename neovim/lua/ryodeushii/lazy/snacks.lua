return {
  {
    "folke/snacks.nvim",
    dependencies = {
      {
        "kdheepak/lazygit.nvim",
        cmd = {
          "LazyGit",
          "LazyGitConfig",
          "LazyGitCurrentFile",
          "LazyGitFilter",
          "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        keys = {
          { "<leader>gs", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }

      }
    },
    priority = 1000,
    lazy = false,
    keys = {
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      lazygit = { enabled = true }
    },
  }
}
