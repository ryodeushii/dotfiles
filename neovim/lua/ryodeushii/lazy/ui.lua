-- call this function to apply a color scheme in any module
function ApplyColorScheme(color)
  color = color or "ex-tokyonight-night"

  vim.cmd.colorscheme(color)

  if color == "ex-vague" then
    local normal = vim.api.nvim_get_hl(0, { name = "NormalNC" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal.bg, fg = normal.fg })
    vim.api.nvim_set_hl(0, "Normal", { bg = normal.bg, fg = normal.fg })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = normal.bg, fg = normal.fg })
  end
end

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
          map("n", "<leader>hu", gitsigns.stage_hunk, { desc = "undo stage hunk" })
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
          map("n", "<leader>td", gitsigns.preview_hunk_inline, { desc = "toggle deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select hunk" })
        end,
      })
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
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = {
      theme = "hyper",
      shortcut_type = "number",
      config = {
        shortcut = {
          -- action can be a function type
          { desc = "Lazy", group = "highlight group", key = "L", action = "Lazy" },
        },
        packages = { enable = true }, -- show how many plugins neovim loaded
        project = { enable = false, limit = 0, icon = "", label = "Projects", action = "Telescope find_files cwd=" },
        mru = { enable = true, limit = 10, icon = "", label = "Recent files", cwd_only = false },
        footer = {}, -- footer
      },
    },
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "alpha", "dashboard" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location", "selectioncount" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    keys = {
      "<leader>ff",
      "<leader>fF",
      "<leader>fm",
      "<leader>fg",
      "<leader>fr",
      "<leader>fs",
      "<leader>fb",
      "<leader>fk",
      '<leader>f"',
      "<leader>fp",
      "<leader>fp",
      "<leader>vrr",
      "<leader>vri",
      "<leader>gd",
      "<leader>gtd",
    },
    dependencies = {
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "d4wns-l1ght/telescope-messages.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fF", function()
        require("telescope").extensions.frecency.frecency({
          workspace = "CWD",
        })
      end, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fm", function()
        require("telescope").extensions.messages.messages({})
      end, { desc = "Telescope messages" })
      vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Telescope git files" })
      vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Telescope resume" })
      vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
      vim.keymap.set("n", '<leader>f"', builtin.registers, { desc = "Telescope registers" })
      vim.keymap.set("n", "<leader>fp", builtin.builtin, { desc = "Telescope pickers" })
      vim.keymap.set("n", "<leader>fp", builtin.builtin, { desc = "Telescope pickers" })
      vim.keymap.set("n", "<leader>vrr", builtin.lsp_references, { desc = "Telescope LSP references" })
      vim.keymap.set("n", "<leader>vri", builtin.lsp_implementations, { desc = "Telescope LSP implementations" })
      vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, { desc = "Telescope LSP definitions" })
      vim.keymap.set("n", "<leader>gtd", builtin.lsp_type_definitions, { desc = "Telescope LSP type definitions" })

      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-u>"] = false, -- disable clearing the prompt
              ["<C-d>"] = false, -- disable deleting half of the prompt
            },
          },
          layout_config = {
            horizontal = { preview_width = 0.6 },
            vertical = { preview_height = 0.6 },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("frecency")
      require("telescope").load_extension("messages")
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      exclude = {
        filetypes = {
          "alpha",
          "dashboard",
          "help",
          "lazy",
          "lsp",
        },
      },
    },
  },
}
