return {
  {
    "ravibrock/spellwarn.nvim",
    event = "VeryLazy",
    config = function()
      require("spellwarn").setup()
      -- use Alt + a or alt + A to add a word to the spellfile
      vim.keymap.set('n', '<A-a>', "zg", { silent = true })
      -- use Alt + s to suggest a word
      vim.keymap.set('n', '<A-s>', "Telescope spell_suggest<CR>", { silent = true })
      -- use Alt + S to toggle spell checking
      vim.keymap.set('n', '<A-S>', ":setlocal spell!<CR>", { silent = true })
    end,
  }
}
