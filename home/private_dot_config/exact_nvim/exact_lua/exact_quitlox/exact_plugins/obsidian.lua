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
        folder = "07 Inbox/",
        template = "06 Templates/Daily Note.md",
    },
    new_notes_location = "notes_subdir",
    notes_subdir = "05 Zettelkasten/",
    attachments = {
        img_folder = "_System/Attachments/",
    },
    -- Override the default note ID generation to preserve user-provided filenames
    note_id_func = function(title)
        if title ~= nil then
            -- Just use the title as is for the filename
            return title
        else
            -- If no title, generate a random ID
            local suffix = ""
            for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90))
            end
            return tostring(os.time()) .. "-" .. suffix
        end
    end,

    -- Add creation date to frontmatter
    note_frontmatter_func = function(note)
        -- Add the title of the note as an alias
        if note.title then
            note:add_alias(note.title)
        end

        local out = {
            id = note.id,
            aliases = note.aliases,
            tags = note.tags,
            -- Add creation date with the format YYYY-MM-DD HH:MM
            ["creation date"] = os.date("%Y-%m-%d %H:%M"),
        }

        -- Keep any manually added fields in the frontmatter
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
                out[k] = v
            end
        end

        return out
    end,

    templates = {
        folder = "06 Templates",
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
vim.keymap.set("n", "<localleader>ot", "<cmd>ObsidianNewFromTemplate<cr>", { desc = "New from Template" })
vim.keymap.set("n", "<localleader>oz", function()
    vim.ui.input({ prompt = "Zettel name: " }, function(name)
        if name then
            -- Create a new zettel with the given name using the Zettel template
            vim.cmd(string.format("ObsidianNew 05\\ Zettelkasten/%s", name))
            -- vim.cmd("ObsidianTemplate Zettel.md")
        end
    end)
end, { desc = "New Zettel" })
