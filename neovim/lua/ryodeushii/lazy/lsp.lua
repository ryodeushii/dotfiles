return {
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    opts = {
      disable_filetype = { "spectre_panel", "snacks_picker_input" },
      disable_in_macro = true,        -- disable when recording or executing a macro
      disable_in_visualblock = false, -- disable when insert after visual block mode
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true,         -- add bracket pairs after quote
      enable_check_bracket_line = true, --- check bracket in same line
      enable_bracket_in_quote = true,   --
      enable_abbr = false,              -- trigger abbreviation
      break_undo = true,                -- switch for basic rule break undo sequence
      check_ts = false,
      map_cr = true,
      map_bs = true,   -- map the <BS> key
      map_c_h = false, -- Map the <C-h> key to delete a pair
      map_c_w = false, -- map <c-w> to delete a pair if possible
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function(_, opts)
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities()
      )

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

      -- TODO: enable when rust_analyzer if needed
      -- lspconfig.rust_analyzer.setup({
      --   root_dir = lspconfig.util.root_pattern('Cargo.toml'),
      --   capabilities = capabilities,
      --   on_attach = function(client)
      --     client.server_capabilities.documentFormattingProvider = true
      --   end,
      -- })

      local blink_get_capabilities = require('blink.cmp').get_lsp_capabilities

      for server, config in pairs(opts.servers or {}) do
        config.capabilities = blink_get_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end
  },
  {
    'dmmulroy/ts-error-translator.nvim',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('ts-error-translator').setup({
        filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
      })
    end
  },
  {
    'ckipp01/nvim-jenkinsfile-linter',
    cmd = "JenkinsfileLinter",
    ft = { 'groovy' },
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      -- require("jenkinsfile_linter").validate()
      -- this command is used to validate jenkinsfile
      vim.cmd("command! JenkinsfileLinter lua require('jenkinsfile_linter').validate()")
    end,
  }
}
