return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  requires = { { "nvim-lua/plenary.nvim" } },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      settings = {
        save_on_toggle = true,
        save_on_ui_close = true

      }
    })

    require("telescope").load_extension("harpoon")
    -- add file to list
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    -- quick switch between first 4 files
    vim.keymap.set("n", "<A-1>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<A-2>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<A-3>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<A-4>", function() harpoon:list():select(4) end)

    -- show ui (internal)
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  end
}
