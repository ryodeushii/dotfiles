return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    opts = {
      disable_filetype = { "spectre_panel", "snacks_picker_input" },
      disable_in_macro = true, -- disable when recording or executing a macro
      disable_in_visualblock = false, -- disable when insert after visual block mode
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true, -- add bracket pairs after quote
      enable_check_bracket_line = true, --- check bracket in same line
      enable_bracket_in_quote = true, --
      enable_abbr = false, -- trigger abbreviation
      break_undo = true, -- switch for basic rule break undo sequence
      check_ts = false,
      map_cr = true,
      map_bs = true, -- map the <BS> key
      map_c_h = false, -- Map the <C-h> key to delete a pair
      map_c_w = false, -- map <c-w> to delete a pair if possible
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        dependencies = {
          "williamboman/mason-lspconfig.nvim",
          "WhoIsSethDaniel/mason-tool-installer.nvim",
          "neovim/nvim-lspconfig",
        },
      },
    },
    config = function(_, opts)
      local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities())

      require("mason").setup()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier",
          "shfmt",
          "stylua",
          "jq",
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "gopls",
          "jsonls",
          "eslint",
          "biome",
          "bashls",
          "yamlls",
          "dockerls",
          "golangci_lint_ls",
          "clangd",
          "rust_analyzer",
        },
        handlers = {
          function(server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          ["biome"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.biome.setup({
              cmd = { "biome", "lsp-proxy" },
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
              capabilities = capabilities,
              root_dir = lspconfig.util.root_pattern("biome.json", "biome.jsonc"),
            })
          end,

          ["golangci_lint_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.golangci_lint_ls.setup({
              capabilities = capabilities,
              cmd = { "golangci-lint-langserver" },
              filetypes = { "go" },
              root_dir = lspconfig.util.root_pattern("go.mod", ".git"),
              init_options = {
                command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" },
              },
            })
          end,
          ["yamlls"] = function()
            -- NOTE: use the following example as reference in yaml files for specific schema
            -- # yaml-language-server: $schema=https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json
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
          end,

          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({
              on_init = function(client)
                if client.workspace_folders then
                  local path = client.workspace_folders[1].name
                  if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
                    return
                  end
                end
                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                  runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                  },
                  -- Make the server aware of Neovim runtime files
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      -- unpack(vim.api.nvim_get_runtime_file('', true)),
                      vim.env.VIMRUNTIME,
                    },
                  },
                })
              end,
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                  },
                },
              },
            })
          end,
        },
      })
      -- add highlight to line number
      vim.fn.sign_define(
        "DiagnosticSignError",
        { text = "", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" }
      )
      vim.fn.sign_define(
        "DiagnosticSignWarn",
        { text = "", texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" }
      )
      vim.fn.sign_define(
        "DiagnosticSignInfo",
        { text = "", texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" }
      )
      vim.fn.sign_define(
        "DiagnosticSignHint",
        { text = "󰯗", texthl = "DiagnosticSignHint", numhl = "DiagnosticSignHint" }
      )

      vim.diagnostic.config({
        virtual_lines = true,
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
      vim.keymap.set(
        { "n", "v" },
        "<C-q>",
        "<cmd>lua vim.diagnostic.setqflist()<CR>",
        { silent = true, desc = "Show diagnostics as quickfix list" }
      )

      local lspconfig = require("lspconfig")

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

      lspconfig.ts_ls.setup({
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

      -- TODO: enable when rust_analyzer if needed
      -- lspconfig.rust_analyzer.setup({
      --   root_dir = lspconfig.util.root_pattern('Cargo.toml'),
      --   capabilities = capabilities,
      --   on_attach = function(client)
      --     client.server_capabilities.documentFormattingProvider = true
      --   end,
      -- })

      local blink_get_capabilities = require("blink.cmp").get_lsp_capabilities

      for server, config in pairs(opts.servers or {}) do
        config.capabilities = blink_get_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("ts-error-translator").setup({
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      })
    end,
  },
  {
    "ckipp01/nvim-jenkinsfile-linter",
    cmd = "JenkinsfileLinter",
    ft = { "groovy" },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      -- require("jenkinsfile_linter").validate()
      -- this command is used to validate jenkinsfile
      vim.cmd("command! JenkinsfileLinter lua require('jenkinsfile_linter').validate()")
    end,
  },
}
