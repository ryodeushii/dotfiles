return {
  {
    "ravibrock/spellwarn.nvim",
    event = "VeryLazy",
    config = function()
      require("spellwarn").setup()
      -- use Alt + a or alt + A to add a word to the spellfile
      vim.keymap.set('n', '<A-a>', "zg", { silent = true, desc = "Add word to allowed spell list" })
      -- -- use Alt + s to suggest a word
      vim.keymap.set('n', '<A-s>', "Telescope spell_suggest<CR>", { silent = true, desc = "Suggest words with telescope" })
      -- -- use Alt + S to toggle spell checking
      vim.keymap.set('n', '<A-S>', ":setlocal spell!<CR>", { silent = true, desc = "Toggle spell checking" })
    end,
  }
}
