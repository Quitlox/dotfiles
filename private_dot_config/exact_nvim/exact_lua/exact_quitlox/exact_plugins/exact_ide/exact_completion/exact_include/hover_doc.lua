
-- Hover Documentation
local function show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
    elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand("<cword>"))
    elseif vim.fn.expand("%:t") == "Cargo.toml" then
        -- Plugin: Saecki/crates.nvim
        -- TODO: Do not require crates if not filetype rust
        require("crates").show_popup()
    else
        vim.lsp.buf.hover()
    end
end

vim.keymap.set("n", "K", show_documentation, { noremap = true, silent = true })
