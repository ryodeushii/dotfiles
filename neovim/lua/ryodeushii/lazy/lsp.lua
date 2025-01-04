return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    after = "mason.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier",
          "prettierd",
          "shfmt",
        }
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function(_, opts)
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities()
      )

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "ts_ls",
          "gopls",
          "jsonls",
          "eslint",
          "biome",
          "clangd",
          "bashls",
          "ast_grep",
          "yamlls",
          "dockerls",
          "pylsp",
          "csharp_ls",
          "golangci_lint_ls"
        },
        handlers = {
          function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {
              capabilities = capabilities
            }
          end,

          ["golangci_lint_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.golangci_lint_ls.setup {
              capabilities = capabilities,
              cmd = { "golangci-lint-langserver" },
              filetypes = { "go" },
              root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
              init_options = {
                -- command = { "golangci-lint", "run", "--issues-exit-code=1",  },
                command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" },
              },
            }
          end,
          ["yamlls"] = function()
            -- NOTE: use the following example as reference in yaml files for specific schema
            -- # yaml-language-server: $schema=https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json
            local lspconfig = require("lspconfig")
            lspconfig.yamlls.setup {
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
                    ["https://golangci-lint.run/jsonschema/golangci.jsonschema.json"] = ".golangci.{yml,yaml}"
                  }
                }
              }
            }
          end,


          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup {
              on_init = function(client)
                if client.workspace_folders then
                  local path = client.workspace_folders[1].name
                  if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                    return
                  end
                end
                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                  runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                  },
                  -- Make the server aware of Neovim runtime files
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      -- unpack(vim.api.nvim_get_runtime_file('', true)),
                      vim.env.VIMRUNTIME,
                    }
                  }
                })
              end,
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                  }
                }
              }
            }
          end,
        }
      })

      vim.diagnostic.config({
        update_in_insert = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })

      -- diagnostics to qflist
      vim.keymap.set({ "n", "v" }, "<C-q>", "<cmd>lua vim.diagnostic.setqflist()<CR>",
        { silent = true, desc = "Show diagnostics as quickfix list" })


      local lspconfig = require("lspconfig")

      lspconfig.biome.setup({})

      lspconfig.gopls.setup({
        capabilities = capabilities,
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        single_file_support = true,
        settings = {
          gopls = {
            analyses = {
              composites = false,
            }
          }
        },
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
        single_file_support = true,
        settings = {
          typescript = {
            disableAutomaticTypingAcquisition = false,
            tsserver = {
              experimental = {
                enableProjectDiagnostics = true,
              },
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
        root_dir = lspconfig.util.root_pattern('Cargo.toml'),
        capabilities = capabilities,
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = true
        end,
      })

      local blink_get_capabilities = require('blink.cmp').get_lsp_capabilities

      for server, config in pairs(opts.servers or {}) do
        config.capabilities = blink_get_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end
  },
  {
    'dmmulroy/ts-error-translator.nvim',
    config = function()
      require('ts-error-translator').setup({
        filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
      })
    end
  },
  {
    'ckipp01/nvim-jenkinsfile-linter',
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      -- require("jenkinsfile_linter").validate()
      -- this command is used to validate jenkinsfile
      vim.cmd("command! JenkinsfileLinter lua require('jenkinsfile_linter').validate()")
    end,
  }
}
