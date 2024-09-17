local utils = require "custom.kellsatnite.utils"

local M = {
    "bash-language-server",
    "black",
    "clang-format",
    "clangd",
    "cmake-language-server",
    "cmakelint",
    "codelldb",
    "checkmate",
    "delve",
    "gofumpt",
    "goimports-reviser",
    "golines",
    "gopls",
    "isort",
    "markdownlint",
    "mypy",
    "powershell-editor-services",
    "prettier",
    "protolint",
    "pylint",
    "pyright",
    "rust-analyzer",
    "shfmt",
    "stylua",
    "taplo",
    "typescript-language-server",
    "yamlfix",
    "yamllint",
}

local os = utils.get_os()

if os == "Linux" or os == "Darwin" then
    table.insert(M, "lua-language-server")
else
    table.insert(M, "lua-ls")
end

return M
