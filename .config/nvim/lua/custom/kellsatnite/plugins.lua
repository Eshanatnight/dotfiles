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
                "rust-analyzer",
                "clangd",
                "cmakelint",
                "clang-format",
                "clang-tidy",
                "codelldb",
                "lua-ls",
                "black",
                "pyright",
                "checkmate",
                "cmake-language-server",
                "isort",
                "markdownlint",
                "mypy",
                "prettier",
                "pylint",
                "stylua",
                "ts-standard",
                "typescript-language-server",
                "bash-language-server",
                "lua-language-server",
                "protolint",
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

    -- rust.vim
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end,
    },

    -- rustaceanvim
    -- {
    --     "mrcjkb/rustaceanvim",
    --     ft = "rust",
    -- },

    -- rust-tools.nvim
    {
        "simrat39/rust-tools.nvim",
        ft = "rust",
        dependencies = "neovim/nvim-lspconfig",
        opts = function()
            return require "custom.kellsatnite.configs.rust-tools"
        end,
        config = function(_, opts)
            require("rust-tools").setup(opts)
        end,
    },

    -- nvim-dap
    {
        "mfussenegger/nvim-dap",
        config = function(_, _)
            require("core.utils").load_mappings "dap"
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

    -- nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        opts = function()
            local M = require "plugins.configs.cmp"
            table.insert(M.sources, { name = "crates" })
            return M
        end,
    },

    -- null-ls depricated
    -- {
    --     "jose-elias-alvarez/null-ls.nvim",
    --     event = "VeryLazy",
    --     opt = function()
    --         return require "custom.kellsatnite.configs.null-ls"
    --     end,
    -- },

    -- none-ls **cant get it to work**
    -- {
    --     "nvimtools/none-ls.nvim",
    --     event = "VeryLazy",
    --     opt = function()
    --         return require "custom.kellsatnite.configs.none-ls"
    --     end,
    -- },

    -- dap-ui
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = "mfussenegger/nvim-dap",
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
        -- i need to pass the config for nvim dap
        -- but this is not the right place
        -- maybe it is in rust-tools
        opts = {
            handlers = {},
        },
    },

    -- copilot ? may switch
    {
        "zbirenbaum/copilot.lua",
        lazy = false,
        opts = function()
            return require "custom.kellsatnite.configs.copilot"
        end,
        config = function(_, opts)
            require("copilot").setup(opts)
        end,
    },

    -- pretty fold
    {
        "anuvyklack/pretty-fold.nvim",
        lazy = false,
        config = function()
            require("pretty-fold").setup()
        end,
    },

    -- conform.nvim
    {
        "stevearc/conform.nvim",
        lazy = false,
        -- need to test this out
        -- event = { "BufReadPre", "BufNewFile" },
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
            require("custom.kellsatnite.configs.linting").config()
        end,
    },

    -- cloak.nvim
    {
        "laytan/cloak.nvim",
        lazy = false,
        opts = function()
            return require "custom.kellsatnite.configs.kcloak"
        end,

        config = function(_, opts)
            require("cloak").setup(opts)
        end,
    },

    -- barbecue.nvim
    {
        "utilyre/barbecue.nvim",
        lazy = false,
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = function()
            return require "custom.kellsatnite.configs.bbq"
        end,
        config = function(_, opts)
            require("barbecue").setup(opts)
        end,
    },

    -- vim-visual-multi
    -- causing an imap overwrite
    -- {
    --     "mg979/vim-visual-multi",
    --     event = "VeryLazy",
    --     opts = {},
    --     init = function()
    --         print "Inside Init of vim-visual-multi"
    --     end,
    --     config = function()
    --         print "Inside config of vim-visual-multi"
    --     end,
    -- },
}

return plugins
