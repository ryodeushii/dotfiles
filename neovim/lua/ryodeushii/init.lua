require("ryodeushii.set")
require("ryodeushii.remap")

require("ryodeushii.lazy_init")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local RyodeushiiGroup = augroup('ryodeushiiAG', {})
local yank_group = augroup('HighlightYank', {})
local ShebangGroup = augroup('ShebangFiletype', {})

function R(name)
  require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

autocmd({ "BufWritePre" }, {
  group = RyodeushiiGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
  group = RyodeushiiGroup,
  callback = function(e)
    local fzf = require("fzf-lua")
    vim.keymap.set("n", "gd", fzf.lsp_definitions, { buffer = e.buf, desc = "Go to definition" })
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { buffer = e.buf, desc = "Show hover" })
    vim.keymap.set("n", "<leader>vws", fzf.lsp_workspace_symbols, { buffer = e.buf, desc = "Workspace symbol" })
    vim.keymap.set("n", "<leader>vt", fzf.lsp_typedefs, { buffer = e.buf, desc = "Show typedefs" })
    vim.keymap.set("n", "<leader>vdd", fzf.lsp_declarations, { buffer = e.buf, desc = "Show declarations" })
    vim.keymap.set("n", "<leader>vd", fzf.diagnostics_document, { buffer = e.buf, desc = "Show diagnostics - document" })
    vim.keymap.set("n", "<leader>vwd", fzf.diagnostics_workspace,
      { buffer = e.buf, desc = "Show diagnostics - workspace" })
    vim.keymap.set("n", "<leader>vca", fzf.lsp_code_actions, { buffer = e.buf, desc = "Code action" })
    vim.keymap.set({ "i", "v", "n" }, "<A-c>", fzf.lsp_code_actions, { buffer = e.buf, desc = "Code action" })
    vim.keymap.set("n", "<leader>vrr", fzf.lsp_references, { buffer = e.buf, desc = "Show references" })
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, { buffer = e.buf, desc = "Rename" })
    vim.keymap.set({ "i" }, "<C-h>", function() vim.lsp.buf.signature_help() end,
      { buffer = e.buf, desc = "Signature help" })
    ---@diagnostic disable-next-line: deprecated
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, { buffer = e.buf, desc = "Next diagnostic" })
    ---@diagnostic disable-next-line: deprecated
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, { buffer = e.buf, desc = "Previous diagnostic" })
  end
})


-- Use an autocmd to run the shebang detection when a file is opened
autocmd('BufReadPost', {
  group = ShebangGroup,
  callback = function(_)
    require('ryodeushii.shebang').detect_shell()
  end,
})
