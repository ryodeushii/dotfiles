return {
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local ls = require("luasnip")
      ls.setup({})
      vim.keymap.set({ "i", "s" }, "<C-s>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)

      -- FIXME: when conventional commits will be rewritten to luasnip
      -- require("luasnip.loaders.from_vscode").lazy_load()
      -- some shorthands...
      local s = ls.snippet
      local sn = ls.snippet_node
      local isn = ls.indent_snippet_node
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local r = ls.restore_node
      local events = require("luasnip.util.events")
      local ai = require("luasnip.nodes.absolute_indexer")
      local extras = require("luasnip.extras")
      local l = extras.lambda
      local rep = extras.rep
      local p = extras.partial
      local m = extras.match
      local n = extras.nonempty
      local dl = extras.dynamic_lambda
      local fmt = require("luasnip.extras.fmt").fmt
      local fmta = require("luasnip.extras.fmt").fmta
      local conds = require("luasnip.extras.expand_conditions")
      local postfix = require("luasnip.extras.postfix").postfix
      local types = require("luasnip.util.types")
      local parse = require("luasnip.util.parser").parse_snippet
      local ms = ls.multi_snippet
      local k = require("luasnip.nodes.key_indexer").new_key

      -- trim whitespace and newlines, input is a string, output is a string
      --- @param s string
      --- @return string
      local function trim(s)
        return (s:gsub("^%s*(.-)%s*$", "%1"))
      end
      local author = trim(vim.fn.system("git config --get user.name"))
      local email = trim(vim.fn.system("git config --get user.email"))
      local year = trim(vim.fn.system("date +'%Y'"))

      -- Snippets
      ls.add_snippets("all", {
        s("copyright", {
          t("© " .. year .. " "),
          i(1, author),
          i(2, string.format(" <%s>", email)),
        }),
      })

      local types_table = {
        feat     = "✨",
        fix      = "🐛",
        chore    = "♻️",
        docs     = "📚",
        style    = "💎",
        refactor = "📦",
        perf     = "🚀",
        test     = "🚨",
        build    = "🛠",
        ci       = "⚙️",
        revert   = "🗑",
      }

      -- conventional commit snippets with dynamic nodes so if no context provided - do not use brackets + use icons for each type
      -- https://www.conventionalcommits.org/en/v1.0.0/
      local commit_snippets = {
        s("commit", {
          c(1, {
            t("feat"),
            t("fix"),
            t("chore"),
            t("docs"),
            t("style"),
            t("refactor"),
            t("perf"),
            t("test"),
            t("build"),
            t("ci"),
            t("revert"),
          }),
          c(2, {
            sn(nil, { t("("), i(1, "scope"), t("): ") }), t(": "), t("!: ")
          }),
          d(3,
            function(args)
              local type = args[1][1]
              return sn(nil, { t(string.format(" %s ", types_table[type] or "")) })
            end, { 1 }),
          d(4, function(args)
            local type = args[1][1]
            return sn(nil, { r(1, "commit_message", i(nil, "commit message"))
            })
          end, { 1 }),
        }, {})
      }
      ls.add_snippets("gitcommit", commit_snippets)
      ls.add_snippets("lazygit", commit_snippets)
    end
  }

}
