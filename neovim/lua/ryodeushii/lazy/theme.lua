function ApplyColorScheme(color)
    color = color or "catppuccin"

    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                term_colors = true,
                transparent_background = false,
                styles = {
                    comments = {},
                    conditionals = {},
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},

                    booleans = {},
                    properties = {},

                    types = {},
                },
                color_overrides = {
                    mocha = {
                        rosewater = "#ffd7d9",
                        flamingo = "#ffb3b8",
                        pink = "#ff7eb6",
                        mauve = "#d4bbff",
                        red = "#fa4d56",
                        maroon = "#ff8389",

                        peach = "#ff832b",
                        yellow = "#fddc69",
                        green = "#42be65",
                        teal = "#3ddbd9",

                        sky = "#82cfff",

                        sapphire = "#78a9ff",
                        blue = "#4589ff",
                        lavender = "#be95ff",
                        text = "#f4f4f4",
                        subtext1 = "#e0e0e0",
                        subtext0 = "#c6c6c6",
                        overlay2 = "#a8a8a8",
                        overlay1 = "#8d8d8d",

                        overlay0 = "#6f6f6f",
                        surface2 = "#525252",
                        surface1 = "#393939",
                        surface0 = "#262626",
                        base = "#161616",
                        mantle = "#0b0b0b",

                        crust = "#000000"
                    },
                },
            })
        end
    },
}
