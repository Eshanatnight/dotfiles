---@alias conform.FormatterUnit string|string[]
---@alias conform.FiletypeFormatter conform.FormatterUnit[]|fun(bufnr: integer): string[]

local options = {
    ---@type table<string, conform.FiletypeFormatter>
    formatters_by_ft = {
        cpp = { "clang_format" },
        c = { "clang_format" },
        lua = { "stylua" },
        python = { "isort", "black" },
        -- not doing rustfmt here because it's handled by rust-tools.nvim
    },

    format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
    },
}

require("conform").setup(options)
