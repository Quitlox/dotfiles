----------------------------------------
-- Plugin
----------------------------------------

-- import("marks", function(module)
--     module.setup({
--         default_mappings = true,
--         signs = true,
--         mappings = {},
--     })
-- end)

import("harpoon", function(module)
    module.setup()
end)

----------------------------------------
-- Keybindings
----------------------------------------

import("which-key", function(wk)
    wk.register({
        m = {
            name = "Marks",
            t ={":lua require('harpoon.mark').add_file()<cr>",  "Toggle" },
            n ={":lua require('harpoon.mark').nav_next()<cr>",  "Next" },
            p ={":lua require('harpoon.mark').nav_prev()<cr>",  "Previous" },
        },
    }, {})
end)

-- import("which-key", function(wk)
--     wk.register({
--         g = {
--             ["'"] = {
--                 name = "Marks",
--             },
--         },
--         m = {
--             name = "Marks",
--             x = "Set mark x preview; press <cr> to preview the next mark.",
--             [","] = "Set the next available alphabetical (lowercase) mark",
--             [";"] = "Toggle the next available mark at the current line",
--             [":"] = "Preview mark. This will prompt you for a specific mark to",
--             ["]"] = "Move to next mark",
--             ["["] = "Move to previous mark",
--             ["0"] = "Add a bookmark from bookmark group 0.",
--             ["}"] = "Move to the next bookmark having the same type as the bookmark under the cursor. Works across buffers.",
--             ["{"] = "Move to the previous bookmark having the same type as the bookmark under the cursor. Works across buffers.",
--         },
--         d = {
--             m = {
--                 name = "Marks",
--                 x = "Delete mark x",
--                 ["-"] = "Delete all marks on the current line",
--                 ["<space>"] = "Delete all marks in the current buffer",
--                 ["0"] = "Delete all bookmarks from bookmark group 0.",
--                 ["="] = "Delete the bookmark under the cursor.",
--             },
--         },
--     }, {})
-- end)
