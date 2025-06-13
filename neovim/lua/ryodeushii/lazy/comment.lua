return {
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle" },
      { "gC", mode = { "n", "v" }, desc = "Comment toggle block" },
      { "gcO", mode = { "n", "v" }, desc = "Comment above" },
      { "gco", mode = { "n", "v" }, desc = "Comment below" },
      { "gcA", mode = { "n", "v" }, desc = "Comment end of line" },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("Comment").setup({
        opleader = {
          line = "gc",
          block = "gC",
        },
        extra = {
          ---Add comment on the line above
          above = "gcO",
          ---Add comment on the line below
          below = "gco",
          ---Add comment at the end of line
          eol = "gcA",
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
