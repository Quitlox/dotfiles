return {
    {
        "ecthelionvi/NeoComposer.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        cond = false,
        keys = {
            {
                "Q",
                function()
                    require("NeoComposer").play_macro()
                end,
                desc = "Plays queued macro",
            },
            {
                "cq",
                function()
                    require("NeoComposer").stop_macro()
                end,
                desc = "Halts macro playback",
            },
            {
                "<m-q>",
                function()
                    require("NeoComposer").toggle_macro_menu()
                end,
                desc = "Toggles popup macro menu",
            },
            {
                "]q",
                function()
                    require("NeoComposer").cycle_next()
                end,
                desc = "Cycles available macros forward",
            },
            {
                "[q",
                function()
                    require("NeoComposer").cycle_prev()
                end,
                desc = "Cycles available macros backward",
            },
            {
                "q",
                function()
                    require("NeoComposer").toggle_record()
                end,
                desc = "Starts recording, press again to end recording",
            },
            {
                "yq",
                function()
                    require("NeoComposer").yank_macro()
                end,
                desc = "Yank the currently selected macro into the default register",
            },
            {
                "<leader>fq",
                function()
                    require("telescope").load_extension("macros")
                    vim.cmd("Telescope macros")
                end,
                desc = "Find Macros",
            },
        },
        opts = {
            keymaps = {
                play_macro = "Q",
                yank_macro = "yq",
                stop_macro = "cq",
                toggle_record = "q",
                cycle_next = "]q",
                cycle_prev = "[q",
                toggle_macro_menu = "<m-q>",
            },
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":ToggleDelay",
                description = "Toggle the delay for macro playback",
            })
            table.insert(opts.commands, {
                ":EditMacros",
                description = "Edit your macros",
            })
            table.insert(opts.commands, {
                ":ClearNeoComposer",
                description = "Clear the NeoComposer queue",
            })
        end,
    },
}
