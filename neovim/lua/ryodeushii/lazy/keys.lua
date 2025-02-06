return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- preset = "modern"
        preset = "helix"
    },
    keys = {
      {
        "<F12>",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
