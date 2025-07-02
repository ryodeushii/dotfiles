local blink = require("blink.cmp")

vim.diagnostic.config({
  virtual_lines = false,
  virtual_text = true,
  update_in_insert = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰯗",
    },
    linehl = {},
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    },
  },
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
})

-- diagnostics to qflist
vim.keymap.set(
  { "n", "v" },
  "<C-q>",
  "<cmd>lua vim.diagnostic.setqflist()<CR>",
  { silent = true, desc = "Show diagnostics as quickfix list" }
)

local capabilities = blink.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
local tools = {
  "gdtoolkit",
  "jq",
  "markdownlint",
  "prettier",
  "shfmt",
  "stylua",
}

local lsps = {
  "bashls",
  "clangd",
  "dockerls",
  "eslint",
  "golangci_lint_ls",
  "gopls",
  "jsonls",
  "lua_ls",
  "pylsp",
  "rust_analyzer",
  "sqlls",
  "vtsls",
  "yamlls",
}

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = lsps,
      automatic_enable = false,
      automatic_installation = true,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    otps = {
      ensure_installed = tools,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")

      lspconfig.yamlls.setup({
        capabilities = capabilities,
        settings = {
          yaml = {
            format = {
              enable = true,
            },
            schemas = {
              kubernetes = "*.yaml",
              ["http://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
              ["https://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
              -- ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks"] = "roles/tasks/*.{yml,yaml}",
              ["https://json.schemastore.org/prettierrc.json"] = ".prettierrc.{yml,yaml}",
              ["http://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
              ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "*play*.{yml,yaml}",
              ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
              ["https://json.schemastore.org/dependabot-2.0"] = ".github/dependabot.{yml,yaml}",
              ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
              ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-{compose,stack}*.{yml,yaml}",
              ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
              ["https://golangci-lint.run/jsonschema/golangci.jsonschema.json"] = ".golangci.{yml,yaml}",
            },
          },
        },
      })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.biome.setup({
        capabilities = capabilities,
        cmd = { "npx", "biome", "lsp-proxy" },
        filetypes = {
          "javascript",
          "javascriptreact",
          "json",
          "jsonc",
          "typescript",
          "typescript.tsx",
          "typescriptreact",
          "astro",
          "svelte",
          "vue",
          "css",
        },
        root_dir = lspconfig.util.root_pattern("biome.json", "biome.jsonc"),
      })

      lspconfig.golangci_lint_ls.setup({
        capabilities = capabilities,
        cmd = { "golangci-lint-langserver" },
        filetypes = { "go" },
        -- root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
        root_dir = lspconfig.util.root_pattern(".golangci.yml", ".golangci.yaml"),
        init_options = {
          command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" },
        },
      })

      lspconfig.gopls.setup({
        capabilities = capabilities,
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        single_file_support = true,
        settings = {
          gopls = {
            analyses = {
              composites = false,
            },
          },
        },
      })

      lspconfig.vtsls.setup({
        capabilities = capabilities,
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
        single_file_support = true,
        handlers = {
          ["textDocument/publishDiagnostics"] = function(_, result, ctx)
            if result.diagnostics ~= nil then
              local idx = 1
              while idx <= #result.diagnostics do
                if result.diagnostics[idx].code == 80001 then
                  table.remove(result.diagnostics, idx)
                else
                  idx = idx + 1
                end
              end
            end
            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
          end,
        },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              maxInlayHintLength = 30,
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
          typescript = {
            preferences = {
              -- importModuleSpecifier = "relative",
              includeCompletionsForModuleExports = true,
              includeCompletionsForImportStatements = true,
              importModuleSpecifier = "relative",
            },
            updateImportsOnFileMove = { enabled = "always" },
            suggest = {
              completeFunctionCalls = true,
            },
            inlayHints = {
              enumMemberValues = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              variableTypes = { enabled = false },
            },
          },
        },
      })

      lspconfig.eslint.setup({
        capabilities = capabilities,
        flags = { debounce_text_changes = 500 },

        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = true
        end,
      })

      lspconfig.rust_analyzer.setup({
        root_dir = lspconfig.util.root_pattern("Cargo.toml"),
        capabilities = capabilities,
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = true
        end,
      })
    end,
  },
}
--       local blink_get_capabilities = require("blink.cmp").get_lsp_capabilities
