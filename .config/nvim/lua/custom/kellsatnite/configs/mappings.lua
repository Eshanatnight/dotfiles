local M = {}

M.dap = {
    plugin = true,
    n = {
        ["<leader>db"] = {
            "<cmd> DapToggleBreakpoint <CR>",
            "Toggle Breakpoint",
        },
        ["<leader>dr"] = {
            "<cmd> DapContinue <CR>",
            "Start or continue the debugger",
        },
        ["<leader>i"] = {
            "<cmd> DapStepInto <CR>",
            "Step into the current function",
        },
        ["<leader>o"] = {
            "<cmd> DapStepOut <CR>",
            "Step out of the current function",
        },

        ["<leader>dus"] = {
            function()
                local widgets = require "dap.ui.widgets"
                local sidebar = widgets.sidebar(widgets.scopes)
                sidebar.open()
            end,
            "Open Debug Window",
        },
    },
}

M.general = {
    i = {
        ["jk"] = {
            "<ESC>",
            "Exit Insert Mode",
        },
    },

    n = {
        ["le"] = {
            "$",
            "Move to end of line",
        },
        ["ls"] = {
            "0",
            "Move to start of line",
        },
        ["<M-Right>"] = {
            "<C-i>",
            "Go to new cursor jump point",
        },
        ["<M-Left>"] = {
            "<C-o>",
            "Go to old cursor jump point",
        },
        ["<leader>cd"] = {
            "<cmd> :lua vim.diagnostic.open_float() <CR>",
            "Open Floating Diagnostics Popup",
        },
        ["<leader>cq"] = {
            "<cmd> :lua vim.diagnostic.setloclist() <CR>",
            "Open Diagnostics Popup",
        },
    },

    v = {
        ["le"] = {
            "$",
            "Move to end of line",
        },
        ["ls"] = {
            "0",
            "Move to start of line",
        },
    },
}

M.telescope = {
    n = {
        ["<leader>fd"] = {
            "<cmd> Telescope lsp_document_symbols <CR>",
            "Find Symbols",
        },

        ["<leader>fe"] = {
            "<cmd> Telescope lsp_workspace_symbols <CR>",
            "Find Diagnostics",
        },

        ["<leader>fg"] = {
            "<cmd> Telescope git_files <CR>",
            "Find All(Git) Files",
        },

        ["<leader>ff"] = {
            function()
                require("telescope.builtin").find_files { hidden = true }
            end,
            "Find Files",
        },

        ["<leader>q"] = {
            "<cmd> Telescope diagnostics <CR>",
            "Find Diagnostics",
        },
    },
}

M.nvim_lint = {
    n = {
        ["<leader>l"] = {
            function()
                local lint = require "lint"
                lint.try_lint()
            end,
            "Try Lint Current File",
        },
    },
}

M.harpoon = {
    n = {
        ["<C-e>"] = {
            function()
                local harpoon = require "custom.kellsatnite.configs.harpoon"

                harpoon.toggle_telescope(harpoon.harpoon:list())
            end,
            "Open Harpoon Window",
        },
        ["<leader>a"] = {
            function()
                local harpoon = require "custom.kellsatnite.configs.harpoon"

                harpoon.harpoon:list():add()
            end,
            "Add new Harpoon Marker",
        },
        ["<leader>d"] = {
            function()
                local harpoon = require "custom.kellsatnite.configs.harpoon"

                harpoon.harpoon:list():remove()
            end,
            "Remove a Harpoon Marker",
        },

        ["<leader>c"] = {
            function()
                local harpoon = require "custom.kellsatnite.configs.harpoon"

                harpoon.harpoon:list():clear()
            end,
            "Remove all Harpoon Markers",
        },

        ["<C-a>"] = {
            function()
                local harpoon = require "custom.kellsatnite.configs.harpoon"

                harpoon.harpoon:list():prev()
            end,
            "Toggle the previous Harpoon Markers",
        },

        ["<C-q>"] = {
            function()
                local harpoon = require "custom.kellsatnite.configs.harpoon"

                harpoon.harpoon:list():next()
            end,
            "Toggle the next Harpoon Marker",
        },
    },
}

M.searchbox = {
    n = {
        ["<leader>s"] = {
            "<cmd>SearchBoxMatchAll clear_matches=false<CR>",
            "Enter Search Box",
        },
        ["<leader>c"] = {
            "<cmd>SearchBoxClear<CR>",
            "Clear Search Matches",
        },
        ["<leader>ss"] = {
            "<cmd>SearchBoxIncSearch<CR>",
            "Enter Search Box",
        },
        ["<leader>r"] = {
            "<cmd>SearchBoxReplace<CR>",
            "Enter Replace Search Box",
        },
    },
}

M.todo_comments = {
    n = {
        ["<leader>td"] = {
            function()
                require("todo-comments").jump_next()
            end,
            "Jump to Next Todo",
        },

        ["<leader>tt"] = {
            function()
                require("todo-comments").jump_prev()
            end,
            "Jump to Previous Todo",
        },

        ["td"] = {
            "<cmd> TodoTelescope <CR>",
            "Find Todos",
        },
    },
}

M.trouble = {
    n = {
        ["<leader>q"] = {
            "<cmd>Trouble diagnostics toggle<cr>",
            "Trouble Diagnostics",
        },
        ["<leader>qb"] = {
            "<cmd> Trouble diagnostics toggle filter.buf=0<CR>",
            "Trouble Diagnostics Current Buffer",
        },
    },
}

return M
