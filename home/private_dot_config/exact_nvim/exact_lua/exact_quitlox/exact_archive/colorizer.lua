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

    if not ft then
        vim.notify("No filetype set!", vim.log.levels.WARN, { title = "Colorizer" })
        return
    end

    -- Attach to buffers of the current filetype
    vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        group = vim.api.nvim_create_augroup("MyColorizer", { clear = true }),
        callback = function()
            require("colorizer").attach_to_buffer(0, OPTIONS)
        end,
    })
end

vim.api.nvim_create_user_command("ColorizerEnableForFT", enable_for_filetype, {
    desc = "Enable colorizer for the current filetype",
})
