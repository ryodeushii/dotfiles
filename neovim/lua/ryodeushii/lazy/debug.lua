local function config_adapters()
    local dap = require("dap")

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
        config = function()
            require("nvim-dap-virtual-text").setup({
                enabled = true,             -- enable this plugin (the default)
                enabled_commands = true,    -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                show_stop_reason = true,    -- show stop reason when stopped for exceptions

                commented = false,          -- prefix virtual text with comment string

                only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
                all_references = false,     -- show virtual text on all all references of the variable (not only definitions)
                clear_on_continue = false,  -- clear virtual text on "continue" (might cause flickering when stepping)
                --- A callback that determines how a variable is displayed or whether it should be omitted
                display_callback = function(variable, buf, stackframe, node, options)
                    if options.virt_text_pos == 'inline' then
                        return ' = ' .. variable.value
                    else
                        return variable.name .. ' = ' .. variable.value
                    end
                end,
                -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
                virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

                -- experimental features:

                all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)

                virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,

                -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`


            })
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        before = "nvim-dap",
        config = function()
            require("mason-nvim-dap").setup({
                force = true,
                ensure_installed = {
                    "codelldb",
                    "delve",
                }
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
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
        "mxsdev/nvim-dap-vscode-js",
        dependencies = {
            {
                "microsoft/vscode-js-debug",
                version = "1.x",
                build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
            },
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("dap-vscode-js").setup({
                -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
                -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
                -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
                adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
                -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
                -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
                -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
                debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
            })

            for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
                require("dap").configurations[language] = {
                    {
                        type = "pwa-node",

                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require 'dap.utils'.pick_process,

                        cwd = "${workspaceFolder}",

                    },
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Debug Jest Tests",
                        -- trace = true, -- include debugger info
                        runtimeExecutable = "node",
                        runtimeArgs = {
                            "./node_modules/jest/bin/jest.js",
                            "--runInBand",
                        },
                        rootPath = "${workspaceFolder}",
                        cwd = "${workspaceFolder}",
                        console = "integratedTerminal",
                        internalConsoleOptions = "neverOpen",
                    },
                }
            end
        end
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
        end,
    },
}
