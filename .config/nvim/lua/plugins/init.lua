return {
    -- mason
    {
        "williamboman/mason.nvim",
        dependencies = {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        -- options
        opts = function()
            local packages = require "configs.mason-list"
            local M = {
                ensure_installed = packages,
            }
            return M
        end,
    },

    -- lsp config
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },

    -- none-ls
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        ft = {
            -- "go",
            -- "lua",
            "json",
            "markdown",
            "cmake",
            "jsonc",
            "make",
            "cpp",
            "c",
            "zsh",
            "bash",
            "sh",
        },
        requires = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
        },
        config = function(_, _)
            local opt = require "configs.null-ls"
            require("null-ls").setup(opt)
        end,
    },

    -- nvim-cmp
    {
        "hrsh7th/nvim-cmp",
        opts = function()
            local M = require "nvchad.configs.cmp"
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
        version = "^6", -- Recommended
        ft = { "rust" },
        dependencies = "neovim/nvim-lspconfig",
        config = function()
            require "configs.rustaceanvim"
            require("configs.dap").rust()
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
            return require("configs.dap").cpp()
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
    -- need it to easily setup dap
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

    -- conform.nvim
    {
        "stevearc/conform.nvim",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- require "custom.kellsatnite.configs.formatting"
        end,
        -- opts = require "configs.conform",
    },

    -- nvim-lint
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        lazy = false,

        config = function()
            -- require("nvchad.core.utils").load_mappings "nvim_lint"
            require("configs.linting").config()
        end,
    },

    -- cmake tools
    {
        "Civitasv/cmake-tools.nvim",
        config = function()
            local opts = require "configs.cmake-tools"
            require("cmake-tools").setup(opts)
        end,
    },

    -- cloak.nvim
    {
        "laytan/cloak.nvim",
        lazy = true,
        opts = function()
            return require "configs.kcloak"
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
            return require "configs.bbq"
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
            return require "configs.redditcomments"
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
            require "configs.harpoon"
        end,
    },

    -- searchbox
    {
        "VonHeikemen/searchbox.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
    },

    -- markdown_preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = {
            "MarkdownPreviewToggle",
            "MarkdownPreview",
            "MarkdownPreviewStop",
        },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        config = function() end,
    },

    -- trouble
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        config = function()
            require("trouble").setup()
        end,
    },
}
