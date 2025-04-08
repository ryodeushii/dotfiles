local js_ts_formatters = { "prettier", "biome" }
local function eval_parser(self, ctx)
  local ft = vim.bo[ctx.buf].filetype
  local ext = vim.fn.fnamemodify(ctx.filename, ":e")
  local options = self.options
  local parser = options
    and ((options.ft_parsers and options.ft_parsers[ft]) or (options.ext_parsers and options.ext_parsers[ext]))
  if parser then
    return { "--parser", parser }
  end
end

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
    config = function()
      local util = require("conform.util")
      local cwd_prettier = require("conform.formatters.prettierd").cwd
      require("conform").setup({
        formatters = {
          biome = {
            require_cwd = true,
          },
          biome_organize_imports = {
            require_cwd = true,
          },
          prettier = {
            require_cwd = true,
            command = util.from_node_modules("prettier"),
            args = function(self, ctx)
              return eval_parser(self, ctx) or { "--stdin-filepath", "$FILENAME" }
            end,
            range_args = function(self, ctx)
              local start_offset, end_offset = util.get_offsets_from_range(ctx.buf, ctx.range)
              local args = eval_parser(self, ctx) or { "--stdin-filepath", "$FILENAME" }
              return vim.list_extend(args, { "--range-start=" .. start_offset, "--range-end=" .. end_offset })
            end,
            cwd = util.root_file({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              ".prettierrc.json5",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              ".prettierrc.toml",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
            }),
          },
          jq = {
            require_cwd = true,
          },
          shfmt = {
            prepend_args = { "-i", "2" },
          },
        },
        lang_to_ft = {
          bash = "sh",
        },
        formatters_by_ft = {
          html = { "prettier" }, -- FIXME: enable biome when support is added
          graphql = { "biome" },
          css = { "biome" },
          lua = { "stylua" },
          json = { "jq", "biome" },
          jsonc = { "jq", "biome" },
          go = { "gofmt", "golangci-lint" },
          go_mod = { "gofmt", "golangci-lint" },
          go_sum = { "gofmt", "golangci-lint" },
          markdown = { "prettier", "markdownlint" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
          c = { "clang-format" },
          rust = { "rustfmt" },
          typescript = js_ts_formatters,
          javascript = js_ts_formatters,
          typescriptreact = js_ts_formatters,
          javascriptreact = js_ts_formatters,
        },
      })
    end,
  },
}
