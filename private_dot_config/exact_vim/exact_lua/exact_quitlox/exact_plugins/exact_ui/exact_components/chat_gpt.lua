return {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function() require("chatgpt").setup({}) end,
    init = function()
        require("which-key").register({
            ["<leader>m"] = {
                name = "Misceallenous",
                c = {
                    name = "ChatGPT",
                    ["a"] = { "<cmd>ChatGPTActAs<cr>", "Act as" },
                    ["c"] = { "<cmd>ChatGPT<cr>", "Chat" },
                    ["e"] = { "<cmd>ChatGPTEditWithInstructions<cr>", "Edit with instructions" },
                },
            },
        })
    end,
}