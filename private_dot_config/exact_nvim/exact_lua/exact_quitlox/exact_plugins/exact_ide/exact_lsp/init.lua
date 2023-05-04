return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/neodev.nvim",
            "folke/neoconf.nvim",
        },
    },
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
        version = "",
        config = false,
    },
    ----- Ansible -----
    { "mfussenegger/nvim-ansible" },
    ----- YAML -----
    -- see languages/yaml.lua
    { "someone-stole-my-name/yaml-companion.nvim", lazy = true, version = "" },
    ----- Json -----
    -- Autocompletion based on remote SchemaStore
    -- see languages/json.lua
    { "b0o/SchemaStore.nvim", lazy = true },
    ----- Rust -----
    -- See languages/rust.lua
    { "simrat39/rust-tools.nvim", lazy = true },
    -- Autocompletion in project.toml
    { "Saecki/crates.nvim", lazy = true, version = "" },
    ----- Typescript -----
    { "jose-elias-alvarez/typescript.nvim", lazy = false },
    {
        "dmmulroy/tsc.nvim",
        lazy = false,
        config = true,
        init = function()
            require("legendary").command({
                ":TSC",
                description = "Perform type checking on the current project",
            })
        end,
    },

    ----------------------------------------
    -- Language Support: standalone vim plugins
    ----------------------------------------

    ----- Tex -----
    { "lervag/vimtex", version = "" },
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
