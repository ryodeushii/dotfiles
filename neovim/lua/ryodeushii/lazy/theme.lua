function ApplyColorScheme(color)
    color = color or "tokyonight-storm"

    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "uloco/bluloco.nvim",
        dependencies = { 'rktjmp/lush.nvim' }
    },
    { "shaunsingh/moonlight.nvim" },
    { "eldritch-theme/eldritch.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "rose-pine/neovim" },
    { "scottmckendry/cyberdream.nvim" },
    { "sainnhe/sonokai" },
    { "rmehri01/onenord.nvim" },
    { "zootedb0t/citruszest.nvim" },
    { "comfysage/evergarden" },
    { "catppuccin/nvim",              name = "catppuccin" },
    {
        "vague2k/huez.nvim",
        dependencies = {
            -- You probably already have this installed, highly reccomended you do.
            "nvim-telescope/telescope.nvim",
            -- If using vim.ui, this plugin will give you a better experience
            "stevearc/dressing.nvim",
        },
        config = function()
            require("huez").setup({
                fallback = "tokyonight-storm",
                picker = "telescope",
                omit = {
                    "vim",
                    "default",
                    "desert",
                    "evening",
                    "industry",
                    "koehler",
                    "morning",
                    "murphy",
                    "pablo",
                    "peachpuff",
                    "ron",
                    "shine",
                    "slate",
                    "torte",
                    "zellner",
                    "blue",
                    "darkblue",
                    "delek",
                    "quiet",
                    "elflord",
                    "habamax",
                    "lunaperche",
                    "sorbet",
                    "zaibatsu",
                    "wildcharm",
                }
            })
            vim.keymap.set("n", "<leader>co", "<cmd>Huez<cr>")
        end
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "storm",
                transparent = true,
                terminal_colors = true,
                styles = {
                    -- sidebars = "dark",
                    -- floats = "dark",
                    comments = { italic = true },
                    keywords = { italic = false },
                },

            })
        end

    },
    {
        "olimorris/onedarkpro.nvim",
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
                comments = { italic = true },
                keywords = { italic = false },
                identifiers = { italic = false },
                functions = {},
                variables = {},
            },
            terminal_colors = true,
            -- custom options here
        },
        config = function(_, opts)
            require("tokyodark").setup(opts) -- calling setup is optional
        end,
    }
}
