-- Example for configuring Neovim to load user-installed installed Lua rocks:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

return {
    -- +---------------------------------------------------------+
    -- | REPL: Clojure                                           |
    -- +---------------------------------------------------------+
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<localleader>r"] = { name = "REPL" },
                ["<localleader>rl"] = { name = "Log" },
                ["<localleader>re"] = { name = "Eval" },
                ["<localleader>rec"] = { name = "Eval and Comment" },
                ["<localleader>rg"] = { name = "Go" },
                ["<localleader>rc"] = { name = "Client" },
            },
        },
    },
    {
        "Olical/conjure",
        version = "",
        lazy = true,
        cmd = {
            "ConjureEval",
            "ConjureSchool",
            "ConjureConnect",
            "ConjureClientState",
            --
            "ConjureLogSplit",
            "ConjureLogVSplit",
            "ConjureLogTab",
            "ConjureLogBuf",
            "ConjureLogToggle",
            "ConjureLogResetSoft",
            "ConjureLogResetHard",
            "ConjureLogJumpToLatest",
            "ConjureLogCloseVisible",
            --
            "ConjureEvalCurrentForm",
            "ConjureEvalCommentCurrentForm",
            "ConjureEvalRootForm",
            "ConjureEvalCommentRootForm",
            "ConjureEvalWord",
            "ConjureEvalCommentWord",
            "ConjureEvalReplaceForm",
            "ConjureEvalMarkedForm",
            "ConjureEvalCommentForm",
            "ConjureEvalFile",
            "ConjureEvalBuf",
            "ConjureEvalMotion",
            "ConjureEvalVisual",
        },
        keys = {
            { "<localleader>rlv", desc = "Log Split" },
            { "<localleader>rlb", desc = "Log Vertical split" },
            { "<localleader>rlt", desc = "Log Tab" },
            { "<localleader>rlb", desc = "Log Buffer" },
            { "<localleader>rlg", desc = "Log toggle" },
            { "<localleader>rlr", desc = "Log Reset soft" },
            { "<localleader>rlR", desc = "Log Reset hard" },
            { "<localleader>rll", desc = "Log jumpConjure Latest" },
            { "<localleader>rlq", desc = "Log close visible" },
            { "<localleader>ree", desc = "Eval" },
            { "<localleader>rece", desc = "Eval and Comment" },
            { "<localleader>rer", desc = "Eval Root" },
            { "<localleader>recr", desc = "Eval Root and Comment" },
            { "<localleader>rew", desc = "Eval Word" },
            { "<localleader>recw", desc = "Eval Word and Comment" },
            { "<localleader>re!", desc = "Eval and replace" },
            { "<localleader>rem", desc = "Eval Mark" },
            { "<localleader>rec", desc = "Eval Form and Comment" },
            { "<localleader>ref", desc = "Eval File from disk" },
            { "<localleader>reb", desc = "Eval buffer" },
            { "<localleader>rE", desc = "Eval Motion", mode = { "n" } },
            { "<localleader>rE", desc = "Eval Motion", mode = { "v" } },
            --
            { "<localleader>rgd", desc = "Go Definition" },
            { "<localleader>rK", desc = "Look up doc" },
            --
            { "<localleader>rcs", desc = "Client Start" },
            { "<localleader>rcS", desc = "Client Stop" },
            { "<localleader>rei", desc = "Eval Interrupt" },
        },
        dependencies = {
            {
                "PaterJason/cmp-conjure",
                config = function()
                    local cmp = require("cmp")
                    local config = cmp.get_config()
                    table.insert(config.sources, {
                        name = "buffer",
                        option = {
                            sources = {
                                { name = "conjure" },
                            },
                        },
                    })
                    cmp.setup(config)
                end,
            },
        },
        config = function(_, opts)
            require("conjure.main").main()
            require("conjure.mapping")["on-filetype"]()
        end,
        init = function()
            vim.g["conjure#mapping#prefix"] = "<localleader>r"
            vim.g["conjure#mapping#log_split"] = "lv"
            vim.g["conjure#mapping#log_vsplit"] = "lb"
            vim.g["conjure#mapping#doc_word"] = "<localleader>rK"

            vim.g["conjure#client_on_load"] = false
        end,
    },

    -- +---------------------------------------------------------+
    -- | REPL: Iron                                              |
    -- +---------------------------------------------------------+
    {
        "Vigemus/iron.nvim",
        keys = {
            { "<leader>rc", desc = "Send motion" },
            { "<leader>rc", desc = "Send motion", mode = { "v" } },
            { "<leader>rf", desc = "Send file" },
            { "<leader>rl", desc = "Send line" },
            { "<leader>ru", desc = "Send until cursor" },
            { "<leader>rm", desc = "Send mark", mode = { "n", "v" } },
            { "<leader>rmc", desc = "Mark motion" },
            { "<leader>rmc", desc = "Mark motion", mode = { "v" } },
            { "<leader>rmd", desc = "Remove mark" },
            { "<leader>rq", desc = "Exit" },
            { "<leader>rx", desc = "Interrupt" },
            { "<leader>rl", desc = "Clear" },
            { "<leader>r<cr>", desc = "Carriage return" },
        },
        config = function()
            require("iron.core").setup({
                config = {
                    -- Whether a repl should be discarded or not
                    scratch_repl = true,
                    -- Your repl definitions come here
                    repl_definition = {
                        sh = {
                            -- Can be a table or a function that
                            -- returns a table (see below)
                            command = { "zsh" },
                        },
                    },
                    -- How the repl window will be displayed
                    -- See below for more information
                    repl_open_cmd = require("iron.view").split("40%"),
                },
                -- Iron doesn't set keymaps by default anymore.
                -- You can set them here or manually add keymaps to the functions in iron.core
                keymaps = {
                    send_motion = "<space>rc",
                    visual_send = "<space>rc",
                    send_file = "<space>rf",
                    send_line = "<space>rl",
                    send_until_cursor = "<space>ru",
                    send_mark = "<space>rm",
                    mark_motion = "<space>rmc",
                    mark_visual = "<space>rmc",
                    remove_mark = "<space>rmd",
                    cr = "<space>r<cr>",
                    interrupt = "<space>rx",
                    exit = "<space>rq",
                    clear = "<space>rl",
                },
                -- If the highlight is on, you can change how it looks
                -- For the available options, check nvim_set_hl
                highlight = {
                    italic = true,
                },
                ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
            })
        end,
    },

    -- +---------------------------------------------------------+
    -- | Jupyter Notebook: molten.nvim                           |
    -- +---------------------------------------------------------+
    {
        "benlubas/molten-nvim",
        version = "*",
        lazy = false,
        -- Required python packages: pynvim jupyter_client
        -- Optional python packages: cairosvg, pnglatex, plotly, pyperclip, nbformat
        dependencies = { "3rd/image.nvim" },
        build = ":UpdateRemotePlugins",
        init = function()
            -- these are examples, not defaults. Please see the readme
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
        end,
        config = false,
        keys = {
            { "<localleader>ji", "<cmd>MoltenInit<cr>", desc = "Initialize molten.nvim for Jupyter" },
            { "<localleader>je", "<cmd>MoltenEvaluateOperator<cr>", desc = "Evaluate operator" },
            { "<localleader>jrl", "<cmd>MoltenEvaluateLine<cr>", desc = "Evaluate line" },
            { "<localleader>jrr", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate cell" },
            { "<localleader>jr", "<cmd>MoltenEvaluateVisual<cr>", desc = "Evaluate visual selection", { mode = "v" } },
            { "<localleader>jd", "<cmd>MoltenDelete<cr>", desc = "Delete cell" },
            { "<localleader>jh", "<cmd>MoltenHideOutput<cr>", desc = "Hide output" },
            { "<localleader>js", "<cmd>noautocmd MoltenEnterOutput<cr>", desc = "Show/enter output" },
        },
    },
    {
        "3rd/image.nvim",
        version = "",
        opts = {
            backend = "kitty",
            integrations = {},
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true,
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = require("quitlox.util").legendary({
            { ":MoltenInfo", "Show information about the state of the plugin, initialization status, available kernels, and running kernels" },
            {
                ":MoltenInit",
                "Initialize a kernel for the current buffer. If shared is passed as the first value, this buffer will use an already running kernel. If no kernel is given, prompts the user.",
            },
            { ":MoltenDeinit", "De-initialize the current buffer's runtime and molten instance. (called automatically on vim close/buffer unload)" },
            { ":MoltenGoto", "Go to the nth code cell n defaults to 1 (1 indexed)" },
            { ":MoltenNext", "Go to the next code cell, or jump n code cells n defaults to 1. Values wrap. Negative values move backwards" },
            { ":MoltenPrev", "like Next but backwards" },
            { ":MoltenEvaluateLine", "Evaluate the current line" },
            { ":MoltenEvaluateVisual", "Evaluate the visual selection (cannot be called with a range!)" },
            { ":MoltenEvaluateOperator", "Evaluate text selected by the following operator. see Keybindings for useage" },
            { ":MoltenEvaluateArgument", "Evaluate given code in the given kernel" },
            { ":MoltenReevaluateCell", "Re-evaluate the active cell (including new code) with the same kernel that it was originally evaluated with" },
            { ":MoltenDelete", "Delete the active cell (does nothing if there is no active cell)" },
            { ":MoltenShowOutput", "Shows the output window for the active cell" },
            { ":MoltenHideOutput", "Hide currently open output window" },
            {
                ":MoltenEnterOutput",
                "Move into the active cell's output window. Opens but does not enter the output if it's not open. must be called with noautocmd (see Keybindings for example)",
            },
            { ":MoltenInterrupt", "Sends a keyboard interrupt to the kernel which stops any currently running code. (does nothing if there's no current output)" },
            {
                ":MoltenOpenInBrowser",
                "Open the current output in the browser. Currently this only supports cells with 'text/html' outputs, configured with molten_auto_open_html_in_browser and molten_open_cmd",
            },
            { ":MoltenRestart", "Shuts down a restarts the kernel. Deletes all outputs if used with a bang" },
            {
                ":MoltenSave",
                "Save the current cells and evaluated outputs into a JSON file. When path is specified, save the file to path, otherwise save to g:molten_save_path. currently only saves one kernel per file",
            },
            {
                ":MoltenLoad",
                "Loads cell locations and output from a JSON file generated by MoltenSave. path functions the same as MoltenSave. If shared is specified, the buffer shares an already running kernel.",
            },
            { ":MoltenExportOutput", "Export outputs from the current buffer and kernel to a jupyter notebook (.ipynb) at the given path. read more" },
            { ":MoltenImportOutput", "Import outputs from a jupyter notebook (.ipynb). read more" },
        }),
    },
}
