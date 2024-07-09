-- @type ChadrcPlugins
local plugins = {
    -- get mason
    {
        "williamboman/mason.nvim",
        dependencies = {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        -- options
        opts = {
            ensure_installed = {
                "clangd",
                "codelldb",
                "stylua",
                "lua-language-server",
            },
        },
    },

    -- neovin lspcofig
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.kellsatnite.configs.lspconfig"
        end,
    },

    -- none-ls
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        ft = {"lua" },
        requires = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
        },
        config = function(_, _)
            local opt = require "custom.kellsatnite.configs.null-ls"
            require("null-ls").setup(opt)
        end,
    },

    -- nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        opts = function()
            local M = require "plugins.configs.cmp"
            return M
        end,
    },

    -- inlay hints
    {
        "simrat39/inlay-hints.nvim",
        lazy = false,
        config = function()
            require("inlay-hints").setup {
                hints = {
                    parameter = {
                        show = false,
                    },
                    type = {
                        show = true,
                        highlight = "Comment",
                    },
                },
            }
        end,
    },

    -- nvim-dap
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        event = { "VeryLazy" },
        config = function(_, _)
            require("core.utils").load_mappings "dap"
            local dap = require "dap"
            -- local UDap = require "custom.kellsatnite.utils"
            -- require("dap.ext.vscode").load_launchjs(nil, { codelldb = { "cpp" } })

            require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "cpp" } })

            -- dap.configurations.cpp = {
            --     {
            --         type = "cppdbg",
            --         name = "cppdbg-dap",
            --         program = function()
            --             return UDap.find_program(dap)
            --         end,
            --         args = UDap.get_args,
            --         cwd = "${workspaceFolder}",
            --         stopOnEntry = true,
            --         setupCommands = {
            --             {
            --                 text = "-enable-pretty-printing",
            --                 description = "enable pretty printing",
            --                 ignoreFailures = false,
            --             },
            --         },
            --     },
            -- }
            -- dap.configurations.cpp = {
            --     {
            --         type = "codelldb",
            --         request = "launch",
            --         name = "Default",
            --         program = function()
            --             return UDap.find_program(dap)
            --         end,
            --         args = UDap.get_args,
            --         cwd = "${workspaceFolder}",
            --         stopOnEntry = true,
            --     },
            -- }
            dap.configurations.c = dap.configurations.cpp
        end,
    },

    -- dap-ui
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require "dap"
            local dapui = require "dapui"
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },

    -- mason-nvim-dap
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            -- use default handlers for dap
            handlers = {},
        },
    },

    -- pretty fold
    {
        "anuvyklack/pretty-fold.nvim",
        event = "VeryLazy",
        config = function()
            require("pretty-fold").setup()
        end,
    },

    -- nvim-lint
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        lazy = false,

        config = function()
            require("core.utils").load_mappings "nvim_lint"
            require("custom.kellsatnite.configs.linting").config()
        end,
    },

    -- barbecue.nvim
    {
        "utilyre/barbecue.nvim",
        lazy = false,
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        opts = function()
            return require "custom.kellsatnite.configs.bbq"
        end,
        config = function(_, opts)
            require("barbecue").setup(opts)
        end,
    },

    -- todo-comments.nvim
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        lazy = false,
        opts = function()
            return require "custom.kellsatnite.configs.redditcomments"
        end,
        config = function(_, opts)
            require("todo-comments").setup { opts }
        end,
    },

    -- harpoon
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },

        lazy = true,
        config = function()
            require "custom.kellsatnite.configs.harpoon"
        end,
    },

    -- searchbox
    {
        "VonHeikemen/searchbox.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
        config = function()
            require("core.utils").load_mappings "searchbox"
        end,
    },

    -- trouble
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        config = function()
            require("core.utils").load_mappings "trouble"
            require("custom.kellsatnite.trouble").config()
        end,
    },
}

return plugins
