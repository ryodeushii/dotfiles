return {
  "folke/todo-comments.nvim",
  after = "nvim-lua/plenary.nvim",
  config = function()
    require("todo-comments").setup({
      signs = true,
      keywords = {
        FIX = {
          icon = "",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = "", color = "info" },
        HACK = { icon = "", color = "warning" },
        WARN = { icon = "", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "", color = "warning", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "", color = "hint", alt = { "INFO" } },
      },
      highlight = {
        before = "",
        keyword = "wide",
        after = "fg",
      },
      colors = {
        error = { "LspDiagnosticsDefaultError", "ErrorMsg" },
        warning = { "LspDiagnosticsDefaultWarning", "WarningMsg" },
        info = { "LspDiagnosticsDefaultInformation", "MoreMsg" },
        hint = { "LspDiagnosticsDefaultHint", "Question" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        pattern = [[\b(KEYWORDS):]],
      },
    })
  end,
}
