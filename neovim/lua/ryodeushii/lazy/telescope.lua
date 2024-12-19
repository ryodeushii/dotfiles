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
  end
}
