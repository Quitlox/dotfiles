-- +---------------------------------------------------------+
-- | epwalsh/obsidian.nvim: Obsidian in Neovim               |
-- +---------------------------------------------------------+

require("obsidian").setup({
    workspaces = {
        {
            name = "Personal (Linux)",
            path = "~/obsidian/Knowledge",
        },
    },
    daily_notes = {
        folder = "./Daily Notes/",
        template = "./Resources/Templates/Daily Note Template.md",
    },
    mappings = {
        ["X"] = {
            action = function()
                return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true },
        },
        ["gd"] = {
            action = function()
                return require("obsidian").util.gf_passthrough()
            end,
            opts = { noremap = false, expr = true, buffer = true },
        },
    },
    new_notes_location = "notes_subdir",
    notes_subdir = "./Zettelkasten/",

    picker = {
        name = "telescope.nvim",
        note_mappings = {
            new = "<C-x>",
            insert_link = "<C-l>",
        },
        tag_mappings = {
            tag_note = "<C-x>",
            insert_tag = "<C-l>",
        },
    },

    ui = {
        enable = false, -- We use markview.nvim / markdown-render.nvim
    },

    attachments = {
        img_folder = "./Resources/Attachments/",
    },

    templates = {
        folder = "./Resources/Templates/",
    },
})

require("which-key").add({
    { "<leader><leader>o", group = "Obsidian" },
})
vim.keymap.set("n", "<leader><leader>oo", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick Switcher" })
vim.keymap.set("n", "<leader><leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Open Note" })
vim.keymap.set("n", "<leader><leader>on", "<cmd>ObsidianNew<cr>", { desc = "New Note" })
vim.keymap.set("n", "<leader><leader>ox", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian" })
