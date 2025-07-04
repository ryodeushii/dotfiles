vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.numberwidth = 3
-- vim.opt.signcolumn = "yes:1"
vim.opt.statuscolumn = "%@SignCb@%s%=%T%@NumCb@%l│%T"

vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

--[[ zc - Close (fold) the current fold under the cursor.
zo - Open (unfold) the current fold under the cursor.
za - Toggle between closing and opening the fold under the cursor.
zR - Open all folds in the current buffer.
zM - Close all folds in the current buffer. ]]

-- vim.opt.foldlevel = 20
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldlevelstart = 99

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.defer_fn(function()
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end, 100)
  end,
})

vim.opt.clipboard:append("unnamedplus")

vim.opt.cursorline = true

-- define custom filetypes overrides
vim.cmd([[
  augroup ryodeushiiCustomTypes
    au! BufRead,BufNewFile *.inc setfiletype c
    au! BufRead,BufNewFile *.h setfiletype c
    au! BufRead,BufNewFile *.c setfiletype c
    au! BufRead,BufNewFile *.xstddef setfiletype c
    au! BufRead,BufNewFile *.type_traits setfiletype c
    au! BufRead,BufNewFile *.utility setfiletype c
    au! BufRead,BufNewFile *.ranges setfiletype c
    au! BufRead,BufNewFile *.mdx setfiletype markdown
  augroup END
]])

-- for hereterm to work properly
vim.opt.hidden = true

vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
})
