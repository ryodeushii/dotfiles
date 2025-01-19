return {
  {
    "ibhagwan/fzf-lua",
    lazy = false,
    -- optional for icon support
    dependencies = {
      { 'echasnovski/mini.icons', version = false },
    },
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        keymap = { builtin = { true, ["<Esc>"] = "hide" } }
      })

      local config = require("fzf-lua.config")
      local actions = require("trouble.sources.fzf").actions
      config.defaults.actions.files["ctrl-t"] = actions.open
      config.defaults.actions.files["ctrl-q"] = actions.file_edit_or_qf

      vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', fzf.git_files, { desc = 'Find Git files' })
      vim.keymap.set('n', '<leader>ft', fzf.treesitter, { desc = 'Find treesitter symbols in current buffer' })
      -- https://github.com/ibhagwan/fzf-lua?tab=readme-ov-file#commands
      vim.keymap.set('n', '<leader>fo', fzf.oldfiles, { desc = 'Find old files' })
      vim.keymap.set('n', '<C-p>', fzf.files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Find buffers' })
      vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "Resume last window" })
      vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "Find current word" })
      vim.keymap.set("v", "<leader>fw", fzf.grep_visual, { desc = "Find current word" })
      vim.keymap.set("n", "<leader>ps", fzf.lgrep_curbuf, { desc = "Live grep current buffer" })
      vim.keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "Find keymaps" })
      vim.keymap.set("n", "<leader>fs", fzf.live_grep, { desc = "Find text in project" })
      vim.keymap.set("n", "<leader>fl", fzf.lsp_document_symbols, { desc = "Find LSP related things" })
      vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Find help tags" })
    end
  }
}
