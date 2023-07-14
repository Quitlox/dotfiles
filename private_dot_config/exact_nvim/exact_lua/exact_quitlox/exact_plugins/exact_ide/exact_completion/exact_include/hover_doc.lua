-- Hover Documentation
local function show_documentation()
    local filetype = vim.bo.filetype

    -- Plugin ufo.nvim (fold)
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if winid then return end
    -- Help page
    if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
        -- Man page
    elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand("<cword>"))
        -- Plugin: Saecki/crates.nvim
    elseif vim.fn.expand("%:t") == "Cargo.toml" then
        require("crates").show_popup()
    else
        vim.lsp.buf.hover() -- Uses LspSaga
    end
end

vim.keymap.set("n", "K", show_documentation, { noremap = true, silent = true })
