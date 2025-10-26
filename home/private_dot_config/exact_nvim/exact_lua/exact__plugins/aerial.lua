-- +---------------------------------------------------------+
-- | stevearc/aerial.nvim: Symbols Outline                   |
-- +---------------------------------------------------------+

local aerial_util = require("aerial.util")
local codicons = require("_config.util.codicons")

local original_flash_highlight = aerial_util.flash_highlight
aerial_util.flash_highlight = function(bufnr, lnum, duration_ms, hl_group)
    original_flash_highlight(bufnr, lnum, duration_ms, hl_group or "Visual")
end

local function rust_capture_text(match, key, bufnr)
    local node = match and match[key] and match[key].node or nil
    local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr)
    return ok and text or nil
end

local function rust_impl_label(bufnr, match, fallback)
    local impl_type = rust_capture_text(match, "rust_type", bufnr)
    local impl_trait = rust_capture_text(match, "trait", bufnr)
    if impl_trait and impl_type then
        return string.format("impl %s for %s", impl_trait, impl_type)
    elseif impl_type then
        return string.format("impl %s", impl_type)
    end
    return fallback
end

local function rust_signature_label(bufnr, match, base_name)
    local params = rust_capture_text(match, "rust_params", bufnr) or "()"
    local return_type = rust_capture_text(match, "rust_return", bufnr)
    return_type = return_type and (" -> " .. return_type) or ""
    return string.format("fn %s%s%s", base_name, params, return_type)
end

local function rust_post_parse_symbol(bufnr, item, ctx)
    if item.kind == "Struct" then
        item.name = string.format("struct %s", item.name)
    end
    if item.kind == "Interface" then
        item.name = string.format("trait %s", item.name)
    end
    if item.kind == "Class" then
        item.name = rust_impl_label(bufnr, ctx.match, item.name)
    end
    if item.kind == "Method" then
        item.name = rust_signature_label(bufnr, ctx.match, item.name)
    end
    return true
end

require("aerial").setup({
    attach_mode = "global",
    backends = {
        ["_"] = { "lsp", "treesitter", "markdown", "man" },
        rust = { "treesitter", "lsp" },
    },
    layout = {
        -- NOTE: Options below (except styling) required for compatiblity with edgy.nvim
        win_opts = {
            -- NOTE: "padding" set using signcolumn in edgy.nvim configuration
            winfixwidth = false,
        },
        default_direction = "left",
        placement = "window",
        preserve_equality = false,
        resize_to_content = false,
    },

    keymaps = {
        ["i"] = "actions.jump",
        ["o"] = "actions.jump",
        ["<S-j>"] = "actions.down_and_scroll",
        ["<S-k>"] = "actions.up_and_scroll",
        ["<C-j>"] = false,
        ["<C-k>"] = false,
    },

    post_parse_symbol = function(bufnr, item, ctx)
        if ctx.backend_name == "treesitter" and ctx.lang == "rust" then
            return rust_post_parse_symbol(bufnr, item, ctx)
        end
        return true
    end,

    -- HACK: fix lua's weird choice for `Package` for control structures like if/else/for/etc.
    icons = {
        ["_"] = codicons.kinds,
        lua = { Package = " " },
    },

    -- LazyVim guides
    show_guides = false,
    guides = {
        mid_item = "├╴",
        last_item = "└╴",
        nested_top = "│ ",
        whitespace = "  ",
    },
})

vim.api.nvim_set_hl(0, "AerialLine", { link = "@text.title" })
vim.api.nvim_set_hl(0, "AerialLineNC", { link = "@text.title" })

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "gO", "<cmd>AerialOpen<cr>", { desc = "Open Outline" })

--+- Keymaps: Override Defaults -----------------------------+
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "codecompanion" },
    callback = function()
        -- Overwrite ftplugin/markdown.lua
        vim.keymap.set("n", "gO", "<cmd>AerialOpen<cr>", { desc = "Open Outline", buffer = 0 })
    end,
})
