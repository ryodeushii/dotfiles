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
          desc="Open Copilot Chat",
          mode = {"n", "v"},
        }
      },
      -- See Commands section for default commands if you want to lazy load on them
    },
  },
  --[[ {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    cmd = "Codeium",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    version = "*",
    config = function()
      require("codeium").setup({
        enabled = false,
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,
          map_keys = true,
          key_bindings = {
            accept = "<M-l>",
            clear = "<M-e>",
            next = "<M-j>",
            prev = "<M-k>",
          },
          filetypes = {
            snacks_picker_input = false,
            snacks_input = false,
            oil = false,
          },
          default_filetype_enabled = true,
        },
        workspace_root = {
          use_lsp = true,
        },
      })
    end,
  }, ]]
}
