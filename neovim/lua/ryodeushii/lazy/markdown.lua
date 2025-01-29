return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      { "echasnovski/mini.icons", version = false },
    },
    ---@module 'render-markdown'
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type render.md.UserConfig
    opts = {},
  },
}
