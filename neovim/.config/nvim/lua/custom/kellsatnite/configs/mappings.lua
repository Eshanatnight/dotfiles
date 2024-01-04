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
}

return M
