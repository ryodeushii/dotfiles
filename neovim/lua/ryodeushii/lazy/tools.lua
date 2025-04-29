return {
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
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        -- default augends used when no group name is specified
        default = {
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.integer.alias.octal,
          augend.integer.alias.binary,
          augend.constant.alias.bool,
          augend.date.alias["%Y-%m-%d"],
          augend.semver.alias.semver,
        },
      })
      vim.keymap.set("n", "<C-a>", function()
        require("dial.map").manipulate("increment", "normal")
      end)
      vim.keymap.set("n", "<C-x>", function()
        require("dial.map").manipulate("decrement", "normal")
      end)
      vim.keymap.set("n", "g<C-a>", function()
        require("dial.map").manipulate("increment", "gnormal")
      end)
      vim.keymap.set("n", "g<C-x>", function()
        require("dial.map").manipulate("decrement", "gnormal")
      end)
      vim.keymap.set("v", "<C-a>", function()
        require("dial.map").manipulate("increment", "visual")
      end)
      vim.keymap.set("v", "<C-x>", function()
        require("dial.map").manipulate("decrement", "visual")
      end)
      vim.keymap.set("v", "g<C-a>", function()
        require("dial.map").manipulate("increment", "gvisual")
      end)
      vim.keymap.set("v", "g<C-x>", function()
        require("dial.map").manipulate("decrement", "gvisual")
      end)
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
