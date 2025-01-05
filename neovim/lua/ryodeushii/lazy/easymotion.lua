return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      ---@diagnostic disable-next-line: undefined-doc-name
      ---@type Flash.Config
      local opts = {
        modes = {
          search = {
            enabled = true,
          },
        },
      }
      local flash = require("flash")
      flash.setup(opts)

      vim.keymap.set({ "v", "n", "x" }, "<leader><leader>e", function() flash.jump() end, { desc = "Flash" })
      vim.keymap.set({ "v", "n", "x" }, "s", function() flash.jump() end, { desc = "Flash" })
      vim.keymap.set({ "v", "n", "x" }, "<leader><leader>/", function() flash.toggle() end,
        { desc = "Toggle Flash Search" })
      vim.keymap.set({ "v", "n", "x" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
      vim.keymap.set({ "v", "n", "x" }, "R", function() flash.treesitter_search() end, { desc = "Treesitter Search" })
      vim.keymap.set({ "o" }, "r", function() flash.remote() end, { desc = "Remote Flash" })
    end,
  }
}
