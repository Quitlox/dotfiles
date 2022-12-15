import("which-key", function(wk)
    -- local presets = require('which-key.plugins.presets')
    -- presets.text_objects['<M-i>'] = nil
    -- presets.objects['<M-i>'] = nil
    -- resets.objects['<a-i>'] = nil


    wk.setup({
        operators = { gc = "Comments" },
        plugins = {
            presets = {
                operators = true,
                motions = true,
                text_objects = true,
                windows = false,
                nav = false,
                z = true,
                g = false,
            },
            spelling = {
                enabled = true,
            }
        },
        key_labels = {
            ["<space>"] = "SPC",
            ["<CR>"] = "RET",
            ["<cr>"] = "RET",
            ["<tab>"] = "TAB",
        },
        ignore_missing = true,
        icons = { group = "", separator = "ﰲ" },
        layout = {
            align = "center",
        },
        window = {
            border = "single",
            winblend = 0,
        },
    })

    ----------------------------------------
    -- KEYBINDINGS
    ----------------------------------------

    wk.register({
        ["<leader>"] = {
            s = { ":wa<cr>", "save" },
        },
        -- g = {
        --
        --     ["0"] = "which_key_ignore",
        --     j = "which_key_ignore",
        --     k = "which_key_ignore",
        --     ["`"] = "which_key_ignore",
        --     ["%"] = "which_key_ignore",
        --     ["$"] = "which_key_ignore",
        -- },
    })

    ----------------------------------------
    -- KEYBINDINGS: WINDOW
    ----------------------------------------
    wk.register({
        ["<leader>"] = {
            w = {
                name = "Window",
                j = { "<C-W>j", "which_key_ignore" },
                k = { "<C-W>k", "which_key_ignore" },
                h = { "<C-W>h", "which_key_ignore" },
                l = { "<C-W>l", "which_key_ignore" },
                o = { "<C-W>o", "Window Only" },
                v = { "<C-W>s", "Window vSplit" },
                b = { "<C-W>v", "Window Split" },
                d = { "<C-W>q", "Window Delete" },
                w = { ":new<CR>", "New Window" },
                r = {
                    name = "Resize",
                    k = { ":resize +2<CR>", "Window Resize Up" },
                    j = { ":resize -2<CR>", "Window Resize Down" },
                    h = { ":vertical resize -2<CR>", "Window Resize Left" },
                    l = { ":vertical resize +2<CR>", "Window Resize Right" },
                },
            },
        },
        ["<C-Down>"] = { ":resize +2<CR>", "which_key_ignore" },
        ["<C-Up>"] = { ":resize -2<CR>", "which_key_ignore" },
        ["<C-Right>"] = { ":vertical resize +2<CR>", "which_key_ignore" },
        ["<C-Left>"] = { ":vertical resize -2<CR>", "which_key_ignore" },
    })

    ----------------------------------------
    -- KEYBINDINGS: TAB
    ----------------------------------------
    wk.register({
        ["<leader>"] = {
            t = {
                name = "Tab",
                t = { ":tabnew<cr>", "Tab new" },
                o = { ":tabonly<cr>", "Tab Only" },
                d = { ":tabclose<cr>", "Tab Delete" },
                n = { ":tabnext<cr>", "Tab Next" },
                p = { ":tabprevious<cr>", "Tab Prev" },
                m = {
                    name = "Move",
                    h = { ":-tabmove<cr>", "Tab Move left" },
                    l = { ":+tabmove<cr>", "Tab Move right" },
                },
            },
        },
    })

    ----------------------------------------
    -- KEYBINDINGS: PLUGINS MISCELLANEOUS
    ----------------------------------------

    wk.register({
        ["<leader>"] = {
            i = { "<cmd>IconPickerNormal alt_font symbols nerd_font emoji<cr>", "Icon Picker" },
        },
    }, { noremap = true, silent = true })

    ----------------------------------------
    -- KEYBINDINGS: MISCELLANEOUS
    ----------------------------------------
    wk.register({
        ["<leader>"] = {
            v = {
                name = "Vim",
                s = { ":source ~/.config/vim/vimrc<cr>", "[v]im [s]ource vimrc" },
                l = {
                    name = "list",
                    f = { "<cmd>Telescope filetypes theme=dropdown<cr>", "Vim List Filetypes" },
                    r = { "<cmd>Telescope registers theme=dropdown<cr>", "Vim List Registers" },
                    o = { "<cmd>Telescope vim_options theme=dropdown<cr>", "Vim List Options" },
                    a = { "<cmd>Telescope autocommands theme=dropdown<cr>", "Vim List Autocommands" },
                    h = { "<cmd>Telescope highlights theme=dropdown<cr>", "Vim List Highlights" },
                },
            },
        },
    })

    ----------------------------------------
    -- PLUGIN: VIMTEX (LATEX)
    ----------------------------------------
    wk.register({
        ["<localleader>"] = {
            l = {
                name = "[L]aTeX",
                a = "context menu",
                C = "[c]lean full",
                c = "[c]lean",
                e = "[e]rrors",
                g = "status",
                G = "status all",
                I = "[i]nfo full",
                i = "[i]nfo",
                K = "stop all",
                k = "stop",
                l = "compile",
                L = "compile selected",
                m = "i[m]aps list",
                o = "compile [o]utput",
                q = "log",
                s = "toggle main",
                t = "[t]oc open",
                T = "[t]oc toggle",
                v = "[v]iew",
                X = "reload state",
                x = "reload",
            },
        },
    })

    wk.register({
        ["<leader>"] = { d = { "<cmd>DogeGenerate<cr>", "Generate Documentation" } },
    })
end)
