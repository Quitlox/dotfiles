-- TODO: Does this work properly?
vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        require("quitlox.util.cmp").extend_cmp(
            function(config)
                table.insert(config.sources, {
                    name = "lazydev",
                    group_index = 0,
                })
            end
        )
    end,
})
