return {
  {
    "numToStr/Comment.nvim",
    config = function()
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
}
