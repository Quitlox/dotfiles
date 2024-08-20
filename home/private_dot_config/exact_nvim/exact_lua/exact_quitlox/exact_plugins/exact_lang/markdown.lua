-- +---------------------------------------------------------+
-- | tadmccorkle/markdown.nvim: Editing Support for Markdown |
-- +---------------------------------------------------------+

-- TODO: Fix mapping conflicts

--+- Keymaps ------------------------------------------------+
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "markdown",
    desc = "Setup markdown.nvim",
    group = vim.api.nvim_create_augroup("MyMarkdownGroup", { clear = true }),
    callback = function()
        require("markdown").setup({
            mappings = {
                inline_surround_toggle = "gs", -- (string|boolean) toggle inline style
                inline_surround_toggle_line = "gss", -- (string|boolean) line-wise toggle inline style
                inline_surround_delete = "ds", -- (string|boolean) delete emphasis surrounding cursor
                inline_surround_change = "cs", -- (string|boolean) change emphasis surrounding cursor
                link_add = "gl", -- (string|boolean) add link
                link_follow = "gx", -- (string|boolean) follow link
                go_curr_heading = "]c", -- (string|boolean) set cursor to current section heading
                go_parent_heading = "]p", -- (string|boolean) set cursor to parent section heading
                go_next_heading = "]]", -- (string|boolean) set cursor to next section heading
                go_prev_heading = "[[", -- (string|boolean) set cursor to previous section heading
            },
            inline_surround = {
                -- For the emphasis, strong, strikethrough, and code fields:
                -- * 'key': used to specify an inline style in toggle, delete, and change operations
                -- * 'txt': text inserted when toggling or changing to the corresponding inline style
                emphasis = {
                    key = "i",
                    txt = "*",
                },
                strong = {
                    key = "b",
                    txt = "**",
                },
                strikethrough = {
                    key = "s",
                    txt = "~~",
                },
                code = {
                    key = "c",
                    txt = "`",
                },
            },
            on_attach = function(bufnr)
                local function toggle(key) return "<Esc>gv<Cmd>lua require'markdown.inline'" .. ".toggle_emphasis_visual'" .. key .. "'<CR>" end

                vim.keymap.set("x", "<C-b>", toggle("b"), { buffer = bufnr })
                vim.keymap.set("x", "<C-i>", toggle("i"), { buffer = bufnr })
            end,
        })
    end,
})
