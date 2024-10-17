function ApplyColorScheme(color)
  -- used without arg as a workaround for markview
  color = color or "catppuccin"
  -- color = color or "ryodeushii"

  vim.cmd.colorscheme(color)
  -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
end

return {
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup {}
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        term_colors = true,
        transparent_background = false,
        styles = {
          comments = {},
          conditionals = {},
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},

          booleans = {},
          properties = {},

          types = {},
        },
        color_overrides = {
          mocha = {
            rosewater = "#f5e0dc",
            flamingo = "#f2cdcd",
            pink = "#f5c2e7",
            mauve = "#cba6f7",
            red = "#e06c75",
            maroon = "#eba0ac",
            peach = "#fab387",
            yellow = "#e5c07b",
            green = "#98c379",
            teal = "#56b6c2",
            sky = "#89dceb",
            sapphire = "#74c7ec",
            blue = "#61afef",
            lavender = "#b4befe",
            text = "#cdd6f4",
            subtext1 = "#bac2de",
            subtext0 = "#a6adc8",
            overlay2 = "#9399b2",
            overlay1 = "#7f849c",
            overlay0 = "#6f6f6f",
            surface2 = "#525252",
            surface1 = "#393939",
            surface0 = "#262626",
            base = "#161616",
            mantle = "#0b0b0b",
            crust = "#000000"
          },
        },
      })
    end
  },
  {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      terminal_colors = true,
    }
  },
  {
    "tjdevries/colorbuddy.nvim",
  }
}
