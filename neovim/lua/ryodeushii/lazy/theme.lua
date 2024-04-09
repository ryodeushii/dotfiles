function ApplyColorScheme(color)
    color = color or "tokyonight-storm"

    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    "folke/tokyonight.nvim",
    config = function()
        require("tokyonight").setup({
            style = "storm",
            transparent = true,
            terminal_colors = true,
            styles = {
                sidebars = "dark",
                floats = "dark",
                comments = { italic = true },
                keywords = { italic = false },
            },

        })
    end

}
