return {
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codeium").setup({
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
        },
        workspace_root = {
          use_lsp = true,
        },
      })
    end,
  },
  --[[ {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",

    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
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
  }, ]]
}
