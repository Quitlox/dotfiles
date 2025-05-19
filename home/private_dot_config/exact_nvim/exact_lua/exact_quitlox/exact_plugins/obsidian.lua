-- +---------------------------------------------------------+
-- | epwalsh/obsidian.nvim: Obsidian in Neovim               |
-- +---------------------------------------------------------+

--+- Config: Workspaces -------------------------------------+
local workspaces = {}

if vim.fn.has("win32") == 1 then
    workspaces = {
        {
            name = "Personal (Windows)",
            path = "C:/Users/witloxkhd/Obsidian/Knowledge/",
        },
    }
elseif vim.fn.has("wsl") == 1 then
    workspaces = {
        {
            name = "Personal (WSL)",
            path = "/mnt/c/Users/witloxkhd/Obsidian/Knowledge/",
        },
    }
else
    workspaces = {
        {
            name = "Personal (Linux)",
            path = "~/Obsidian/Knowledge",
        },
    }
end

--+- Setup --------------------------------------------------+
require("obsidian").setup({
    --+- Behaviour --------------------+
    workspaces = workspaces,
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
        -- Smart action depending on context: follow link, show notes with tag, toggle checkbox, or toggle heading fold
        ["<cr>"] = {
            action = function()
                return require("obsidian").util.smart_action()
            end,
            opts = { buffer = true, expr = true },
        },
    },

    --+- Obsidian ---------------------+
    daily_notes = {
        folder = "./Daily Notes/",
        template = "./Resources/Templates/Daily Note Template.md",
    },
    new_notes_location = "notes_subdir",
    notes_subdir = "./Zettelkasten/",
    attachments = {
        img_folder = "./Resources/Attachments/",
    },

    templates = {
        folder = "./Resources/Templates/",
        substitutions = {
            ["<% tp.file.creation_date() %>"] = function()
                -- Return the date and time in the format YYYY-MM-DD HH:MM
                return os.date("%Y-%m-%d %H:%M", os.time())
            end,
        },
    },

    --+- User Inferface ---------------+
    completion = {
        blink = true,
    },
    picker = {
        name = "snacks.pick",
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
})

--+- Keymaps ------------------------------------------------+
require("which-key").add({ { "<localleader>o", group = "Obsidian" } })
vim.keymap.set("n", "<localleader>oo", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Quick Switcher" })
vim.keymap.set("n", "<localleader>os", "<cmd>ObsidianSearch<cr>", { desc = "Open Note" })
vim.keymap.set("n", "<localleader>on", "<cmd>ObsidianNew<cr>", { desc = "New Note" })
vim.keymap.set("n", "<localleader>ox", "<cmd>ObsidianOpen<cr>", { desc = "Open in Obsidian" })
vim.keymap.set("n", "<localleader>ot", "<cmd>ObsidianNewFromTemplate<cr>", { desc = "Open in Obsidian" })
