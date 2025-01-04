-- call this function to apply a color scheme in any module
function ApplyColorScheme(color)
  color = color or "tokyodark"

  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
end

return {
  {
    "tiagovla/tokyodark.nvim",
    priority = 999,
    config = function()
      require("tokyodark").setup({
        transparent_background = true,
        gamma = 1.05,                                                          -- adjust the brightness of the theme
        styles = {
          comments = { italic = false },                                       -- style for comments
          keywords = { italic = false },                                       -- style for keywords
          identifiers = { italic = false },                                    -- style for identifiers
          functions = {},                                                      -- style for functions
          variables = {},                                                      -- style for variables
        },
        custom_highlights = {} or function(highlights, palette) return {} end, -- extend highlights
        custom_palette = {} or function(palette) return {} end,                -- extend palette
        terminal_colors = true,                                                -- enable terminal colors
      })
      ApplyColorScheme()
    end,
  },
}
