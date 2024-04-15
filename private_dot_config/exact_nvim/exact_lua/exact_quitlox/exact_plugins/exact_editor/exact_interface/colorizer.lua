----------------------------------------------------------------------
--                            Colorizer                             --
----------------------------------------------------------------------
-- Display color of hex-values and other color codes in a buffer

return {
    "NvChad/nvim-colorizer.lua",
    config = function(_, opts)
        require("colorizer").setup(opts)
    end,
    opts = {
        filetypes = { "*", javascript = { tailwind = false } },
        user_default_options = {
            RGB = false,
            RRGGBBAA = true,
            names = false,
            tailwind = false,
        },
    },
}
