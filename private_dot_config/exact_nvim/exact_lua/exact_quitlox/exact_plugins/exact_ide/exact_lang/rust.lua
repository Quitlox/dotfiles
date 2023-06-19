return {
    { "simrat39/rust-tools.nvim", lazy = true },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                -- NOTE: Thanks to rust_analyzer, lazy loading DAP and all related plugins
                -- is not possible
                ["rust_analyzer"] = function()
                    local rt = require("rust-tools")
                    rt.setup({
                        server = {
                            capabilities = require("quitlox.util").make_capabilities(),
                            on_attach = function(client, bufnr)
                                -- Overwrite Join Keys keybinding
                                -- vim.keymap.set("n", "J", rt.join_lines.join_lines, { noremap = true, buffer = bufnr })

                                -- Hover actions
                                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions,
                                    { noremap = true, buffer = bufnr })
                                -- Code action groups
                                vim.keymap.set("n", "ga", rt.code_action_group.code_action_group,
                                    { noremap = true, buffer = bufnr })
                            end,
                        },
                    })
                end,
            },
        },
    },

    ----------------------------------------
    -- Crates.nvim
    ----------------------------------------
    -- Autocompletion for crates in Cargo.toml
    "Saecki/crates.nvim",
    lazy = true,
    version = "",
    opts = {
        null_ls = {
            enabled = true,
            name = "crates.nvim",
        },
    },
    init = function()
        -- Inject crates as completion source
        vim.api.nvim_create_autocmd("BufRead", {
            group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
            pattern = "Cargo.toml",
            callback = function()
                require("cmp").setup.buffer({ sources = { { name = "crates" } } })

                local crates = require("crates")
                require("which-key").register({
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
            end,
        })
    end,
}
