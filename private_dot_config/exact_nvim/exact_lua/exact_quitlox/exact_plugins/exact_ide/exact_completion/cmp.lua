-- Vim Options
vim.o.completeopt = "menu,menuone,noselect"

-- Behaviour
local select_next_completion_item = require("quitlox.plugins.ide.completion.include.behaviour").select_next_completion_item
local select_prev_completion_item = require("quitlox.plugins.ide.completion.include.behaviour").select_prev_completion_item
local scroll_completion_down = require("quitlox.plugins.ide.completion.include.behaviour").scroll_completion_down
local scroll_completion_up = require("quitlox.plugins.ide.completion.include.behaviour").scroll_completion_up

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function(_, opts)
        local cmp = require("cmp")
        cmp.setup({
            enabled = opts.enabled,
            preselect = require("cmp.types").cmp.PreselectMode.None,
            formatting = require("quitlox.plugins.ide.completion.include.format"),
            snippet = {
                -- Set the Snippet Engine
                expand = function(args) require("luasnip").lsp_expand(args.body) end,
            },
            -- Enable border around completion
            window = {
                completion = {
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                    col_offset = -3,
                    side_padding = 0,
                },
            },
            mapping = cmp.mapping.preset.insert({
                ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Only confirm explicitly selected items.
                ["<Tab>"] = cmp.mapping(select_next_completion_item, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(select_prev_completion_item, { "i", "s" }),
                ["<C-j>"] = cmp.mapping(select_next_completion_item, { "i", "s", "c" }),
                ["<C-k>"] = cmp.mapping(select_prev_completion_item, { "i", "s", "c" }),
                ["<C-b>"] = cmp.mapping(scroll_completion_up, { "i", "s", "c" }),
                ["<C-f>"] = cmp.mapping(scroll_completion_down, { "i", "s", "c" }),
                ["<C-u>"] = cmp.mapping(scroll_completion_up, { "i", "s", "c" }),
                ["<C-d>"] = cmp.mapping(scroll_completion_down, { "i", "s", "c" }),
                ["<C-n>"] = cmp.mapping(function() require("luasnip").jump(1) end, { "i", "s", "c" }),
                ["<C-p>"] = cmp.mapping(function() require("luasnip").jump(-1) end, { "i", "s", "c" }),
                ["<C-space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip", option = { show_autosnippets = true } },
            }, {
                -- This introduces a new group, meaning that only if the group above has
                -- no completion items, this group is used.
                { name = "path" },
                { name = "buffer" },
                {
                    name = "spell",
                    option = {
                        keep_all_entries = false,
                        enable_in_context = function() return require("cmp.config.context").in_treesitter_capture("spell") end,
                    },
                },
                { name = "rg" },
            }),
        })

        -- Configure the snippet engine
        require("quitlox.plugins.ide.completion.include.luasnip")
        -- Configure completion sources for different context
        require("quitlox.plugins.ide.completion.include.contexts")
    end,
    dependencies = {
        -- Completion Sources
        "hrsh7th/cmp-nvim-lsp",
        -- "hrsh7th/cmp-nvim-lsp-document-symbol",
        -- "hrsh7th/cmp-nvim-lsp-signature-help",

        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "dmitmel/cmp-cmdline-history",
        "petertriho/cmp-git",
        "hrsh7th/cmp-omni",
        "lukas-reineke/cmp-rg",
        -- LSP Kind
        "onsails/lspkind.nvim",
        -- Snippet Engine
        { "L3MON4D3/LuaSnip", version = "", dependencies = { "rafamadriz/friendly-snippets" } },
        "saadparwaiz1/cmp_luasnip",
        -- Completion Sorter
        "lukas-reineke/cmp-under-comparator",
        -- Tailwind
        {
            "luckasRanarison/tailwind-tools.nvim",
            opts = {},
            keys = {
                { "[c", "<cmd>TailwindPrevClass<cr>", desc = "Moves the cursor to the nearest previous Tailwind class", noremap = true, silent = true },
                { "]c", "<cmd>TailwindNextClass<cr>", desc = "Moves the cursor to the nearest next Tailwind class", noremap = true, silent = true },
            },
        },
        require("quitlox.util").legendary({
            { ":TailwindConcealEnable", "Enables conceal for all buffers." },
            { ":TailwindConcealDisable", "Disables conceal." },
            { ":TailwindConcealToggle", "Toggles conceal." },
            { ":TailwindColorEnable", "Enables color hints for all buffers." },
            { ":TailwindColorDisable", "Disables color hints." },
            { ":TailwindColorToggle", "Toggles color hints." },
            { ":TailwindSort", "Sorts all classes in the current buffer." },
            { ":TailwindSortSelection", "Sorts selected classes in visual mode." },
        }),
    },
}
