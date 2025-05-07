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
        default = function(ctx)
          if vim.bo.filetype == "go" then
            return {
              "lsp",
              "path",
              "buffer",
            }
          elseif vim.bo.filetype == "sql" then
            return { "dadbod", "lsp", "buffer" }
          else
            return {
              "lsp",
              "path",
              "buffer",
            }
          end
        end,
        providers = {
          dadbod = { module = "vim_dadbod_completion.blink", name = "Dadbod" },
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
          cmdline = {
            enabled = function() -- Get the current command-line input
              local line = vim.fn.getcmdline() -- Ignore completion for commands starting with `!`
              return not (vim.startswith(line, "!") or vim.startswith(line, "%!"))
            end,
          },
        },
      })

      opts.cmdline = vim.tbl_deep_extend("force", opts.cmdline or {}, {
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
          "exact",
          "score",
          "sort_text",
        },
      })

      return opts
    end,
  },
}
