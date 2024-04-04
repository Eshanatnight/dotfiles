local utils = require "custom.kellsatnite.utils"

local M = {
    "rust-analyzer",
    "clangd",
    "cmakelint",
    "clang-format",
    "codelldb",
    "black",
    "pyright",
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
}

local os = utils.get_os()

if os == "Linux" then
    table.insert(M, "lua-language-server")
else
    table.insert(M, "lua-ls")
end

return M
