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

    -- dap-ui
    {
        -- check
        -- ".local/share/nvim/lazy/mason-nvim-dap.nvim/lua/mason-nvim-dap/mappings/configurations.lua"
        --M.codelldb = {
        -- 	{
        -- 	...
        -- 		args = function()
        -- 			return vim.split(vim.fn.input('Arguments: ', '', 'file'), ' ', {})
        -- 		end,
        -- 	},
        -- }

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

    {
        "sourcegraph/sg.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        lazy = false,
        -- If you have a recent version of lazy.nvim, you don't need to add this!
        build = "nvim -l build/init.lua",

        config = function()
            require("sg").setup()
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
            require("cloak").setup { opts }
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
    --   end,
    -- },

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

        lazy = false,
        config = function()
            local harpoon = require "harpoon"

            -- REQUIRED
            harpoon:setup()

            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers")
                    .new({}, {
                        prompt_title = "Harpoon",
                        finder = require("telescope.finders").new_table {
                            results = file_paths,
                        },
                        previewer = conf.file_previewer {},
                        sorter = conf.generic_sorter {},
                    })
                    :find()
            end

            -- keymap for the normal harpoon ui
            -- vim.keymap.set("n", "<C-e>", function()
            -- harpoon.ui:toggle_quick_menu(harpoon:list())
            -- end)

            -- key map for the telescope ui
            vim.keymap.set("n", "<C-e>", function()
                toggle_telescope(harpoon:list())
            end, { desc = "Open harpoon window" })

            -- keymap to append to the list of files
            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():append()
            end)

            -- keymap to remove from the list of files
            vim.keymap.set("n", "<leader>d", function()
                harpoon:list():remove()
            end)

            vim.keymap.set("n", "<leader>c", function()
                harpoon:list():clear()
            end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<C-a>", function()
                harpoon:list():prev()
            end)
            vim.keymap.set("n", "<C-q>", function()
                harpoon:list():next()
            end)

            -- vim.keymap.set("n", "<leader>1", function()
            --     harpoon:list():select(1)
            -- end)
            -- vim.keymap.set("n", "<leader>2", function()
            --     harpoon:list():select(2)
            -- end)
            -- vim.keymap.set("n", "<leader>3", function()
            --     harpoon:list():select(3)
            -- end)
            -- vim.keymap.set("n", "<leader>4", function()
            --     harpoon:list():select(4)
            -- end)
        end,
    },

    -- trouble
    -- {
    --     "folke/trouble.nvim",
    --     config = function()
    --         require("trouble").setup({
    --             icons = false,
    --         })
    --
    --         vim.keymap.set("n", "<leader>tt", function()
    --             require("trouble").toggle()
    --         end)
    --
    --         vim.keymap.set("n", "[t", function()
    --             require("trouble").next({skip_groups = true, jump = true});
    --         end)
    --
    --         vim.keymap.set("n", "]t", function()
    --             require("trouble").previous({skip_groups = true, jump = true});
    --         end)
    --
    --     end
    -- },
}

return plugins
