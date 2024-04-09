local function config_adapters()
    local dap = require("dap")
    dap.adapters.node2 = {
        type = "executable",
        command = "node-debug2-adapter",
        args = {}
    }

    dap.configurations.javascript = {
        {
            type = "node2",
            request = "launch",
            name = "Launch file",
            runtimeExecutable = "node",
            runtimeArgs = { "${file}" },
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
        },
        -- debug npm script
        {
            type = "node2",
            request = "launch",
            name = "[npm] debug",
            runtimeExecutable = "npm",
            runtimeArgs = { "run", "debug" },
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
        },
        -- debug tests script
        {
            type = "node2",
            request = "launch",
            name = "[npm] test:debug",
            runtimeExecutable = "npm",
            runtimeArgs = { "run", "test:debug" },
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
        },
    }
end



return {
    {
        "theHamsta/nvim-dap-virtual-text",
        after = "nvim-dap",
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "microsoft/vscode-node-debug2"
        },
        config = function()
            -- replace B sign of breakpoint with red square
            vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })

            vim.api.nvim_set_keymap("n", "<F5>", "<cmd>lua require('dap').continue()<CR>",
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<F10>", "<cmd>lua require('dap').step_over()<CR>",
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<F11>", "<cmd>lua require('dap').step_into()<CR>",
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<F12>", "<cmd>lua require('dap').step_out()<CR>",
                { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<CR>",
                { noremap = true, silent = true })


            config_adapters()
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        keys = {
            {
                "<leader>du",
                function()
                    require("dapui").toggle()
                end,
                silent = true,

            },
        },

        config = function()
            require("dapui").setup()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
}
