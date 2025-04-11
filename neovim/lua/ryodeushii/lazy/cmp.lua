local npm_versions_sort = function(entry1, entry2)
  local filename = vim.fn.expand("%:t")
  if filename == "package.json" then
    local source1 = entry1.source_name
    local source2 = entry2.source_name

    -- make source npm has higher priority
    if source1 == "npm" and source2 ~= "npm" then
      return true
    end

    if source1 ~= "npm" and source2 == "npm" then
      return false
    end

    -- if both source are npm, sort by version
    if source1 == "npm" and source2 == "npm" then
      local label1 = entry1.label
      local label2 = entry2.label
      local major1, minor1, patch1 = string.match(label1, "(%d+)%.(%d+)%.(%d+)")
      local major2, minor2, patch2 = string.match(label2, "(%d+)%.(%d+)%.(%d+)")
      if major1 ~= major2 then
        return tonumber(major1) > tonumber(major2)
      end
      if minor1 ~= minor2 then
        return tonumber(minor1) > tonumber(minor2)
      end
      if patch1 ~= patch2 then
        return tonumber(patch1) > tonumber(patch2)
      end
    end
  end

  return false
end

return {
  {
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = {
      {
        "ryodeushii/cmp_npm",
        event = { "BufReadPre package.json", "BufNewFile package.json" },
        dev = true,
        -- set path to local plugin
        dir = vim.fn.stdpath("config") .. "/lua/ryodeushii/cmp_npm",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
          require("ryodeushii.cmp_npm").setup({
            only_latest_version = false,
            only_semantic_versions = true,
          })
        end,
      },
      {
        "ryodeushii/cmp_gopkgs",
        event = { "BufReadPre", "BufNewFile" },
        dev = true,
        -- set path to local plugin
        dir = vim.fn.stdpath("config") .. "/lua/ryodeushii/cmp_gopkgs",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
          local source = require("ryodeushii.cmp_gopkgs")
          require("cmp").register_source("go_pkgs", source.new())
        end,
      },
      {
        "Kaiser-Yang/blink-cmp-git",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    version = "*",
    opts_extend = { "sources.completion.enabled_providers" },
    --- @param _ table @unused
    --- @diagnostic disable-next-line: undefined-doc-name
    --- @class arg_opts blink.cmp.Config
    opts = function(_, arg_opts)
      local opts = arg_opts or {}
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        -- min_keyword_length = function(ctx)
        --   -- only applies when typing a command, doesn't apply to arguments
        --   if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
        --     return 2
        --   end
        --   return 0
        -- end,
        default = {
          "git",
          "lsp",
          "path",
          "buffer",
        },
        per_filetype = {
          sql = { "dadbod", "lsp", "buffer" },
          go = { "go_pkgs", "lsp", "path", "buffer", "git" },
          json = {
            "lsp",
            "git",
            "path",
            "buffer",
            "npm",
          },
        },
        providers = {
          dadbod = { module = "vim_dadbod_completion.blink", name = "Dadbod" },
          git = {
            module = "blink-cmp-git",
            name = "Git",
            opts = {
              -- options for the blink-cmp-git
            },
          },
          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            score_offset = 90, -- the higher the number, the higher the priority
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 3,
            fallbacks = { "buffer" },
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
          go_pkgs = {
            name = "go_pkgs", -- IMPORTANT: use the same name as you would for nvim-cmp
            module = "blink.compat.source",
          },
          npm = {
            name = "npm", -- IMPORTANT: use the same name as you would for nvim-cmp
            module = "blink.compat.source",
            opts = {
              keyword_length = 4,
            },
          },
          cmdline = {
            enabled = function() -- Get the current command-line input
              local line = vim.fn.getcmdline() -- Ignore completion for commands starting with `!`
              return not (vim.startswith(line, "!") or vim.startswith(line, "%!"))
            end,
          },
        },
      })

      opts.cmdline = vim.tbl_deep_extend("force", opts.cmdline or {}, {
        -- command line completion, thanks to dpetka2001 in reddit
        -- https://www.reddit.com/r/neovim/comments/1hjjf21/comment/m37fe4d/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" then
            return { "cmdline" }
          end
          return {}
        end,
        enabled = true,
      })

      opts.appearance = vim.tbl_deep_extend("force", opts.appearance or {}, {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      })

      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = {
          enabled = false,
        },
        menu = {
          auto_show = true,
          -- auto_show = function(ctx)
          --   return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          -- end,
          draw = {
            treesitter = {
              "lsp",
            },
            columns = {
              { "kind_icon" },
              { "label", gap = 1 },
              { "kind" },
              { "source_name" },
            },
            components = {
              label = {
                width = { fill = true, max = 60 },
              },
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                -- Optionally, you may also use the highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
      })

      opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
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
      })

      opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
        enabled = true,
      })

      opts.fuzzy = vim.tbl_deep_extend("force", opts.fuzzy or {}, {
        sorts = {
          "score",
          "sort_text",
          npm_versions_sort,
        },
      })

      return opts
    end,
  },
}
