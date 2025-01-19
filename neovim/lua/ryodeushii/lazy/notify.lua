return {
  {
    'mrded/nvim-lsp-notify',
    priority = 666,
    dependencies = { 'rcarriga/nvim-notify' },
    config = function()
      local notify = require('notify')
      notify.setup({
        background_colour = "#4e545b",
        fps = 60,
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = ""
        },
        level = 2,
        minimum_width = 50,
        render = "default",
        stages = "fade_in_slide_out",
        time_formats = {
          notification = "%T",
          notification_history = "%FT%T"
        },
        timeout = 5000,
        top_down = true
      })
      require('lsp-notify').setup({
        notify = require('notify'),
      })
      vim.notify = notify
    end
  },
}
