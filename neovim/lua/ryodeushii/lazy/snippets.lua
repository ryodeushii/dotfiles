return {
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local ls = require("luasnip")
      ls.setup({})
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)

      -- FIXME: when conventional commits will be rewritten to luasnip
      -- require("luasnip.loaders.from_vscode").lazy_load()
      -- some shorthands...
      local s = ls.snippet
      local sn = ls.snippet_node
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local r = ls.restore_node
      local l = require("luasnip.extras").lambda
      local rep = require("luasnip.extras").rep
      local p = require("luasnip.extras").partial
      local m = require("luasnip.extras").match
      local n = require("luasnip.extras").nonempty
      local dl = require("luasnip.extras").dynamic_lambda
      local fmt = require("luasnip.extras.fmt").fmt
      local fmta = require("luasnip.extras.fmt").fmta
      local types = require("luasnip.util.types")
      local conds = require("luasnip.extras.expand_conditions")

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

      -- conventional commit snippets with dynamic nodes so if no context provided - do not use brackets + use icons for each type
      -- https://www.conventionalcommits.org/en/v1.0.0/
      local scope_choice = c(1, { sn(nil, { t("("), i(1, "scope"), t("): ") }), t(": "), t("!: ") })
      local commit_snippets = {
        s("feat", {
          t("feat"),
          scope_choice,
          t(":sparkles: "),
          i(2, "feature added")
        })
      }
      ls.add_snippets("gitcommit", commit_snippets)
      ls.add_snippets("lazygit", commit_snippets)
    end
  }

}
