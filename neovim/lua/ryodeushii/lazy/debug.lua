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
        {
            type = "node2",
            request = "launch",
            name = "Launch ts-node",
            runtimeExecutable = "ts-node",
            runtimeArgs = { "${file}" },
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
        },
        {
            type = "node2",
            request = "launch",
            name = "[npm] start",
            runtimeExecutable = "npm",
            runtimeArgs = { "run", "start" },
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

    dap.configurations.typescript = dap.configurations.javascript

    dap.configurations.javascriptreact = dap.configurations.typescript
    dap.configurations.typescriptreact = dap.configurations.typescript

    -- C
    dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",

        executable = {
            command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
            args = { "--port", "${port}" },
            detached = function() if windows then return false else return true end end,

        }
    }

    dap.configurations.c = {
        {
            name = 'Launch',
            type = 'codelldb',
            request = 'launch',
            program = function() -- Ask the user what executable wants to debug
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/bin/program', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
        },
    }

    -- C++
    dap.configurations.cpp = dap.configurations.c

    -- Rust
    dap.configurations.rust = {

        {
            name = 'Launch',
            type = 'codelldb',
            request = 'launch',
            program = function() -- Ask the user what executable wants to debug
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/bin/program', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,

            args = {},
            initCommands = function() -- add rust types support (optional)
                -- Find out where to look for the pretty printer Python module

                local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))


                local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
                local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

                local commands = {}
                local file = io.open(commands_file, 'r')
                if file then
                    for line in file:lines() do
                        table.insert(commands, line)
                    end
                    file:close()
                end
                table.insert(commands, 1, script_import)

                return commands
            end,
        }
    }


    dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
            command = vim.fn.stdpath('data') .. '/mason/packages/delve/dlv',
            args = { 'dap', '-l', '127.0.0.1:${port}' },
        }
    }

    dap.configurations.go = {
        {
            type = "delve",
            name = "Compile module and debug this file",
            request = "launch",
            program = "./${relativeFileDirname}",
        },
        {
            type = "delve",
            name = "Compile module and debug this file (test)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}"
        },
    }
end



return {
    {
        "theHamsta/nvim-dap-virtual-text",
        after = "nvim-dap",
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        after = "nvim-dap",
    },
    {
        "rcarriga/cmp-dap",
        dependencies = { "nvim-cmp" },
        after = "nvim-dap",
        config = function()
            require("cmp").setup.filetype(
                { "dap-repl", "dapui_watches", "dapui_hover" },
                {
                    sources = {
                        { name = "dap" },
                    },
                }
            )
        end,
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
