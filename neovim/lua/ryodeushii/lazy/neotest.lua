return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "rouge8/neotest-rust",
            "nvim-neotest/neotest-go",
            "nvim-neotest/neotest-jest",
            "nvim-neotest/neotest-plenary",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local neotest = require("neotest")
            neotest.setup({
                adapters = {
                    require("neotest-go") {
                        experimental = {
                            test_table = true,
                        },
                        args = { "-count=1", "-timeout=60s" },
                    },
                    require("neotest-rust") {
                        args = { "--no-capture" },
                        dap_adapter = "lldb"
                    },
                    require("neotest-jest")({
                        jestCommand = "npx jest --json --no-coverage",
                        env = { CI = true },
                        cwd = function(path)
                            return vim.fn.getcwd()
                        end,
                        jestConfigFile = '',
                        jest_test_discovery = false,
                    }),
                    require("neotest-go"),
                    require("neotest-plenary")
                    --     .setup({
                    --     -- this is my standard location for minimal vim rc
                    --     -- in all my projects
                    --     min_init = "./scripts/tests/minimal.vim",
                    -- }),
                }
            })

            vim.keymap.set("n", "<leader>tc", function()
                neotest.run.run()
            end)

            vim.keymap.set("n", "<leader>tf", function()
                neotest.run.run(vim.fn.expand("%"))
            end)

            vim.keymap.set("n", "<leader>dt", function()
                neotest.run.run({ strategy = "dap" })
            end)

            vim.keymap.set("n", "<leader>ta", function()
                neotest.run.attach()
            end)
        end,
    },
}
