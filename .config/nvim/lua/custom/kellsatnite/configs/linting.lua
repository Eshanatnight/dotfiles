local config = function()
    local lint = require "lint"
    local linters = {
        python = { "pylint", "mypy" },
        cmake = { "cmakelint" },
        -- cpp = { "clangtidy" },
        markdown = { "markdownlint" },
    }

    local ct = require("custom.kellsatnite.utils").has_clang_tidy()
    if ct == 1 then
        linters.cpp = {
            "clangtidy",
        }
    end

    lint.linters_by_ft = linters

    local lint_augroup = vim.api.nvim_create_augroup("lint", {
        clear = true,
    })

    vim.api.nvim_create_autocmd({
        "BufEnter",
        "BufWritePost",
    }, {
        group = lint_augroup,
        callback = function()
            lint.try_lint()
        end,
    })
end

return {
    config = config,
}
