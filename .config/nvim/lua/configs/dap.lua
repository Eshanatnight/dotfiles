local dap = require "dap"
local UDap = require "utils"

local M = {}

M.get_launch_file = function()
    local launch_file_path = vim.fn.getcwd() .. "/.vscode/launch.json"
    local file = io.open(launch_file_path, "r")

    return file
end

M.rust = function()
    local file = M.get_launch_file()
    if file == nil then
        dap.configurations.rust = {
            {
                type = "codelldb",
                request = "launch",
                name = "Default",
                program = function()
                    return UDap.find_rust_program(dap)
                end,
                args = UDap.get_args,
                cwd = "${workspaceFolder}",
                stopOnEntry = true,
            },
        }
    else
        io.close(file)

        -- a nil path defaults to .vscode/launch.json
        require("dap.ext.vscode").load_launchjs(nil, { codelldb = { "rust" } })
    end
end

M.cpp = function()
    local file = M.get_launch_file()

    if file == nil then
        dap.configurations.cpp = {
            {
                type = "codelldb",
                request = "launch",
                name = "Default",
                program = function()
                    return UDap.find_program(dap)
                end,
                args = UDap.get_args,
                cwd = "${workspaceFolder}",
                stopOnEntry = true,
            },
        }

        dap.configurations.c = dap.configurations.cpp
    else
        io.close(file)

        -- a nil path defaults to .vscode/launch.json
        require("dap.ext.vscode").load_launchjs(nil, { codelldb = { "cpp" } })
    end
end

return M
