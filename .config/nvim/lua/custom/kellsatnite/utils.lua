local M = {}

--- Get the operating system of the current system.
---
--- This function first tries to get the operating system using LuaJIT's `jit.os` property.
--- If that fails, it falls back to using Lua's `os.getenv("OS")` function.
---
--- @return string The name of the operating system
M.get_os = function()
    -- ask LuaJIT first

    ---@diagnostic disable-next-line: undefined-global
    if jit then
        ---@diagnostic disable-next-line: undefined-global
        return jit.os
    end

    -- Unix, Linux variants
    local fh, err = assert(io.popen("uname -o 2>/dev/null", "r"))
    if fh then
        ---@diagnostic disable-next-line: lowercase-global
        osname = fh:read()
    end

    return osname or "Windows"
end

--- a couroutine to get the arguments for the dap run command.
--- https://github.com/leoluz/nvim-dap-go/blob/a5cc8dcad43f0732585d4793deb02a25c4afb766/lua/dap-go.lua#L25
--- @return thread
function M.get_args()
    return coroutine.create(function(dap_run_co)
        local args = {}
        vim.ui.input({ prompt = "Args: " }, function(input)
            args = vim.split(input or "", " ")
            coroutine.resume(dap_run_co, args)
        end)
    end)
end

--- Find the executable for the current cargo workspace. (only for rust)
---
--- @param dap any
--- @return string | {}  (signals an operation should be aborted).
M.find_rust_program = function(dap)
    local workspaceFolderBasename = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local debug_bin = vim.fn.expand("./target/debug/" .. workspaceFolderBasename)
    if vim.fn.executable(debug_bin) == 1 then
        return debug_bin
    end
    vim.print("Unable to find executable for '" .. debug_bin .. "'")
    return dap.ABORT
end

--- Find the executable for the current workspace. (only for rust)
---
--- @param dap any
--- @return string | {}  (signals an operation should be aborted).
M.find_program = function(dap)
    local debug_bin = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")

    if vim.fn.executable(debug_bin) == 1 then
        return debug_bin
    end

    vim.print("Unable to find executable for '" .. debug_bin .. "'")
    return dap.ABORT
end

--- Check if the current system has clang-tidy installed.
---
--- @return number
M.has_clang_tidy = function()
    return vim.fn.executable "clang-tidy"
end

--- Get the binary path for the given binary names.
---
--- @param binary_names table
--- @return string  binary path
M.get_binary_paths = function(binary_names)
    for _, elem in ipairs(binary_names) do
        local path = vim.fn.exepath(elem)
        if path ~= "" then
            return path
        end
    end
    return ""
end

M.get_python_path = function()
    local virtual = os.getenv "VIRTUAL_ENV" or os.getenv "CONDA_PREFIX"

    if virtual then
        if M.get_os() == "Windows" then
            return virtual .. "/bin/python"
        else
            return virtual .. "/bin/python3"
        end
    end

    local py_path = vim.fn.exepath "python"

    if py_path == "" then
        return py_path
    else
        return vim.fn.exepath "python3"
    end
end

return M
