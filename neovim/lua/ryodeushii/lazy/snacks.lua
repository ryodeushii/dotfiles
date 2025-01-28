---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()

vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params
        .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
            ---@diagnostic disable-next-line: undefined-field
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

return {
  -- when the profiler is running
  {
    "folke/snacks.nvim",
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1,
      },
      bigfile = {},
      dashboard = {
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      lazygit = {},
      indent = { enabled = false  },
      scope = { enabled = false, min_size = 2, cursor = true, edge = true, debounce = 30 },
      input = { enabled = false }, -- possible replacement for dressing
      notifier = {
        enabled = true,
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          debug = " ",
          trace = " ",
        },
      },
      quickfile = { enabled = true },
      picker = { enabled = true },
      statuscolumn = {
        enabled = false,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = false,            -- show open fold icons
          git_hl = false,          -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      words = { enabled = true },
    },

    keys = function()
      local Snacks = require("snacks")
      return {
        { "<leader>ff",  function() Snacks.picker.files({ hidden = true }) end, desc = "Find files" },
        { "<C-p>",       function() Snacks.picker.files() end,                  desc = "Find files" },
        { "<leader>fg",  function() Snacks.picker.git_files() end,              desc = "Find Git files" },
        { "<leader>fb",  function() Snacks.picker.buffers() end,                desc = "Find Buffers" },
        { "<leader>fs",  function() Snacks.picker.grep() end,                   desc = "Grep" },
        { "<leader>ps",  function() Snacks.picker.grep({ buffers = true }) end, desc = "Grep" },
        { "<leader>fr",  function() Snacks.picker.resume() end,                 desc = "Resume" },
        { "<leader>fo",  function() Snacks.picker.recent() end,                 desc = "Recent files" },
        { "<leader>fw",  function() Snacks.picker.grep_word() end,              desc = "Visual selection or word", mode = { "n", "x", "v" } },
        { "<leader>fh",  function() Snacks.picker.help() end,                   desc = "Help Pages" },
        { "<leader>fk",  function() Snacks.picker.keymaps() end,                desc = "Keymaps" },
        { "<leader>gl",  function() Snacks.picker.git_log() end,                desc = "Git log" },
        { "<leader>ft",  function() Snacks.picker.todo_comments() end,          desc = "Git status" },
        { "<leader>fp",  function() Snacks.picker() end,                        desc = "List pickers" },


        -- lsp related
        { "<leader>vd",  function() Snacks.picker.diagnostics() end,            desc = "Diagnostics" },
        { "<leader>vws", function() Snacks.picker.lsp_workspace_symbols() end,  desc = "Diagnostics" },
        { "gd",          function() Snacks.picker.lsp_definitions() end,        desc = "Goto Definition" },
        { "gtd",         function() Snacks.picker.lsp_type_definitions() end,   desc = "Goto T[y]pe Definition" },
        { "gr",          function() Snacks.picker.lsp_references() end,         nowait = true,                     desc = "References" },
        { "<leader>vrr", function() Snacks.picker.lsp_references() end,         nowait = true,                     desc = "References" },
        { "gi",          function() Snacks.picker.lsp_implementations() end,    desc = "Goto Implementation" },
        { "<leader>fl",  function() Snacks.picker.lsp_symbols() end,            desc = "LSP Symbols" },
        { "<leader>gs",  function() Snacks.lazygit() end,                       desc = "LazyGit" }
      }
    end,
  },
}

-- picker docs
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md

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
