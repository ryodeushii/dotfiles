function ApplyColorScheme(color)
    color = color or "tokyonight-storm"

    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
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

    },
    {
        "navarasu/onedark.nvim",
        config = function()
            require("onedark").setup({
                style = "warmer",
                transparent = true,
                term_colors = true,
            })
        end
    },
    {
        "AlexvZyl/nordic.nvim",
        config = function()
            require("nordic").setup({
                italic_comments = true,
                transparent = true,
            })
        end
    },
    {
        "tiagovla/tokyodark.nvim",
        opts = {
            transparent_background = true,
            styles = {
                comments = {italic = true},
                keywords = {italic = false},
                identifiers = {italic = false},
                functions = {},
                variables = {},
            },
            terminal_colors = true,
            -- custom options here
        },
        config = function(_, opts)
            require("tokyodark").setup(opts) -- calling setup is optional
        end,
    },
}
