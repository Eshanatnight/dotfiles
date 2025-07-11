require("nvchad.configs.lspconfig").defaults()

local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities
local utils = require "utils"

local inlay_hints = require "inlay-hints"

vim.lsp.config("clangd", {
    on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        inlay_hints.on_attach(client, bufnr)
        on_attach(client, bufnr)
    end,
    capabilities = vim.tbl_deep_extend(
        "keep",
        { offsetEncoding = { "utf-16", "utf-8" } },
        capabilities
    ),
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    single_file_support = true,
    cmd = {
        "clangd",
        "-j=12",
        "--enable-config",
        "--background-index",
        "--pch-storage=memory",
        "--query-driver="
            .. utils.get_binary_paths { "clang++", "clang", "gcc", "g++" },
        "--clang-tidy",
        "--inlay-hints",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion-decorators",
        "--header-insertion=iwyu",
        "--limit-references=3000",
        "--limit-results=500",
    },
})

vim.lsp.config("bashls", {
    filetypes = { "sh", "bash", "zsh" },
})

vim.lsp.config("cmake", {})
vim.lsp.config("taplo", {})
vim.lsp.config("yamlls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("powershell_es", {})

local servers = {
    "lua_ls",
    "clangd",
    "cmake",
    "taplo",
    "yamlls",
    "bashls",
    "pyright",
    "powershell_es",
}

vim.lsp.enable(servers)
-- read :h vim.lsp.config for changing options of lsp servers
