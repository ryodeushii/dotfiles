function ApplyColorScheme(color)
    color = color or "onedark_dark"

    vim.cmd.colorscheme(color)
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    { "scottmckendry/cyberdream.nvim" },
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
