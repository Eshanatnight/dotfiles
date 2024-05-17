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
            ensure_installed = function()
                return require "kellsatnite.configs.mason-list"
            end,
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
        ft = { "go", "lua", "json" },
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
            table.insert(M.sources, { name = "crates" })
            -- add cody to sources
            table.insert(M.sources, { name = "cody" })
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

    -- rust.vim
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end,
    },

    -- rustaceanvim
    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        ft = { "rust" },
        dependencies = "neovim/nvim-lspconfig",
        config = function()
            require "custom.kellsatnite.configs.rustaceanvim"

            local dap = require "dap"
            local UDap = require "custom.kellsatnite.utils"
            dap.configurations.rust = {
                {
                    type = "codelldb",
                    request = "launch",
                    name = "Launch file",
                    program = function()
                        return UDap.find_rust_program(dap)
                    end,
                    args = UDap.get_args,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = true,
                },
            }
            -- a nil path defaults to .vscode/launch.json
            require("dap.ext.vscode").load_launchjs(nil, { codelldb = { "rust" } })
        end,
    },

    -- neotest
    {
        "nvim-neotest/neotest",
        optional = true,
        opts = function(_, opts)
            opts.adapters = opts.adapters or {}
            vim.list_extend(opts.adapters, {
                require "rustaceanvim.neotest",
            })
        end,
    },

    -- crates.nvim
    {
        "saecki/crates.nvim",
        dependencies = "hrsh7th/nvim-cmp",
        ft = { "rust", "toml" },
        config = function(_, opts)
            local crates = require "crates"
            crates.setup(opts)
            crates.show()
        end,
    },

    -- nvim-dap
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        event = { "VeryLazy" },
        config = function(_, _)
            require("core.utils").load_mappings "dap"
            -- local dap = require "dap"
            -- local UDap = require "custom.kellsatnite.utils"
            -- dap.configurations.cpp = {
            --     {
            --         type = "codelldb",
            --         request = "launch",
            --         name = "Launch file",
            --         program = function()
            --             return UDap.find_program(dap)
            --         end,
            --         args = UDap.get_args,
            --         cwd = "${workspaceFolder}",
            --         stopOnEntry = true,
            --     },
            -- }
            -- dap.configurations.c = dap.configurations.cpp
            require("dap.ext.vscode").load_launchjs(nil, { codelldb = { "cpp" } })
        end,
    },

    -- nvim dap go
    {
        "leoluz/nvim-dap-go",
        ft = "go",
        dependencies = "mfussenegger/nvim-dap",
        config = function(_, opts)
            require("dap-go").setup(opts)
            require("core.utils").load_mappings "dap_go"
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

    -- copilot ? may switch
    -- {
    --     "zbirenbaum/copilot.lua",
    --     lazy = false,
    --     opts = function()
    --         return require "custom.kellsatnite.configs.copilot"
    --     end,
    --     config = function(_, opts)
    --         require("copilot").setup(opts)
    --     end,
    -- },

    -- sourcegraph
    {
        "sourcegraph/sg.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        lazy = false,
        config = function()
            require("sg").setup()
        end,
    },

    -- pretty fold
    {
        "anuvyklack/pretty-fold.nvim",
        event = "VeryLazy",
        config = function()
            require("pretty-fold").setup()
        end,
    },

    -- conform.nvim
    {
        "stevearc/conform.nvim",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require "custom.kellsatnite.configs.formatting"
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

    -- cmake tools
    {
        "Civitasv/cmake-tools.nvim",
        config = function()
            local opts = require "lua.custom.kellsatnite.configs.cmake-tools"
            require("cmake-tools").setup(opts)
        end,
    },

    -- cloak.nvim
    {
        "laytan/cloak.nvim",
        lazy = true,
        opts = function()
            return require "custom.kellsatnite.configs.kcloak"
        end,

        config = function(_, opts)
            require("cloak").setup { opts }
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
        lazy = true,
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
        lazy = true,
        config = function()
            require("core.utils").load_mappings "searchbox"
        end,
    },
}

return plugins
