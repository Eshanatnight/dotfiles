local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require "null-ls"

local opts = {
    sources = {
        -- formatter sources
        null_ls.builtins.formatting.gofumpt, -- golang
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.formatting.golines,
        null_ls.builtins.formatting.stylua, -- lua
        null_ls.builtins.formatting.prettier, -- javascript
        null_ls.builtins.formatting.black, -- python

        -- diagnostics sources
        null_ls.builtins.diagnostics.mypy.with {
            extra_args = function()
                -- use VIRTUAL_ENV or if conda use conda or default back to homebrew install
                -- need to update it for my linux machine
                -- Hard code it to "cwd/.venv/bin/python3" ??
                local virtual = os.getenv "VIRTUAL_ENV" or os.getenv "CONDA_PREFIX" or "/opt/homebrew"
                return { "--python-executable", virtual .. "/bin/python3" }
            end,
        },
        -- TODO: Maybe add actionlint(github workflows linter)
        null_ls.builtins.diagnostics.checkmake, -- make files
        null_ls.builtins.diagnostics.cmake_lint, -- cmake files
        null_ls.builtins.diagnostics.markdownlint, -- markdown files
        -------
        -- null_ls.builtins.diagnostics.cppcheck
        --------
    },
    on_attach = function(client, bufnr)
        if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds {
                group = augroup,
                buffer = bufnr,
            }
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format { bufnr = bufnr }
                end,
            })
        end
    end,
}

return opts
