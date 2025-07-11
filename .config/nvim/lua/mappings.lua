require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Dap mappings
map(
    "n",
    "<leader>db",
    "<cmd> DapToggleBreakpoint <CR>",
    { desc = "Dap Toggle Breakpoint" }
)
map(
    "n",
    "<leader>dr",
    "<cmd> DapContinue <CR>",
    { desc = "Dap Start or continue the debugger" }
)
map(
    "n",
    "<leader>i",
    "<cmd> DapStepInto <CR>",
    { desc = "Dap Step into the current function" }
)
map(
    "n",
    "<leader>o",
    "<cmd> DapStepOut <CR>",
    { desc = "Dap Step out the current function" }
)
map("n", "<leader>dus", function()
    local widgets = require "dap.ui.widgets"
    local sidebar = widgets.sidebar(widgets.scopes)
    sidebar.open()
end, { desc = "Dap Open Debug Window" })

-- Dap go mappings
map("n", "<leader>dgt", function()
    require("dap-go").debug_test()
end, { desc = "Dap Go Debug Go Tests" })
map("n", "<leader>dgl", function()
    require("dap-go").debug_last()
end, { desc = "Dap Go Debug Last Tests" })

-- General
map({ "v", "n" }, "le", "$", { desc = "General Move to end of line" })
map({ "v", "n" }, "ls", "0", { desc = "General Move to start of line" })
map("n", "<M-Right>", "<C-i>", { desc = "General Go to new cursor jump point" })
map("n", "<M-Left>", "<C-o>", { desc = "General Go to old cursor jump point" })
map(
    "n",
    "<leader>cd",
    "<cmd> :lua vim.diagnostic.open_float() <CR>",
    { desc = "General Open Floating Diagnostics Popup" }
)
map(
    "n",
    "<leader>cq",
    "<cmd> :lua vim.diagnostic.setloclist() <CR>",
    { desc = "General Open Diagnostics Popup" }
)

-- crates
map("n", "<leader>cu", function()
    require("crates").upgrade_crate()
end, { desc = "Crates Upgrade Crate" })

map("n", "<leader>rcu", function()
    require("crates").upgrade_all_crates()
end, { desc = "Crates Upgrade All Crates" })

-- telescope mappings
map(
    "n",
    "<leader>fd",
    "<cmd> Telescope lsp_document_symbols <CR>",
    { desc = "Telescope Find Symbols" }
)

map(
    "n",
    "<leader>fe",
    "<cmd> Telescope lsp_workspace_symbols <CR>",
    { desc = "Telescope Workspace Symbols" }
)

map(
    "n",
    "<leader>fg",
    "<cmd> Telescope git_files <CR>",
    { desc = "Telescope Find All(Git) Files" }
)

map("n", "<leader>ff", function()
    require("telescope.builtin").find_files { hidden = true }
end, { desc = "Telescope Find Files" })

-- nvim lint
map("n", "<leader>l", function()
    local lint = require "lint"
    lint.try_lint()
end, { desc = "NVIM Lint Try Lint Current File" })

-- harpoon
map("n", "<C-e>", function()
    local harpoon = require "configs.harpoon"

    harpoon.toggle_telescope(harpoon.harpoon:list())
end, { desc = "Harpoon Open Harpoon Window" })

map("n", "<leader>a", function()
    local harpoon = require "configs.harpoon"

    harpoon.harpoon:list():add()
end, { desc = "Harpoon Add new Harpoon Marker" })

map("n", "<leader>d", function()
    local harpoon = require "configs.harpoon"

    harpoon.harpoon:list():remove()
end, { desc = "Harpoon Remove a Harpoon Marker" })

map("n", "<leader>c", function()
    local harpoon = require "configs.harpoon"

    harpoon.harpoon:list():clear()
end, { desc = "Harpoon Remove all Harpoon Markers" })

map("n", "<C-a>", function()
    local harpoon = require "configs.harpoon"

    harpoon.harpoon:list():prev()
end, { desc = "Harpoon Toggle the previous Harpoon Markers" })

map("n", "<C-q>", function()
    local harpoon = require "configs.harpoon"

    harpoon.harpoon:list():next()
end, { desc = "Harpoon Toggle the next Harpoon Marker" })

-- search box
map(
    "n",
    "<leader>s",
    "<cmd>SearchBoxMatchAll clear_matches=false<CR>",
    { desc = "Searchbox Enter Search Box" }
)
map(
    "n",
    "<leader>c",
    "<cmd>SearchBoxClear<CR>",
    { desc = "Searchbox Clear Search Matches" }
)
map(
    "n",
    "<leader>ss",
    "<cmd>SearchBoxIncSearch<CR>",
    { desc = "Searchbox Enter Search Box" }
)
map(
    "n",
    "<leader>r",
    "<cmd>SearchBoxReplace<CR>",
    { desc = "Searchbox Enter Replace Search Box" }
)

-- markdown preview
map(
    "n",
    "<leader>mp",
    "<cmd> MarkdownPreview<CR>",
    { desc = "MarkdownPreview Open Markdown Preview" }
)
map(
    "n",
    "<leader>mc",
    "<cmd> MarkdownPreviewStop<CR>",
    { desc = "MarkdownPreview Stop Markdown Preview" }
)

-- todo comments
map("n", "<leader>td", function()
    require("todo-comments").jump_next()
end, { desc = "Todo Jump to Next Todo" })

map("n", "<leader>tt", function()
    require("todo-comments").jump_prev()
end, { desc = "Todo Jump to Previous Todo" })

map("n", "td", "<cmd> TodoTelescope <CR>", { desc = "Todo Find Todos" })

-- trouble
map(
    "n",
    "<leader>q",
    "<cmd>Trouble diagnostics toggle<CR>",
    { desc = "Trouble Diagnostics" }
)
map(
    "n",
    "<leader>qb",
    "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
    { desc = "Trouble Diagnostics Current Buffer" }
)

map("n", "<leader>ca", function()
    vim.lsp.buf.code_action()
end, { desc = "LSP Code Action" })

map("n", "<leader>fff", function()
    require("fzf-lua").files()
end, { desc = "FZFLua Find Files" })
