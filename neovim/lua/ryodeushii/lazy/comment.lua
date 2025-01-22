return {
  {
    "numToStr/Comment.nvim",
    keys = {"gc", "gcc", "gb"},
    config = function()
      require("Comment").setup()
    end,
  },
}

