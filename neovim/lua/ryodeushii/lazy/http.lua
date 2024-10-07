-- @brief: https://kulala.mwco.app/docs/getting-started/configuration-options#icons
return {
  {
    'mistweaverco/kulala.nvim',
    opts   = {},
    config = function()
      require("kulala").setup({
        split_direction = "vertical",
        default_view = "headers_body",
      })
    end
  },
}
