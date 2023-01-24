----------------------------------------------------------------------
--                   Rust Language Configuration                    --
----------------------------------------------------------------------

----------------------------------------
-- LSP Config
----------------------------------------
-- The rust language server is configured by the rust-tools plugin,
-- instead of manually via lspconfig

-- Require rust-tools
local rust_tools_ok, rt = pcall(require, "rust-tools")
if not rust_tools_ok then return end

rt.setup({
    server = {
        opts = {
            tools = {
                hover_actions = { auto_focus = true },
            },
        },
        on_attach = function(client, bufnr)
            local on_attach = require("quitlox.plugins.lsp.include.common").on_attach
            on_attach(client, bufnr)

            -- Overwrite Join Keys keybinding
            vim.keymap.set("n", "J", rt.join_lines.join_lines, { noremap = true, buffer = bufnr })

            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { noremap = true, buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "ga", rt.code_action_group.code_action_group, { noremap = true, buffer = bufnr })
        end,
    },
})

----------------------------------------
-- Crates.nvim
----------------------------------------
-- Autocompletion for crates in Cargo.toml

-- Require crates.nvim
local crates_ok, crates = pcall(require, "crates")
if not crates_ok then return end
-- Require which-key
local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then return end
-- Require cmp
local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then return end

-- Add code actions via null-ls
crates.setup({
    null_ls = {
        enabled = true,
        name = "crates.nvim",
    },
})

-- Inject crates as completion source
vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
    pattern = "Cargo.toml",
    callback = function() cmp.setup.buffer({ sources = { { name = "crates" } } }) end,
})

-- Set mappings
wk.register({
    ["<localleader>"] = {
        c = {
            name = "Crates",
            t = { crates.toggle, "Crates Toggle" },
            r = { crates.reload, "Crates Reload" },
            --
            v = { crates.show_versions_popup, "Crate Version" },
            f = { crates.show_features_popup, "Crate show Features" },
            d = { crates.show_dependencies_popup, "Crate show Dependencies" },
            --
            u = { crates.update_crate, "Crate Update" },
            U = { crates.update_all_creates, "Crate Upgrade" },
            a = { crates.update_all_crates, "Crate update All" },
            A = { crates.update_all_creates, "Crate Upgrade all" },
            --
            H = { crates.open_homepage, "Crate open Homepage" },
            R = { crates.open_repository, "Crate open Repository" },
            D = { crates.open_documentation, "Crate open Documentation" },
            C = { crates.open_crates_io, "Crate open CratesIO" },
        },
    },
})
