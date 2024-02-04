local config = function()
    local lint = require "lint"

    lint.linters_by_ft = {
        python = { "pylint", "mypy" },
        cmake = { "cmakelint" },
        cpp = { "clangtidy" },
        markdown = { "markdownlint" },
    }

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

    vim.keymap.set("n", "<leader>l", function()
        lint.try_lint()
    end, {
        desc = "Trigger Linting",
    })
end

return {
    config = config,
}
