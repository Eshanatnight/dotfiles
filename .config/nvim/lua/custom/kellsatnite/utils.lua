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

return M
