return {
    { "neovim/nvim-lspconfig" },
    require("quitlox.plugins.ide.lsp.mason"),
    require("quitlox.plugins.ide.lsp.ui"),

    { "jubnzv/virtual-types.nvim" },

    ----------------------------------------
    -- Language Support: LSP-based Plugins
    ----------------------------------------
    -- Lazy load language plugins when the corresponding is called

    ----- LuaDev -----
    -- see languages/lua.lua
    { "folke/neodev.nvim", lazy = true },
    ----- YAML -----
    -- see languages/yaml.lua
    { "someone-stole-my-name/yaml-companion.nvim", lazy = true },
    ----- Json -----
    -- Autocompletion based on remote SchemaStore
    -- see languages/json.lua
    { "b0o/SchemaStore.nvim", lazy = true },
    ----- Rust -----
    -- See languages/rust.lua
    { "simrat39/rust-tools.nvim", lazy = true },
    -- Autocompletion in project.toml
    { "Saecki/crates.nvim", lazy = true },
    ----- Typescript -----
    { "jose-elias-alvarez/typescript.nvim", lazy = true },

    ----------------------------------------
    -- Language Support: standalone vim plugins
    ----------------------------------------

    ----- Tex -----
    "lervag/vimtex",
    ----- Yuck -----
    -- the filetype used by ewww
    "elkowar/yuck.vim",
    ----- Javascript -----
    {
        "barrett-ruth/import-cost.nvim",
        build = "sh install.sh yarn",
        ft = "js,ts,tsx,jsx",
        config = true,
    },
    ----- Python -----
    -- Switch Environment
    {
        "AckslD/swenv.nvim",
        ft = "python",
        config = true,
        init = function()
            require("which-key").register({
                p = {
                    name = "Python",
                    s = { "<cmd>lua require('swenv.api').pick_env()<cr>", "Python Switch env" },
                },
            }, { prefix = "<leader>" })
        end,
    },
}
