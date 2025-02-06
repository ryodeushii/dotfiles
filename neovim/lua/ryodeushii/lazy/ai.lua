return {
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    cmd = "Codeium",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    version = "*",
    config = function()
      require("codeium").setup({
        enable_cmp_source = true,
        virtual_text = {
          enabled = false,
          map_keys = true,
          key_bindings = {
            accept = "<M-l>",
            clear = "<M-e>",
            next = "<M-j>",
            prev = "<M-k>",
          },
        },
        filetypes = {
          snacks_picker_input = false,
          snacks_input = false,
          oil = false,
        },
        workspace_root = {
          use_lsp = true,
        },
      })
    end,
  },
}
