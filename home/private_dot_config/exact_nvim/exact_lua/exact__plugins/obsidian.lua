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

require("obsidian").setup({
    --+- Behaviour --------------------+
    workspaces = workspaces,
    legacy_commands = false,

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

--+- Keymaps: ObsidianNoteEnter ------------------------------+
vim.api.nvim_create_autocmd("User", {
    pattern = "ObsidianNoteEnter",
    callback = function(ev)
        -- Toggle checkbox
        vim.keymap.set("n", "X", function()
            return require("obsidian").util.toggle_checkbox()
        end, { buffer = ev.buf, desc = "Toggle checkbox" })

        -- Follow link (passthrough to default gf behavior when not on a link)
        vim.keymap.set("n", "gd", function()
            return require("obsidian").util.gf_passthrough()
        end, { noremap = false, expr = true, buffer = ev.buf, desc = "Follow link" })

        -- Smart action depending on context
        vim.keymap.set("n", "<cr>", function()
            return require("obsidian").util.smart_action()
        end, { buffer = ev.buf, expr = true, desc = "Smart action" })
    end,
})

--+- Keymaps -------------------------------------------------+
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    group = vim.api.nvim_create_augroup("MyPythonKeybindings", { clear = true }),
    callback = function(event)
        require("which-key").add({ { "<localleader>", group = "Obsidian", buffer = event.buf } })

        vim.keymap.set("n", "<localleader>o", "<cmd>Obsidian quick_switch<cr>", { desc = "Quick Switcher", buffer = event.buf })
        vim.keymap.set("n", "<localleader>s", "<cmd>Obsidian search<cr>", { desc = "Search Notes", buffer = event.buf })
        vim.keymap.set("n", "<localleader>n", "<cmd>Obsidian new<cr>", { desc = "New Note", buffer = event.buf })
        vim.keymap.set("n", "<localleader>x", "<cmd>Obsidian open<cr>", { desc = "Open in Obsidian", buffer = event.buf })
        vim.keymap.set("n", "<localleader>t", "<cmd>Obsidian new_from_template<cr>", { desc = "New from Template", buffer = event.buf })

        vim.keymap.set("n", "<localleader>z", function()
            vim.ui.input({ prompt = "Zettel name: " }, function(name)
                if name then
                    -- Create a new zettel with the given name using the Zettel template
                    vim.cmd(string.format("Obsidian new 05\\ Zettelkasten/%s", name))
                    -- vim.cmd("ObsidianTemplate Zettel.md")
                end
            end)
        end, { desc = "New Zettel", buffer = event.buf })
    end,
})
