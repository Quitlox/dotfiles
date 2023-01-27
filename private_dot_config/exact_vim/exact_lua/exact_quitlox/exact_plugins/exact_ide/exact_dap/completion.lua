return {
    "rcarriga/cmp-dap",
    dependencies = { "hrsh7th/nvim-cmp" },
    keys = "<localleader>d",
    config = function()
        require("cmp").setup({
            enabled = function()
                return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
            end,
        })
    end,
}
