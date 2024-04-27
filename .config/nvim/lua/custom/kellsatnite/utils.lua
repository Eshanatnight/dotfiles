local M = {}

--- Get the operating system of the current system.
---
--- This function first tries to get the operating system using LuaJIT's `jit.os` property.
--- If that fails, it falls back to using Lua's `os.getenv("OS")` function.
---
--- @return string The name of the operating system
M.get_os = function()
    -- ask LuaJIT first

    if jit then
        return jit.os
    end

    -- Unix, Linux variants
    local fh, err = assert(io.popen("uname -o 2>/dev/null", "r"))
    if fh then
        osname = fh:read()
    end

    return osname or "Windows"
end

M.get_os()

-- https://github.com/leoluz/nvim-dap-go/blob/a5cc8dcad43f0732585d4793deb02a25c4afb766/lua/dap-go.lua#L25
function M.get_args()
    return coroutine.create(function(dap_run_co)
        local args = {}
        vim.ui.input({ prompt = "Args: " }, function(input)
            args = vim.split(input or "", " ")
            coroutine.resume(dap_run_co, args)
        end)
    end)
end

M.find_program = function(dap)
    local workspaceFolderBasename = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local debug_bin = vim.fn.expand("./target/debug/" .. workspaceFolderBasename)
    if vim.fn.executable(debug_bin) == 1 then
        return debug_bin
    end
    vim.print("Unable to find executable for '" .. debug_bin .. "'")
    return dap.ABORT
end

-- @return number
M.has_clang_tidy = function()
    return vim.fn.executable "clang-tidy"
end

return M
