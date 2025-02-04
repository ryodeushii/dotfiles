-- call this function to apply a color scheme in any module
function ApplyColorScheme(color)
  color = color or "rose-pine-moon"

  vim.cmd.colorscheme(color)

  if color == "rose-pine-moon" then
    local normal = vim.api.nvim_get_hl(0, { name = "NormalNC" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal.bg, fg = normal.fg })
    vim.api.nvim_set_hl(0, "Normal", { bg = normal.bg, fg = normal.fg })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = normal.bg, fg = normal.fg })
  end
end

return {
  {
    "rose-pine/neovim",
    priority = 999,
    lazy = false,
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        highlight_groups = {
          StatusLine = { fg = "love", bg = "love", blend = 10 },
          StatusLineNC = { fg = "subtle", bg = "surface" },
          FloatTitle = { fg = "love", bg = "base" },
          FloatBorder = { fg = "base", bg = "base" },
        },
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
        variant = "moon",
        disable_background = true,
        styles = {
          italic = false,
          bold = false,
          transparency = false,
        },
        enable = {
          terminal = true,
        },
        groups = {},
        palette = {
          moon = {
            _bc = "#100f1a",
            base = "#100f1a",
            gold = "#fabd94",
            rose = "#e599a5",
            -- foam = "#83bccc", -- custom?
            -- iris = "#ac72f2", -- custom?
            -- subtle = "#9a98a7", -- original
            -- _nc = "#1f1d30", -- original
            -- base = "#232136", -- original
            -- surface = "#2a273f",
            -- overlay = "#393552",
            -- muted = "#6e6a86",
            -- subtle = "#908caa",
            -- text = "#e0def4",
            -- love = "#eb6f92",
            -- gold = "#f6c177",
            -- rose = "#ea9a97",
            -- pine = "#3e8fb0", -- original
            -- foam = "#9ccfd8", -- original
            -- iris = "#c4a7e7", --original
            -- leaf = "#95b1ac",
            -- highlight_low = "#2a283e",
            -- highlight_med = "#44415a",
            -- highlight_high = "#56526e",
            -- none = "NONE",
          },
          dawn = {
            _nc = "#f8f0e7",
            base = "#faf4ed",
            surface = "#fffaf3",
            overlay = "#f2e9e1",
            muted = "#9893a5",
            subtle = "#797593",
            text = "#575279",
            love = "#b4637a",
            gold = "#ea9d34",
            rose = "#d7827e",
            pine = "#286983",
            foam = "#56949f",
            iris = "#907aa9",
            leaf = "#6d8f89",
            highlight_low = "#f4ede8",
            highlight_med = "#dfdad9",
            highlight_high = "#cecacd",
            none = "NONE",
          },
          main = {
            _nc = "#16141f",
            base = "#191724",
            surface = "#1f1d2e",
            overlay = "#26233a",
            muted = "#6e6a86",
            subtle = "#908caa",
            text = "#e0def4",
            love = "#eb6f92",
            gold = "#f6c177",
            rose = "#ebbcba",
            pine = "#31748f",
            foam = "#9ccfd8",
            iris = "#c4a7e7",
            leaf = "#95b1ac",
            highlight_low = "#21202e",
            highlight_med = "#403d52",
            highlight_high = "#524f67",
            none = "NONE",
          },
        },
      })

      -- ApplyColorScheme()
    end,
  },
  {
    "vague2k/vague.nvim",
    priority = 999,
    lazy = false,
    config = function()
      require("vague").setup({
        transparent = false, -- don't set background
        style = {
          -- "none" is the same thing as default. But "italic" and "bold" are also valid options
          boolean = "bold",
          number = "none",
          float = "none",
          error = "bold",
          comments = "italic",
          conditionals = "none",
          functions = "none",
          headings = "bold",
          operators = "none",
          strings = "italic",
          variables = "none",

          -- keywords
          keywords = "none",
          keyword_return = "italic",
          keywords_loop = "none",
          keywords_label = "none",
          keywords_exception = "none",

          -- builtin
          builtin_constants = "bold",
          builtin_functions = "none",
          builtin_types = "bold",
          builtin_variables = "none",
        },
        -- plugin styles where applicable
        -- make an issue/pr if you'd like to see more styling options!
        plugins = {
          cmp = {
            match = "bold",
            match_fuzzy = "bold",
          },
          dashboard = {
            footer = "italic",
          },
          lsp = {
            diagnostic_error = "bold",
            diagnostic_hint = "none",
            diagnostic_info = "italic",
            diagnostic_warn = "bold",
          },
          neotest = {
            focused = "bold",
            adapter_name = "bold",
          },
          telescope = {
            match = "bold",
          },
        },
        -- Override colors
        colors = {
          bg = "#141415",
          fg = "#cdcdcd",
          floatBorder = "#878787",
          line = "#252530",
          comment = "#606079",
          builtin = "#b4d4cf",
          func = "#c48282",
          string = "#e8b589",
          number = "#e0a363",
          property = "#c3c3d5",
          constant = "#aeaed1",
          parameter = "#bb9dbd",
          visual = "#333738",
          error = "#df6882",
          warning = "#f3be7c",
          hint = "#7e98e8",
          operator = "#90a0b5",
          keyword = "#6e94b2",
          type = "#9bb4bc",
          search = "#405065",
          plus = "#8cb66d",
          delta = "#f3be7c",
        },
      })
      ApplyColorScheme("ex-vague")
    end,
  },
  {
    "aileot/ex-colors.nvim",
    lazy = true,
    cmd = "ExColors",
    ---@type ExColors.Config
    opts = {},
  },
  -- {
  --   "brenoprata10/nvim-highlight-colors",
  --   event = { 'BufReadPre', 'BufNewFile' },
  --   config = function()
  --     require("nvim-highlight-colors").setup({})
  --   end
  -- }
}
