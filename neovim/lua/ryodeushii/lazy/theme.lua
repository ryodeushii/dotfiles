function ApplyColorScheme(color)
    color = color or "onedark_dark"

    vim.cmd.colorscheme(color)
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    { "eldritch-theme/eldritch.nvim" },
    { "scottmckendry/cyberdream.nvim" },
    { "zootedb0t/citruszest.nvim" },
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
                    "onedark",
                    "onelight",
                    "retrobox"
                }
            })
            vim.keymap.set("n", "<leader>co", "<cmd>Huez<cr>")
        end
    },
    {
        "olimorris/onedarkpro.nvim",
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
