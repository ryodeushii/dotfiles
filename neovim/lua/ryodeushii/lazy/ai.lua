return {
  {
    "Exafunction/codeium.nvim",
    event = "InsertEnter",
    cmd = "Codeium",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codeium").setup({
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,
          map_keys = true,
          key_bindings = {
            accept = "<M-l>",
            clear = "<M-e>",
            next = "<M-j>",
            prev = "<M-k>",
          },
        },
        ignore_filetypes = {
          "snacks_picker_input",
          "oil",
        },
        workspace_root = {
          use_lsp = true,
        },
      })
    end,
  },
}
