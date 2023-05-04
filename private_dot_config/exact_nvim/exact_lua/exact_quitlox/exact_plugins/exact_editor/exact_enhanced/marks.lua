return {
    "chentoast/marks.nvim",
    init = function()
        require("which-key").register({
            d = {
		name = "Delete",
                m = {
                    name = "Marks",
                    ["x"] = { "Delete mark x" },
                    ["-"] = { "Delete all marks on the current line" },
                    ["<space>"] = { "Delete all marks in the current buffer" },
                },
            },
            m = {
                name = "Marks",
                [","] = { "Set the next available alphabetical (lowercase) mark" },
                [";"] = { "Toggle the next available mark at the current line" },
                ["]"] = { "Move to next mark" },
                ["["] = { "Move to previous mark" },
                [":"] = {
                    "Preview mark. This will prompt you for a specific mark to preview; press <cr> to preview the next mark.",
                },
                ["}"] = {
                    "Move to the next bookmark having the same type as the bookmark under the cursor. Works across buffers.",
                },
                ["{"] = {
                    "Move to the previous bookmark having the same type as the bookmark under the cursor. Works across buffers.",
                },
            },
        })
    end,
    config = true,
    lazy = false,
}
