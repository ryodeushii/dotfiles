return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    priority = 998,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      ApplyColorScheme()
      local presets = require("markview.presets")

      -- define custom keymaps to toggle the preview, toggle checkboxes and render the entire file
      --
      -- The default keymaps are:
      -- - <leader>mp to toggle the preview
      -- - <leader>mc to toggle checkboxes
      -- - <leader>mr to render the entire file
      -- - <leader>mi to render the entire file in a new split


      require("markview").setup({
        buf_ignore = { "nofile", "json", "lua" },
        debounce = 50,
        filetypes = { "markdown", "quarto", "rmd" },
        hybrid_modes = nil,
        injections = {},
        initial_state = true,
        -- Max file size that is rendered entirely
        max_file_length = 1000,
        -- Modes where preview is shown
        modes = { "n", "no", "c" },
        -- Lines from the cursor to draw when the
        -- file is too big
        render_distance = 100,
        -- Window configuration for split view
        split_conf = {},
        -- Rendering related configuration
        block_quotes = {},
        callbacks = {},
        checkboxes = presets.checkboxes.nerd,
        code_blocks = {},
        escaped = {},
        footnotes = {},
        headings = presets.headings.marker,
        horizontal_rules = presets.horizontal_rules.thin,
        html = {},
        inline_codes = {},
        latex = {},
        links = {},
        list_items = {},
        tables = {}
      })

      require("markview.extras.checkboxes").setup({
        --- When true, list item markers will
        --- be removed.
        remove_markers = true,

        --- If false, running the command on
        --- visual mode doesn't change the
        --- mode.
        exit = true,

        default_marker = "-",
        default_state = "x",

        --- A list of states
        states = {
          { " ", "x" },
          { "-", "o", "~" }
        }
      })
      require("markview.extras.editor").setup({
        --- The minimum & maximum window width
        --- If the value is smaller than 1 then
        --- it is used as a % value.
        ---@type [ number, number ]
        width = { 10, 0.75 },

        --- The minimum & maximum window height
        ---@type [ number, number ]
        height = { 3, 0.75 },

        --- Delay(in ms) for window resizing
        --- when typing.
        ---@type integer
        debounce = 50,

        --- Callback function to run on
        --- the floating window.
        ---@type fun(buf:integer, win:integer): nil
        callback = function(buf, win)
        end
      })

      require("markview.extras.headings").setup()

      vim.keymap.set("n", "<leader>mhh", "<cmd>HeadingDecrease<CR>",
        { noremap = true, silent = true, desc = "Decrease heading" })
      vim.keymap.set("n", "<leader>mhl", "<cmd>HeadingIncrease<CR>",
        { noremap = true, silent = true, desc = "Increase heading" })
      vim.keymap.set("n", "<leader>mcc", "<cmd>CheckboxToggle<CR>",
        { noremap = true, silent = true, desc = "Toggle checkbox" })
      vim.keymap.set("n", "<leader>mcm", "<cmd>CheckboxNext<CR>",
        { noremap = true, silent = true, desc = "Next checkbox" })
    end,
  }
}
