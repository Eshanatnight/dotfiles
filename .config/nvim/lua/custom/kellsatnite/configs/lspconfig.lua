local base = require "plugins.configs.lspconfig"
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig.util"

-- clangd language server
lspconfig.clangd.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.signatureHelpProvider = false
        on_attach(client, bufnr)
    end,
    capabilities = capabilities,
}

-- typescript language server
lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.efm.setup {
    init_options = { documentFormatting = true },
    filetypes = { "typescript", "typescriptreact" },
    settings = {
        rootMarkers = { ".git/" },
        languages = {
            typescript = {
                {
                    formatCommand = "prettier --stdin-filepath ${INPUT}",
                    formatStdin = true,
                },
            },
        },
    },
}

-- python language server
lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" },
}

-- taplo language server(toml)
lspconfig.taplo.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "toml" },
}

-- cmake language server
lspconfig.cmake.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "cmake" },
    init_options = {
        buildDirectory = "build",
    },
    root_dir = util.root_pattern("CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake"),
    single_file_support = true,
}

-- go language server
lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = util.root_pattern("go.mod", "go.work", ".git"),
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true,
                shadow = true,
                fieldalignment = true,
                unusedvariables = true,
                unusedwrite = true,
            },
        },
    },
}

-- powershell language server
lspconfig.powershell_es.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

-- bash lsp
lspconfig.bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "sh", "bash", "zsh" },
}
