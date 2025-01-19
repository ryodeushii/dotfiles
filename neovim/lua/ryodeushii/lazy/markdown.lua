return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      { 'echasnovski/mini.icons', version = false },
    }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type render.md.UserConfig
    opts = {},
  },
}
