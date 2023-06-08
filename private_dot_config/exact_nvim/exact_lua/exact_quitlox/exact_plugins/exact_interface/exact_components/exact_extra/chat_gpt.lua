return {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function() require("chatgpt").setup() end,
    init = function()
        require("legendary").command({
            ":ChatGPT",
            description = "ChatGPT: Chat",
        })
        require("legendary").command({
            ":ChatGPTActAs",
            description = "ChatGPT: Act as",
        })
        require("legendary").command({
            ":ChatGPTEditWithInstructions",
            description = "ChatGPT: Edit with instructions",
        })
    end,
}
