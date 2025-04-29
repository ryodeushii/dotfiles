return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        server_opts_overrides = {
          settings = {
            telemetry = {
              telemetryLevel = "off",
            },
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<A-l>",
            accept_word = false,
            accept_line = false,
            next = "<A-]>",
            prev = "<A-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          snacks_picker_input = false,
          snacks_input = false,
          tfvars = false,
          noice = false,
          oil = false,
          ["*"] = true,
        },
      })
    end,
  },
  {
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      cmd = "CopilotChat",
      branch = "main",
      dependencies = {
        { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
        { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      },
      opts = {
        debug = false, -- Enable debugging
        -- markdown = false,
        -- highlight_headers = true,
        insert_at_end = false,
        -- See Configuration section for rest
      },
      keys = {
        {
          "<leader>ch",
          "<cmd>CopilotChat<CR>",
          silent = true,
          desc = "Open Copilot Chat",
          mode = { "n", "v" },
        },
      },
      -- See Commands section for default commands if you want to lazy load on them
    },
  },
}
