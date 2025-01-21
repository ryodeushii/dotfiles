-- Open compiler
vim.api.nvim_set_keymap('n', '<F6>', "<cmd>OverseerRun<cr>",
  { noremap = true, silent = true, desc = "Run task in overseer" })
vim.api.nvim_set_keymap('n', '<F7>', "<cmd>OverseerToggle<cr>",
  { noremap = true, silent = true, desc = "Toggle overseer output" })

return {
  { -- The task runner we use
    "stevearc/overseer.nvim",
    cmd = { "OverseerOpen", "OverseerToggle", "OverseerRun", "OverseerRunCmd" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1
      },
    },
  },
}
