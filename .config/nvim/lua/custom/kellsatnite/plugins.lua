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

    {
        "Civitasv/cmake-tools.nvim",
        config = function()
            require("cmake-tools").setup {
                cmake_command = "cmake", -- this is used to specify cmake command path
                ctest_command = "ctest", -- this is used to specify ctest command path
                cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
                cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
                cmake_build_options = {}, -- this will be passed when invoke `CMakeBuild`
                -- support macro expansion:
                --       ${kit}
                --       ${kitGenerator}
                --       ${variant:xx}
                cmake_build_directory = "out/${variant:buildType}", -- this is used to specify generate directory for cmake, allows macro expansion, relative to vim.loop.cwd()
                cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
                cmake_compile_commands_from_lsp = false, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
                cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
                cmake_variants_message = {
                    short = { show = true }, -- whether to show short message
                    long = { show = true, max_length = 40 }, -- whether to show long message
                },
                cmake_dap_configuration = { -- debug settings for cmake
                    name = "cpp",
                    type = "codelldb",
                    request = "launch",
                    stopOnEntry = false,
                    runInTerminal = true,
                    console = "integratedTerminal",
                },
                cmake_executor = { -- executor to use
                    name = "quickfix", -- name of the executor
                    opts = {}, -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
                    default_opts = { -- a list of default and possible values for executors
                        quickfix = {
                            show = "always", -- "always", "only_on_error"
                            position = "belowright", -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
                            size = 10,
                            encoding = "utf-8", -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
                            auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
                        },
                        toggleterm = {
                            direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
                            close_on_exit = false, -- whether close the terminal when exit
                            auto_scroll = true, -- whether auto scroll to the bottom
                        },
                        overseer = {
                            new_task_opts = {
                                strategy = {
                                    "toggleterm",
                                    direction = "horizontal",
                                    autos_croll = true,
                                    quit_on_exit = "success",
                                },
                            }, -- options to pass into the `overseer.new_task` command
                            on_new_task = function(task)
                                require("overseer").open { enter = false, direction = "right" }
                            end, -- a function that gets overseer.Task when it is created, before calling `task:start`
                        },
                        terminal = {
                            name = "Main Terminal",
                            prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                            split_direction = "horizontal", -- "horizontal", "vertical"
                            split_size = 11,

                            -- Window handling
                            single_terminal_per_instance = true, -- Single viewport, multiple windows
                            single_terminal_per_tab = true, -- Single viewport per tab
                            keep_terminal_static_location = true, -- Static location of the viewport if avialable

                            -- Running Tasks
                            start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
                            focus = false, -- Focus on terminal when cmake task is launched.
                            do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
                        }, -- terminal executor uses the values in cmake_terminal
                    },
                },
                cmake_runner = { -- runner to use
                    name = "terminal", -- name of the runner
                    opts = {}, -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
                    default_opts = { -- a list of default and possible values for runners
                        quickfix = {
                            show = "always", -- "always", "only_on_error"
                            position = "belowright", -- "bottom", "top"
                            size = 10,
                            encoding = "utf-8",
                            auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
                        },
                        toggleterm = {
                            direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
                            close_on_exit = false, -- whether close the terminal when exit
                            auto_scroll = true, -- whether auto scroll to the bottom
                        },
                        overseer = {
                            new_task_opts = {
                                strategy = {
                                    "toggleterm",
                                    direction = "horizontal",
                                    autos_croll = true,
                                    quit_on_exit = "success",
                                },
                            }, -- options to pass into the `overseer.new_task` command
                            on_new_task = function(task) end, -- a function that gets overseer.Task when it is created, before calling `task:start`
                        },
                        terminal = {
                            name = "Main Terminal",
                            prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                            split_direction = "horizontal", -- "horizontal", "vertical"
                            split_size = 11,

                            -- Window handling
                            single_terminal_per_instance = true, -- Single viewport, multiple windows
                            single_terminal_per_tab = true, -- Single viewport per tab
                            keep_terminal_static_location = true, -- Static location of the viewport if avialable

                            -- Running Tasks
                            start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
                            focus = false, -- Focus on terminal when cmake task is launched.
                            do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
                        },
                    },
                },
                cmake_notifications = {
                    runner = { enabled = true },
                    executor = { enabled = true },
                    spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
                    refresh_rate_ms = 100, -- how often to iterate icons
                },
            }
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
