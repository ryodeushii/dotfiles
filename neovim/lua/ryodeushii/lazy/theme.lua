-- call this function to apply a color scheme in any module
function ApplyColorScheme(color)
  color = color or "rose-pine"

  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
end

return {
  {
    "rose-pine/neovim",
    priority = 999,
    lazy = false,
    name = "rose-pine",
    config = function()
      require('rose-pine').setup({
        highlight_groups = {
          Normal = { bg = "#061111" },
          NormalNC = { bg = "#061111" },
        },
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
        variant = "moon",
        disable_background = true,
        styles = {
          italic = false,
        },
        enable = {
          terminal = true,
        },
      })

      ApplyColorScheme()
    end
  }
}
