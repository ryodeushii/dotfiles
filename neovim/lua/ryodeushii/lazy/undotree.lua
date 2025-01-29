return {
  {
    "tzachar/highlight-undo.nvim",
    keys = { { "u" }, { "<C-r>" } },
    config = function()
      require("highlight-undo").setup({
        duration = 500,
      })
    end,
  },
  {
    "mbbill/undotree",
    keys = { { "<leader>u" } },
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },
}
