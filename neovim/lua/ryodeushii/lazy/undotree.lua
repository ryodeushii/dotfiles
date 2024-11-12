return {
  {
    "tzachar/highlight-undo.nvim",
    config = function()
      require('highlight-undo').setup({
        duration = 300,
      })
    end,
  },
  {
    "mbbill/undotree",

    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end
  }
}
