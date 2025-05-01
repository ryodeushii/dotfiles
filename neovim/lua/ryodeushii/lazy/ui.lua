-- call this function to apply a color scheme in any module
function ApplyColorScheme(color)
  color = color or "rose-pine-moon"

  vim.cmd.colorscheme(color)

  if color == "rose-pine-moon" then
    local normal = vim.api.nvim_get_hl(0, { name = "NormalNC" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal.bg, fg = normal.fg })
    vim.api.nvim_set_hl(0, "Normal", { bg = normal.bg, fg = normal.fg })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = normal.bg, fg = normal.fg })
  end
end

-- FIXME: get rid?
-- vim.api.nvim_create_autocmd("LspProgress", {
--   ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
--   callback = function(ev)
--     local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
--     vim.notify(vim.lsp.status(), "info", {
--       id = "lsp_progress",
--       title = "LSP Progress",
--       opts = function(notif)
--         notif.icon = ev.data.params.value.kind == "end" and " "
--           or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
--       end,
--     })
--   end,
-- })

return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, { desc = "next hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, { desc = "previous hunk" })

          -- Actions
          map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage hunk" })
          map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "reset hunk" })
          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "stage hunk" })
          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "reset hunk" })
          map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "stage buffer" })
          map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "undo stage hunk" })
          map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "reset buffer" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "preview hunk" })
          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "blame line" })
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "toggle current line blame" })
          map("n", "<leader>hd", gitsigns.diffthis, { desc = "diff this hunk" })
          map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end, { desc = "diff this buffer?" })
          map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "toggle deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select hunk" })
        end,
      })
    end,
  }, -- icons
  {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup()
    end,
  },
  -- theme
  {
    "aileot/ex-colors.nvim",
    lazy = true,
    cmd = "ExColors",
    opts = {
      autocmd_patterns = {
        CmdlineEnter = {
          ["*"] = {
            "^debug%u",
            "^health%u",
          },
        },
      },
    },
  },
  -- {
  --   "brenoprata10/nvim-highlight-colors",
  --   event = { 'BufReadPre', 'BufNewFile' },
  --   config = function()
  --     require("nvim-highlight-colors").setup({})
  --   end
  -- }

  -- snacks
  {
    "folke/snacks.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      styles = {
        notification = {
          wo = {
            wrap = true,
          },
        },
      },
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1,
      },
      bigfile = {},
      dashboard = {
        preset = {
          header = [[

██████╗ ██╗   ██╗ ██████╗ ██████╗ ███████╗██╗   ██╗███████╗██╗  ██╗██╗██╗
██╔══██╗╚██╗ ██╔╝██╔═══██╗██╔══██╗██╔════╝██║   ██║██╔════╝██║  ██║██║██║
██████╔╝ ╚████╔╝ ██║   ██║██║  ██║█████╗  ██║   ██║███████╗███████║██║██║
██╔══██╗  ╚██╔╝  ██║   ██║██║  ██║██╔══╝  ██║   ██║╚════██║██╔══██║██║██║
██║  ██║   ██║   ╚██████╔╝██████╔╝███████╗╚██████╔╝███████║██║  ██║██║██║
╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝╚═╝



        ]],
        },
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      lazygit = {},
      indent = { enabled = true },
      scope = { enabled = false, min_size = 2, cursor = true, edge = true, debounce = 30 },
      -- input = {
      --   enabled = true,
      --   b = { completion = false },
      --   bo = {
      --     filetype = "snacks_input",
      --     buftype = "prompt",
      --   },
      -- },
      notifier = {
        enabled = true,
        timeout = 5000,
        style = "fancy",
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
      },
      quickfile = { enabled = true },
      picker = {
        enabled = true,
        ui_select = true,
        previewers = {
          file = {
            max_size = 5 * 1024 * 1024, -- 5MB
          },
        },
      },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = true, -- show open fold icons
          git_hl = false, -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      words = { enabled = false },
    },

    keys = function()
      local Snacks = require("snacks")
      return {
        {
          "<leader>ff",
          function()
            Snacks.picker.files({ hidden = true })
          end,
          desc = "Find files",
        },
        {
          "<C-p>",
          function()
            Snacks.picker.files({ hidden = true })
          end,
          desc = "Find files",
        },
        {
          "<leader>fg",
          function()
            Snacks.picker.git_files()
          end,
          desc = "Find Git files",
        },
        {
          "<leader>fb",
          function()
            Snacks.picker.buffers()
          end,
          desc = "Find Buffers",
        },
        {
          "<leader>fs",
          function()
            Snacks.picker.grep({ hidden = true })
          end,
          desc = "Grep",
        },
        {
          "<leader>ps",
          function()
            Snacks.picker.grep({ buffers = true })
          end,
          desc = "Grep",
        },
        {
          "<leader>fr",
          function()
            Snacks.picker.resume()
          end,
          desc = "Resume",
        },
        {
          "<leader>fo",
          function()
            Snacks.picker.recent()
          end,
          desc = "Recent files",
        },
        {
          "<leader>fw",
          function()
            Snacks.picker.grep_word()
          end,
          desc = "Visual selection or word",
          mode = { "n", "x", "v" },
        },
        {
          "<leader>fh",
          function()
            Snacks.picker.help()
          end,
          desc = "Help Pages",
        },
        {
          "<leader>fk",
          function()
            Snacks.picker.keymaps()
          end,
          desc = "Keymaps",
        },
        {
          "<leader>fn",
          function()
            Snacks.picker.notifications()
          end,
          desc = "Notifications",
        },
        {
          "<leader>gl",
          function()
            Snacks.picker.git_log()
          end,
          desc = "Git log",
        },
        {
          "<leader>ft",
          function()
            Snacks.picker.todo_comments()
          end,
          desc = "Git status",
        },
        {
          "<leader>fp",
          function()
            Snacks.picker()
          end,
          desc = "List pickers",
        },

        -- lsp related
        {
          "<leader>vd",
          function()
            Snacks.picker.diagnostics()
          end,
          desc = "Diagnostics",
        },
        {
          "<leader>vws",
          function()
            Snacks.picker.lsp_workspace_symbols()
          end,
          desc = "Diagnostics",
        },
        {
          "gd",
          function()
            Snacks.picker.lsp_definitions()
          end,
          desc = "Goto Definition",
        },
        {
          "gtd",
          function()
            Snacks.picker.lsp_type_definitions()
          end,
          desc = "Goto T[y]pe Definition",
        },
        {
          "gr",
          function()
            Snacks.picker.lsp_references()
          end,
          nowait = true,
          desc = "References",
        },
        {
          "<leader>vrr",
          function()
            Snacks.picker.lsp_references()
          end,
          nowait = true,
          desc = "References",
        },
        {
          "gi",
          function()
            Snacks.picker.lsp_implementations()
          end,
          desc = "Goto Implementation",
        },
        {
          "<leader>fl",
          function()
            Snacks.picker.lsp_symbols()
          end,
          desc = "LSP Symbols",
        },
        {
          "<leader>fz",
          function()
            Snacks.picker.zoxide()
          end,
          desc = "Zoxide picker",
        },
        {
          "<leader>gs",
          function()
            Snacks.lazygit()
          end,
          desc = "LazyGit",
        },
        {
          '<leader>f"',
          function()
            Snacks.picker.registers()
          end,
          desc = "Registers",
        },
      }
    end,
  },
  -- statusline
  {
    "echasnovski/mini.statusline",
    version = false,
    config = function()
      require("mini.statusline").setup({
        -- Content of statusline as functions which return statusline string. See
        -- `:h statusline` and code of default contents (used instead of `nil`).
        content = {
          -- Content for active window
          active = nil,
          -- Content for inactive window(s)
          inactive = nil,
        },

        -- Whether to use icons by default
        use_icons = true,

        -- Whether to set Vim's settings for statusline (make it always shown)
        set_vim_settings = true,
      })
    end,
  },

  -- nice ui
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = function(_, opts)
      opts.debug = false
      opts.routes = opts.routes or {}
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })

      table.insert(opts.routes, 1, {
        filter = {
          ["not"] = {
            event = "lsp",
            kind = "progress",
          },
          cond = function()
            return not focused and false
          end,
        },
        view = "notify_send",
        opts = { stop = false, replace = true },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })
      return opts
    end,
  },
}

---
--- NOTE: available pickers
--[[ { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader><space>", function() Snacks.picker.files() end, desc = "Find Files" },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- git
    { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader>qp", function() Snacks.picker.projects() end, desc = "Projects" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" }, ]]
