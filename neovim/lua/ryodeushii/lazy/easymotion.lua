return {
    "phaazon/hop.nvim",
    branch = "v2",

    config = function()
        local hop = require("hop")

        hop.setup({
            keys = 'etovxqpdygfblzhckisuran',
            current_line_only = false,
        })

        vim.keymap.set('', '<leader><leader>e', function()
            vim.cmd("HopWord")
        end, { remap = true })
        vim.keymap.set('', '<leader><leader>/', function()
            vim.cmd("HopPattern")
        end, { remap = true })
    end,

}
