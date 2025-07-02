---@diagnostic disable: missing-fields
return {
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    config = function(opts)
      local trouble = require("trouble")

      trouble.setup(opts)
      -- diagnostics (trouble)
      vim.keymap.set("n", "<leader>xx", function()
        trouble.toggle({ mode = "diagnostics" })
      end, { desc = "Toggle Trouble" })
      -- buffer diagnostics (trouble)
      vim.keymap.set("n", "<leader>xX", function()
        trouble.toggle({ mode = "diagnostics", filter = { buf = 0 } })
      end, { desc = "Toggle Trouble Buffer Diagnostics" })
      -- symbols (trouble)
      vim.keymap.set("n", "<leader>cs", function()
        trouble.toggle({ mode = "symbols", focus = false })
      end, { desc = "Toggle Trouble Symbols" })
      -- LSP definitions / references / ... (trouble)
      vim.keymap.set("n", "<leader>cl", function()
        trouble.toggle({ mode = "lsp", focus = false, win = { position = "right" } })
      end, { desc = "Toggle Trouble LSP Definitions / References" })
      -- location list (trouble)
      vim.keymap.set("n", "<leader>xL", function()
        trouble.toggle({ mode = "loclist" })
      end, { desc = "Toggle Trouble Location List" })
      -- quickfix list (trouble)
      vim.keymap.set("n", "<leader>xQ", function()
        trouble.toggle({ mode = "quickfix" })
      end, { desc = "Toggle Trouble Quickfix List" })
    end,
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("ts-error-translator").setup({
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      })
    end,
  },
  {
    "maxandron/goplements.nvim",
    ft = "go",
    opts = {},
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
    },
    keys = {
      {
        "<leader>ys",
        function()
          require("yaml-companion").open_ui_select()
        end,
        desc = "Yaml companion",
      },
    },
  },
}
