local M = {}
local harpoon = require "harpoon"
-- REQUIRED
M.harpoon = harpoon:setup()

local conf = require("telescope.config").values
M.toggle_telescope = function(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table {
                results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
        })
        :find()
end

-- key map for the telescope ui
vim.keymap.set("n", "<C-e>", function()
    M.toggle_telescope(M.harpoon:list())
end, { desc = "Open harpoon window" })

-- keymap to append to the list of files
vim.keymap.set("n", "<leader>a", function()
    M.harpoon:list():add()
end)

-- keymap to remove from the list of files
vim.keymap.set("n", "<leader>d", function()
    M.harpoon:list():remove()
end)

vim.keymap.set("n", "<leader>c", function()
    M.harpoon:list():clear()
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-a>", function()
    M.harpoon:list():prev()
end)
vim.keymap.set("n", "<C-q>", function()
    M.harpoon:list():next()
end)
return M
