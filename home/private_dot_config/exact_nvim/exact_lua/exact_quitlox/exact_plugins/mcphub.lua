-- +---------------------------------------------------------+
-- | ravitemer/mcphub.nvim: MCP Hub                          |
-- +---------------------------------------------------------+

require("mcphub").setup({
    port = 37373,
    config = vim.fn.expand("~/.config/mcphub/servers.json"),

    auto_approve = false,
    extensions = {
        codecompanion = {
            show_result_in_chat = true,
            make_vars = true,
            make_slash_commands = true,
        },
    },
})
