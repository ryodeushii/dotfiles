local js_ts_formatters = { "eslint_fix", "prettier", "biome" }
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({
            async = true,
            stop_after_first = false,
          })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters = {
        eslint_fix = { command = "./node_modules/.bin/eslint", args = { "--fix" } },
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        json = { "jq" },
        jsonc = { "jq" },
        go = { "gofmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        typescript = js_ts_formatters,
        javascript = js_ts_formatters,
        typescriptreact = js_ts_formatters,
        javascriptreact = js_ts_formatters,
      },
    },
  },
}
