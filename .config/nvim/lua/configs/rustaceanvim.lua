local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities
local inlay_hints = require "inlay-hints"

vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            inlay_hints.on_attach(client, bufnr)
            on_attach(client, bufnr)
        end,
        capabilities = capabilities,
        default_settings = {
            --rust - analyzer language server
            ["rust-analyzer"] = {
                check = {
                    command = "clippy",
                },
            },
        },
    }
}
