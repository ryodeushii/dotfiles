return {
  "nvim-telescope/telescope.nvim",

  tag = "0.1.8",

  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
    }
  },

  config = function()
    local add_to_trouble = require("trouble.sources.telescope").add

    require('telescope').setup({
      pickers = {
        find_files = {
          hidden = true
        },
        git_files = {
          hidden = true
        }
      },
      defaults = {
        mappings = {
          i = {
            ["<c-t>"] = add_to_trouble,
          },
          n = {
            ["<c-t>"] = add_to_trouble,
          }
        }
      }
    })

    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set("n", "<leader>fs", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fr', ":Telescope resume<CR>")
    -- vim.keymap.set('n', '<leader>pws', function()
    --     local word = vim.fn.expand("<cword>")
    --     builtin.grep_string({ search = word })
    -- end)
    -- vim.keymap.set('n', '<leader>pWs', function()
    --     local word = vim.fn.expand("<cWORD>")
    --     builtin.grep_string({ search = word })
    -- end)
  end
}
