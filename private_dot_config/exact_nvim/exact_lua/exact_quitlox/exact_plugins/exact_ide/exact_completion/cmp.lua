-- Vim Options
vim.o.completeopt = "menu,menuone,noselect"

-- Behaviour
local select_next_completion_item = require("quitlox.plugins.completion.include.behaviour").select_next_completion_item
local select_prev_completion_item = require("quitlox.plugins.completion.include.behaviour").select_prev_completion_item
local scroll_completion_down = require("quitlox.plugins.completion.include.behaviour").scroll_completion_down
local scroll_completion_up = require("quitlox.plugins.completion.include.behaviour").scroll_completion_up

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
        local cmp = require("cmp")
        cmp.setup({
            preselect = require("cmp.types").cmp.PreselectMode.None,
            formatting = require("quitlox.plugins.completion.include.format"),
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
                        enable_in_context = function()
                            return require("cmp.config.context").in_treesitter_capture("spell")
                        end,
                    },
                },
            }),
        })

        -- Map documentation hover
        require("quitlox.plugins.completion.include.hover_doc")
        -- Configure the snippet engine
        require("quitlox.plugins.completion.include.luasnip")
        -- Configure completion sources for different context
        require("quitlox.plugins.completion.include.contexts")

        ----------------------------------------
        -- Parenthesis after Accept Function Completion
        ----------------------------------------
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
    dependencies = {
        -- Completion Sources
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "dmitmel/cmp-cmdline-history",
        "petertriho/cmp-git",
        "hrsh7th/cmp-omni",
        -- LSP Kind
        "onsails/lspkind.nvim",
        -- Tailwind Colorizer
        -- Add colorizer to completion menu for tailwind colors
        { "roobert/tailwindcss-colorizer-cmp.nvim", opts = { color_square_width = 2 }, config = true },
        -- Snippet Engine
        { "L3MON4D3/LuaSnip", version = "" },
        -- Completion Sorter
        "lukas-reineke/cmp-under-comparator",
    },
}
