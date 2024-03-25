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

M.dap_go = {
    plugin = true,
    n = {
        ["<leader>dgt"] = {
            function()
                require("dap-go").debug_test()
            end,
            "Debug Go Test",
        },
        ["<leader>dgl"] = {
            function()
                require("dap-go").debug_last()
            end,
            "Debug Last Test",
        },
    },
}

M.crates = {
    n = {
        ["<leader>rcu"] = {
            function()
                require("crates").upgrade_all_crates()
            end,
            "Upgrade Crates",
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

        ["<leader>fe"] = {
            "<cmd> Telescope lsp_workspace_symbols <CR>",
            "Find Diagnostics",
        },

        ["<leader>q"] = {
            "<cmd> Telescope diagnostics <CR>",
            "Find Diagnostics",
        },
    },
}

return M
