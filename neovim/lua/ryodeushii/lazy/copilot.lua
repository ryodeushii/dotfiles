return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",

    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          -- keymap = {
          --   accept = "<A-l>",
          --   accept_word = false,
          --   accept_line = false,
          --   next = "<A-]>",
          --   prev = "<A-[>",
          --   dismiss = "<C-]>",
          -- },
          --
        },
        filetypes = {
          javascript = true,
          typescript = true,
          rust = true,
          lua = true,
          perl = true,
          go = true,
          yaml = true,
          json = true,
          toml = true,
          python = true,
          markdown = true,
          vim = true,
          sh = true,
          bash = true,
          groovy = true,
          c = true,
          cpp = true,
          ["*"] = false,
        }
      })
    end,
  },
  {
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "main",
      dependencies = {
        { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
        { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
      },
      opts = {
        debug = false, -- Enable debugging
        -- See Configuration section for rest
      },
      -- See Commands section for default commands if you want to lazy load on them
    },
  }
}
