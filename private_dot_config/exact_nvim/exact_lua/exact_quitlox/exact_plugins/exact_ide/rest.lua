return {
    "aquach/vim-http-client",
    ft = "http",
    init = function()
        vim.g.http_client_bind_hotkey = 0
        vim.g.http_client_json_ft = "vim-json"
        vim.g.http_client_focus_output_window = 0
        vim.g.http_client_preserve_responses = 1
    end,
    keys = {
        { "<localleader>rr", "<cmd>HTTPClientDoRequest<cr>", desc = "Run HTTP request under cursor" },
    },
}
