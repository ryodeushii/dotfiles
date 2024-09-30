return {
  "jaimecgomezz/here.term",
  dependencies = {
    { "willothy/flatten.nvim", config = true, priority = 1001, },
    {
      "goolord/alpha-nvim",
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        local dashboard = require("alpha.themes.dashboard")
        local buttons = {
          type = "group",
          val = {
            { type = "text",    val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
            { type = "padding", val = 1 },
            dashboard.button("e", "  New file", "<cmd>ene<CR>"),
            dashboard.button("SPC f f", "󰈞  Find file"),
            dashboard.button("SPC f s", "󰊄  Live grep"),
            dashboard.button("u", "  Update plugins", "<cmd>Lazy sync<CR>"),
            dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
          },
          position = "center",
        }
        local alpha_config = require("alpha.themes.theta")
        -- available: devicons, mini, default is mini
        -- if provider not loaded and enabled is true, it will try to use another provider
        alpha_config.file_icons.provider = "devicons"
        alpha_config.buttons = buttons
        require("alpha").setup(
          alpha_config.config
        )
      end,

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
