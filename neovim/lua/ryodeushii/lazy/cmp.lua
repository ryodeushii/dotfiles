--- @module 'blink.cmp'

-- TODO: write custopm cmp source for blink.cmp to complete available versions while in go.mod file
-- go list -m -versions -json github.com/go-playground/validator/v10
-- golang commat to find versions of a module (to use in custom cmp source for go mod)


local npm_versions_sort = function(entry1, entry2)
  local filename = vim.fn.expand('%:t')
  if filename == 'package.json' then
    local source1 = entry1.source_name
    local source2 = entry2.source_name

    -- make source npm has higher priority
    if source1 == 'npm' and source2 ~= 'npm' then
      return true
    end

    if source1 ~= 'npm' and source2 == 'npm' then
      return false
    end

    -- if both source are npm, sort by version
    if source1 == 'npm' and source2 == 'npm' then
      local label1 = entry1.label
      local label2 = entry2.label
      local major1, minor1, patch1 = string.match(label1, '(%d+)%.(%d+)%.(%d+)')
      local major2, minor2, patch2 = string.match(label2, '(%d+)%.(%d+)%.(%d+)')
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
    version = '*',
    lazy = true,
    opts = {},
  },
  {
    "xzbdmw/colorful-menu.nvim",
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require("colorful-menu").setup({
        ls = {
          lua_ls = {
            -- Maybe you want to dim arguments a bit.
            arguments_hl = "@comment",
          },
          gopls = {
            -- When true, label for field and variable will format like "foo: Foo"
            -- instead of go's original syntax "foo Foo".
            add_colon_before_type = false,
          },
          ["typescript-language-server"] = {
            extra_info_hl = "@comment",
          },
          ts_ls = {
            extra_info_hl = "@comment",
          },
          vtsls = {
            extra_info_hl = "@comment",
          },
          ["rust-analyzer"] = {
            -- Such as (as Iterator), (use std::io).
            extra_info_hl = "@comment",
          },
          clangd = {
            -- Such as "From <stdio.h>".
            extra_info_hl = "@comment",
          },
          -- If true, try to highlight "not supported" languages.
          fallback = true,
        },
        -- If the built-in logic fails to find a suitable highlight group,
        -- this highlight is applied to the label.
        fallback_highlight = "@variable",
        -- If provided, the plugin truncates the final displayed text to
        -- this width (measured in display cells). Any highlights that extend
        -- beyond the truncation point are ignored. Default 60.
        max_width = 60,
      })
    end,
  },
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = 'v2.*',
      },
      {
        "ryodeushii/cmp_npm",
        event = { 'BufReadPre', 'BufNewFile' },
        ft = "json",
        dev = true,
        -- set path to local plugin
        dir = vim.fn.stdpath('config') .. '/lua/ryodeushii/cmp_npm',
        dependencies = { 'nvim-lua/plenary.nvim' },
        ft = "json",
        config = function()
          require('ryodeushii.cmp_npm').setup({
            only_latest_version = false,
            only_semantic_versions = true,
          })
        end
      }
    },
    version = "*",
    opts_extend = { "sources.completion.enabled_providers" },
    --- @param _ table @unused
    --- @diagnostic disable-next-line: undefined-doc-name
    --- @param opts blink.cmp.Config
    opts = function(_, opts)
      opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
        default = { "lsp", "path", "snippets", "buffer", "npm", --[[ "codeium" ]] },
        providers = {
          --[[ codeium = {
            name = "codeium",
            module = "blink.compat.source",
            score_offset = 100,
            async = true,
          }, ]]
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
            fallbacks = { "snippets", "buffer" },
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
          cmdline = {
            enabled = function()               -- Get the current command-line input
              local line = vim.fn.getcmdline() -- Ignore completion for commands starting with `!`
              return not vim.startswith(line, '!')
            end
          },
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

      opts.snippets = vim.tbl_deep_extend("force", opts.snippets or {}, {
        preset = "luasnip",
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction) require("luasnip").jump(direction) end,
      })

      opts.appearance = vim.tbl_deep_extend("force", opts.appearance or {}, {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono"
      })

      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        menu = {
          draw = {
            columns = {
              { "kind_icon" }, { "label", gap = 1 }, { "kind" },
            },
            components = {
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then
                    return highlights_info.label
                  else
                    return ctx.label
                  end
                end,
                highlight = function(ctx)
                  local highlights = {}
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then
                    highlights = highlights_info.highlights
                  end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end
                  return highlights
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
          'score',
          'sort_text',
          npm_versions_sort,
        }
      })

      return opts
    end,
  },
}
