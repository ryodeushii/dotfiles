return {
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
          augend.semver.alias.semver
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
}
