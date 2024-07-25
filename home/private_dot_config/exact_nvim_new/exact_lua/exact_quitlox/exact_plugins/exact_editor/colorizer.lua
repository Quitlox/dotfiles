-- +---------------------------------------------------------+
-- | norcalli/nvim-colorizer: Highlight colors in code       |
-- +---------------------------------------------------------+

local OPTIONS = {
    RGB = false,
    RRGGBBAA = true,
    names = false,
    tailwind = false,
}

function enable_for_filetype()
    local ft = vim.bo.filetype

    -- Attach to the current buffer
    require("colorizer").attach_to_buffer(0, OPTIONS)

    -- Attach to buffers of the current filetype
    if not ft then
        vim.notify("No filetype set!", vim.log.levels.WARN, { title = "Colorizer" })
        return
    end
    vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        group = vim.api.nvim_create_augroup("MyColorizer", { clear = false }),
        callback = function() require("colorizer").attach_to_buffer(0, OPTIONS) end,
    })
end

require("legendary").commands({
    { ":ColorizerEnableForFT", enable_for_filetype, description = "Enable colorizer for the current filetype" },
})
