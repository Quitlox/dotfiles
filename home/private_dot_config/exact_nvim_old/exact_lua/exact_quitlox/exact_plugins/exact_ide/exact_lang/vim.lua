return {
    {
        "jbyuki/one-small-step-for-vimkind",
        ft = "lua",
        config = function()
            local dap = require("dap")
            dap.configurations.lua = {
                {
                    type = "nlua",
                    request = "attach",
                    name = "Attach to running Neovim instance",
                },
            }

            dap.adapters.nlua = function(callback, config) callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }) end
        end,
        keys = {
            { "<F5>", "<cmd>lua require'osv'.launch({port = 8086})<cr>", noremap = true },
        },
    },
}
