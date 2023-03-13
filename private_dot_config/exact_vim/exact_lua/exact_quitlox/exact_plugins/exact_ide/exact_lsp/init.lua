return {
    { "neovim/nvim-lspconfig", dependencies = { "folke/neodev.nvim", "folke/neoconf.nvim" } },
    { import = "quitlox.plugins.ide.lsp" },

    ----------------------------------------
    -- Language Support: LSP-based Plugins
    ----------------------------------------
    -- Lazy load language plugins when the corresponding is called

    ----- LuaDev -----
    -- see languages/lua.lua
    -- before: lspconfig
    {
        "folke/neodev.nvim",
        priority = 500,
        config = function()
            require("neodev").setup({
                library = { plugins = { "nvim-dap-ui" }, types = true },
            })
        end,
    },
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
    { "jose-elias-alvarez/typescript.nvim", lazy = false },

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
}
