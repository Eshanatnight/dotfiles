local config = function()
    local lint = require "lint"
    local linters = {
        python = { "pylint", "mypy" },
        cmake = { "cmakelint" },
        -- cpp = { "clangtidy" },
        markdown = { "markdownlint" },
    }

    local ct = require("custom.kellsatnite.utils").has_clang_tidy()
    local compile_commands_path = vim.fn.getcwd() .. "/build/compile_commands.json"
    if ct == 1 then
        linters.cpp = {
            "clangtidy",
        }
        linters.c = {
            "clangtidy",
        }
        table.insert(lint.linters.clangtidy.args, compile_commands_path)
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
