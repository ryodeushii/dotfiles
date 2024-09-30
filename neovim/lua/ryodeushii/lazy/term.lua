return {
  "jaimecgomezz/here.term",
  dependencies = {
    { "willothy/flatten.nvim", config = true, priority = 1001, },
    {
      "goolord/alpha-nvim",
      config = function()
        require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
      end
    },
  },
  config = function()
    local term = require("here-term")
    term.setup({
      startup_command = "Alpha",
    })

    vim.api.nvim_set_keymap("n", "<C-t>", "<cmd> lua require('here-term').toggle_terminal()<CR>",
      { noremap = true, silent = true, desc = "Toggle terminal" })
    vim.api.nvim_set_keymap("t", "<C-t>", "<cmd> lua require('here-term').toggle_terminal()<CR>",
      { noremap = true, silent = true, desc = "Toggle terminal" })
  end,
}
