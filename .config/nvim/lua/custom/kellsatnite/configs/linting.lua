local config = function()
    local lint = require "lint"
    local linters = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
    }


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
