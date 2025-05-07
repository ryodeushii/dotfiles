vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    lazy = true,
    ft = { "http" },
  },
  {
    "ovk/endec.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("endec").setup({
        popup = {
          enter = true,
          show_title = true,
          close_on = { "<Esc>", "q", "<C-c>" },
        },
      })

      --[[
      Mapping	Description
      gb	Decode Base64 in a popup
      gyb	Decode Base64 in-place
      gB	Encode Base64 in-place
      gs	Decode Base64URL in a popup
      gys	Decode Base64URL in-place
      gS	Encode Base64URL in-place
      gl	Decode URL in a popup
      gyl	Decode URL in-place
      gL	Encode URL in-place
    --]]
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "[t",
        "<cmd>Trouble diagnostics next<cr>",
      },
      {
        "]t",
        "<cmd>Trouble diagnostics prev<cr>",
      },
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tT",
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
    {
      "folke/todo-comments.nvim",
      after = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup({
          signs = true,
          keywords = {
            FIX = {
              icon = "",
              color = "error",
              alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
            },
            TODO = { icon = "", color = "info" },
            HACK = { icon = "", color = "warning" },
            WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
            PERF = { icon = "", color = "warning", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = "", color = "hint", alt = { "INFO" } },
          },
          highlight = {
            before = "",
            keyword = "wide",
            after = "fg",
          },
          colors = {
            error = { "LspDiagnosticsDefaultError", "ErrorMsg" },
            warning = { "LspDiagnosticsDefaultWarning", "WarningMsg" },
            info = { "LspDiagnosticsDefaultInformation", "MoreMsg" },
            hint = { "LspDiagnosticsDefaultHint", "Question" },
          },
          search = {
            command = "rg",
            args = {
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
            },
            -- regex that will be used to match keywords.
            pattern = [[\b(KEYWORDS):]],
          },
        })
      end,
    },
  },
  {
    "kylechui/nvim-surround",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-surround").setup({})
      -- S in visual mode
      -- ys<motion><surround> to add surround
      -- cs<old><new> to change surround for nearest <old> to <new>
      -- csq<char> change nearest quotes pair to <char>
      -- csqb change nearest quotes pair to brackets
    end,
  },
  {
    "tzachar/highlight-undo.nvim",
    keys = { { "u" }, { "<C-r>" } },
    config = function()
      require("highlight-undo").setup({
        duration = 500,
      })
    end,
  },
  {
    "mbbill/undotree",
    keys = { { "<leader>u" } },
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },
}
