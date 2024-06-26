local options = {
    panel = {
        enabled = false,
        auto_refresh = false, -- if set to true, panel will be refreshed as as you type
        keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<M-CR>",
            refresh = "gr",
            open = "<CR>",
        },
        layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4,
        },
    },
    suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
            accept = "<M-,>",
            accept_word = "<M-.>", -- to deactive false
            accept_line = "<C-j>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
        },
    },
    filetypes = {
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
    },
    copilot_node_command = "node", -- Node.js version must be > 16.x
    server_opts_overrides = {},
}

--
return options
