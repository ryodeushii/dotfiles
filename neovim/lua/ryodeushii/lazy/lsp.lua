return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    "mireq/luasnip-snippets",
                    init = function()
                        -- Mandatory setup function
                        require('luasnip_snippets.common.snip_utils').setup()
                    end

                }
            },
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
        },

        config = function()
            require("luasnip").setup({
                load_ft_func = require('luasnip_snippets.common.snip_utils').load_ft_func,
                ft_func = require('luasnip_snippets.common.snip_utils').ft_func,
            })


            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())

            require("fidget").setup({})
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "tsserver",
                    "gopls",
                    "jsonls",
                    "eslint",
                    "bashls",
                    "ast_grep",
                },
                handlers = {
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,

                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")

                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                                    }
                                }
                            }
                        }
                    end,
                }
            })

            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                })
            })

            vim.diagnostic.config({
                update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })


            -- FIXME: test setup for oxlint lsp
            local lspconfig = require("lspconfig")
            -- TODO: probably later enable it back
            -- local configs = require("lspconfig.configs")
            --
            -- if not configs.oxlint then
            --     configs.oxlint = {
            --         default_config = {
            --             cmd = { "oxlint" },
            --             filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
            --             root_dir = lspconfig.util.root_pattern(".git"),
            --             settings = {},
            --         },
            --     }
            -- end

            lspconfig.gopls.setup({
                capabilities = capabilities,
                settings = {
                    gopls = {
                        analyses = {
                            composites = false,
                        }
                    }
                },
            })


            -- lspconfig.oxlint.setup({
            --     capabilities = capabilities,
            -- })


            lspconfig.tsserver.setup({
                capabilities = capabilities,
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                end
            })
            lspconfig.eslint.setup({
                capabilities = capabilities,
                flags = { debounce_text_changes = 500 },

                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = true
                    if client.server_capabilities.documentFormattingProvider then
                        local au_lsp = vim.api.nvim_create_augroup("eslint_lsp", { clear = true })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            pattern = "*",
                            callback = function()
                                vim.lsp.buf.format({ async = true })
                            end,
                            group = au_lsp,

                        })
                    end
                end,

            })
        end
    },
    {
        "windwp/nvim-projectconfig",
        config = function()
            require('nvim-projectconfig').setup()
        end,
    },
    {
        "saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = function()
            require("crates").setup({
                lsp = {
                    enabled = true,
                    name = "crates.nvim",
                    actions = true,
                    completion = true,
                    hover = true,
                },

            })
            local cmp = require("cmp")
            vim.api.nvim_create_autocmd("BufRead", {
                group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
                pattern = "Cargo.toml",
                callback = function()
                    cmp.setup.buffer({ sources = { { name = "crates" } } })
                end,
            })
        end,
    },
    {
        'dmmulroy/ts-error-translator.nvim',
        config = function()
            require('ts-error-translator').setup()
        end
    }
}
