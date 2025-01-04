return {
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local luasnip = require("luasnip")
      luasnip.setup({})
      vim.keymap.set({ "i", "s" }, "<C-f>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, { desc = "Change choice [snippets]" })

      -- some shorthands...
      local s = luasnip.snippet
      local sn = luasnip.snippet_node
      local t = luasnip.text_node
      local i = luasnip.insert_node
      local c = luasnip.choice_node
      local d = luasnip.dynamic_node
      local r = luasnip.restore_node

      --- trim whitespace and newlines, input is a string, output is a string
      --- @param s string
      --- @return string
      local function trim(str)
        return (str:gsub("^%s*(.-)%s*$", "%1"))
      end
      local author = trim(vim.fn.system("git config --get user.name"))
      local email = trim(vim.fn.system("git config --get user.email"))
      local year = trim(vim.fn.system("date +'%Y'"))

      -- Snippets
      luasnip.add_snippets("all", {
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
            return sn(nil, { r(1, "commit_message", i(nil, "commit message"))
            })
          end, { 1 }),
        }, {})
      }
      luasnip.add_snippets("gitcommit", commit_snippets)
      luasnip.add_snippets("lazygit", commit_snippets)
    end
  }

}
