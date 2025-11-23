-- +---------------------------------------------------------+
-- | oribarilan/lensline.nvim: Codelens                      |
-- +---------------------------------------------------------+

require("lensline").setup({
    limits = {
        exclude = {
            ".config/nvim/**/*.lua",
        },
    },
})

Snacks.toggle
    .new({
        name = "Lensline",
        get = function()
            return require("lensline").is_enabled()
        end,
        set = function(state)
            if state then
                require("lensline").enable()
            else
                require("lensline").disable()
            end
        end,
    })
    :map("yol")
