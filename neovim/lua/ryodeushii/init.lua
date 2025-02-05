require("ryodeushii.set")
require("ryodeushii.remap")

require("ryodeushii.lazy_init")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local RyodeushiiGroup = augroup("ryodeushiiAG", {})
local yank_group = augroup("HighlightYank", {})
local ShebangGroup = augroup("ShebangFiletype", {})

function R(name)
  require("plenary.reload").reload_module(name)
end

autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

autocmd({ "BufWritePre" }, {
  group = RyodeushiiGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

autocmd("LspAttach", {
  group = RyodeushiiGroup,
  callback = function(e)
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, { buffer = e.buf, desc = "Show hover" })
    vim.keymap.set("n", "<leader>vca", function()
      vim.lsp.buf.code_action()
    end, { buffer = e.buf, desc = "Code action" })
    vim.keymap.set({ "i", "v", "n" }, "<A-c>", function()
      vim.lsp.buf.code_action()
    end, { buffer = e.buf, desc = "Code action" })
    vim.keymap.set("n", "<leader>vrn", function()
      vim.lsp.buf.rename()
    end, { buffer = e.buf, desc = "Rename" })
    vim.keymap.set({ "i" }, "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, { buffer = e.buf, desc = "Signature help" })
    vim.keymap.set("n", "[d", function()
      ---@diagnostic disable-next-line: deprecated
      vim.diagnostic.goto_next()
    end, { buffer = e.buf, desc = "Next diagnostic" })
    vim.keymap.set("n", "]d", function()
      ---@diagnostic disable-next-line: deprecated
      vim.diagnostic.goto_prev()
    end, { buffer = e.buf, desc = "Previous diagnostic" })
  end,
})

-- Use an autocmd to run the shebang detection when a file is opened
autocmd("BufReadPost", {
  group = ShebangGroup,
  callback = function(_)
    require("ryodeushii.shebang").detect_shell()
  end,
})
-- ApplyColorScheme("oldworld")
ApplyColorScheme("ex-oldworld")
