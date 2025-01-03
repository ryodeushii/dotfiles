return {
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = 'v2.*',
      },
      {
        "David-Kunz/cmp-npm",
        dependencies = { 'nvim-lua/plenary.nvim' },
        ft = "json",
        config = function()
          require('cmp-npm').setup({
            only_latest_version = false,
            only_semantic_versions = true,
          })
        end
      },
      {
        "Snikimonkd/cmp-go-pkgs",
      },
    },
    version = "*",
    opts_extend = { "sources.completion.enabled_providers" },
    opts = function(_, opts)
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        default = { "lsp", "path", "snippets", "buffer", "luasnip", "npm", "go_pkgs" },
        -- default = { "lsp", "luasnip", "path", "buffer", "npm", "go_pkgs" },
        providers = {
          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            -- When linking markdown notes, I would get snippets and text in the
            -- suggestions, I want those to show only if there are no LSP
            -- suggestions
            -- Disabling fallbacks as my snippets woudlnt show up
            -- fallbacks = { "luasnip", "buffer" },
            score_offset = 90, -- the higher the number, the higher the priority
          },
          luasnip = {
            name = "luasnip",
            enabled = true,
            module = "blink.cmp.sources.luasnip",
            min_keyword_length = 2,
            fallbacks = { "snippets" },
            score_offset = 85,
            max_items = 8,
            -- Only show luasnip items if I type the trigger_text characters, so
            -- to expand the "bash" snippet, if the trigger_text is ";" I have to
            -- type ";bash"
            -- After accepting the completion, delete the trigger_text characters
            -- from the final inserted text
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 3,
            -- When typing a path, I would get snippets and text in the
            -- suggestions, I want those to show only if there are no path
            -- suggestions
            fallbacks = { "luasnip", "buffer" },
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },
          buffer = {
            name = "Buffer",
            enabled = true,
            max_items = 3,
            module = "blink.cmp.sources.buffer",
            min_keyword_length = 4,
          },
          snippets = {
            name = "snippets",
            enabled = true,
            max_items = 3,
            module = "blink.cmp.sources.snippets",
            min_keyword_length = 4,
            score_offset = 80, -- the higher the number, the higher the priority
          },

          npm = {
            name = "npm", -- IMPORTANT: use the same name as you would for nvim-cmp
            module = "blink.compat.source",
            opts = {
              keyword_length = 4
            },
          },
          go_pkgs = {
            name = "go_pkgs",
            module = "blink.compat.source",
            opts = {
              disallow_symbol_nonprefix_matching = false
            }
          }
        },
        -- command line completion, thanks to dpetka2001 in reddit
        -- https://www.reddit.com/r/neovim/comments/1hjjf21/comment/m37fe4d/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        cmdline = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" then
            return { "cmdline" }
          end
          return {}
        end,
      })

      opts.snippets = {
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction) require("luasnip").jump(direction) end,
      }
      opts.appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono"
      }
      opts.completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        menu = {
          draw = {
            columns = {
              { "label",     "label_description", gap = 1 },
              { "kind_icon", "kind" }
            },
          },
        },
      }

      opts.keymap = {
        preset = "default",
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
      }

      opts.signature = { enabled = true }

      return opts
    end,
  },
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
      "j-hui/fidget.nvim",
      "saghen/blink.cmp",
    },
    config = function(_, opts)
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities()
      )

      require("fidget").setup({})
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
                      vim.env.VIMRUNTIME
                      -- Depending on the usage, you might want to add additional paths here.
                      -- "${3rd}/luv/library"
                      -- "${3rd}/busted/library",
                    }
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                    -- library = vim.api.nvim_get_runtime_file("", true)
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
      vim.keymap.set({ "n", "v" }, "<C-q>", "<cmd>lua vim.diagnostic.setqflist()<CR>", { silent = true })


      local lspconfig = require("lspconfig")

      lspconfig.biome.setup({})

      lspconfig.gopls.setup({
        capabilities = capabilities,
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

      for server, config in pairs(opts.servers or {}) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
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
