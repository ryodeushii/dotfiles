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
    "aileot/ex-colors.nvim",
    lazy = true,
    cmd = "ExColors",
    ---@type ExColors.Config
    opts = {
      autocmd_patterns = {
        CmdlineEnter = {
          ["*"] = {
            "^debug%u",
            "^health%u",
          },
        },
      },
    },
  },
  -- {
  --   "brenoprata10/nvim-highlight-colors",
  --   event = { 'BufReadPre', 'BufNewFile' },
  --   config = function()
  --     require("nvim-highlight-colors").setup({})
  --   end
  -- }
}
