return {
    {
        "rcarriga/cmp-dap",
        lazy = true,
        dependencies = { "hrsh7th/nvim-cmp" },
    },
    {
        "hrsh7th/nvim-cmp",
        opts = {
            enabled = function() return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer() end,
        },
    },
}
