return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",

    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
        },
        filetypes = {
          javascript = true,
          typescript = true,
          rust = true,
          lua = true,
          perl = true,
          go = true,
          yaml = true,
          json = true,
          toml = true,
          python = true,
          markdown = true,
          vim = true,
          sh = true,
          bash = true,
          groovy = true,
          c = true,
          cpp = true,
          ["*"] = false,
        }
      })
    end,
  },
}
