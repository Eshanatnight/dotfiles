local utils = require "custom.kellsatnite.utils"

local M = {
    "rust-analyzer",
    "clangd",
    "cmakelint",
    "clang-format",
    "codelldb",
    "black",
    "checkmate",
    "cmake-language-server",
    "isort",
    "markdownlint",
    "mypy",
    "prettier",
    "pylint",
    "stylua",
    "bash-language-server",
    "protolint",
    "gopls",
    "gofumpt",
    "golines",
    "goimports-reviser",
    "delve",
    "taplo",
}

local os = utils.get_os()

if os == "Linux" or os == "Darwin" then
    table.insert(M, "lua-language-server")
else
    table.insert(M, "lua-ls")
end

return M
