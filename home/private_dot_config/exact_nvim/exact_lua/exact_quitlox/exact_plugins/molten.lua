-- +---------------------------------------------------------+
-- | benlubas/molten-nvim: REPL                              |
-- +---------------------------------------------------------+

--+- Options ------------------------------------------------+
if vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.g.neovide ~= nil then vim.notify("molten-nvim is not supported on Windows", vim.log.levels.WARN, { title = "Molten.nvim" }) end

-- Example for configuring Neovim to load user-installed installed Lua rocks:
-- package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
-- package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20

--+- Check Requirements -------------------------------------+
-- Check if pynvim pip package is installed
-- check exit code
vim.schedule(function()
    vim.fn.system("python3 -m pip show pynvim")
    if vim.v.shell_error == 1 then
        vim.schedule(
            function()
                vim.notify("`pynvim` is not installed. Please install it by running `pip install pynvim` or globally using your package manager.", vim.log.levels.ERROR, { title = "Molten.nvim" })
            end
        )
        return
    else
        vim.schedule(function() vim.cmd("UpdateRemotePlugins") end)
    end
end)

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<leader><leader>ji", "<cmd>MoltenInit<cr>", { desc = "Initialize Jupyter" })
vim.keymap.set("n", "<leader><leader>je", "<cmd>MoltenEvaluateOperator<cr>", { desc = "Evaluate operator" })
vim.keymap.set("n", "<leader><leader>jrl", "<cmd>MoltenEvaluateLine<cr>", { desc = "Evaluate line" })
vim.keymap.set("n", "<leader><leader>jrr", "<cmd>MoltenReevaluateCell<cr>", { desc = "Re-evaluate cell" })
vim.keymap.set("n", "<leader><leader>jr", ":<C-u>MoltenEvaluateVisual<cr>", { desc = "Evaluate visual selection" })
vim.keymap.set("n", "<leader><leader>jd", "<cmd>MoltenDelete<cr>", { desc = "Delete cell" })
vim.keymap.set("n", "<leader><leader>jh", "<cmd>MoltenHideOutput<cr>", { desc = "Hide output" })
vim.keymap.set("n", "<leader><leader>js", "<cmd>noautocmd MoltenEnterOutput<cr>", { desc = "Show/enter output" })
require("which-key").add({
    { "<leader><leader>j", group = "Jupyter" },
    { "<leader><leader>jr", group = "Jupyter Evaluate" },
})

--+- Commands -----------------------------------------------+
-- FIXME: Commands not properly registered

-- require("legendary").commands({
--     -- stylua: ignore start
--     { ":MoltenInfo", description = "Show information about the state of the plugin, initialization status, available kernels, and running kernels" },
--     { ":MoltenInit", description = "Initialize a kernel for the current buffer. If shared is passed as the first value, this buffer will use an already running kernel. If no kernel is given, prompts the user." },
--     { ":MoltenDeinit", description = "De-initialize the current buffer's runtime and molten instance. (called automatically on vim close/buffer unload)" },
--     { ":MoltenGoto", description = "Go to the nth code cell n defaults to 1 (1 indexed)" },
--     { ":MoltenNext", description = "Go to the next code cell, or jump n code cells n defaults to 1. Values wrap. Negative values move backwards" },
--     { ":MoltenPrev", description = "like Next but backwards" },
--     { ":MoltenEvaluateLine", description = "Evaluate the current line" },
--     { ":MoltenEvaluateVisual", description = "Evaluate the visual selection (cannot be called with a range!)" },
--     { ":MoltenEvaluateOperator", description = "Evaluate text selected by the following operator. see Keybindings for useage" },
--     { ":MoltenEvaluateArgument", description = "Evaluate given code in the given kernel" },
--     { ":MoltenReevaluateCell", description = "Re-evaluate the active cell (including new code) with the same kernel that it was originally evaluated with" },
--     { ":MoltenDelete", description = "Delete the active cell (does nothing if there is no active cell)" },
--     { ":MoltenShowOutput", description = "Shows the output window for the active cell" },
--     { ":MoltenHideOutput", description = "Hide currently open output window" },
--     { ":MoltenEnterOutput", description = "Move into the active cell's output window. Opens but does not enter the output if it's not open. must be called with noautocmd (see Keybindings for example)" },
--     { ":MoltenInterrupt", description = "Sends a keyboard interrupt to the kernel which stops any currently running code. (does nothing if there's no current output)" },
--     { ":MoltenOpenInBrowser", description = "Open the current output in the browser. Currently this only supports cells with 'text/html' outputs, configured with molten_auto_open_html_in_browser and molten_open_cmd" },
--     { ":MoltenRestart", description = "Shuts down a restarts the kernel. Deletes all outputs if used with a bang" },
--     { ":MoltenSave", description = "Save the current cells and evaluated outputs into a JSON file. When path is specified, save the file to path, otherwise save to g:molten_save_path. currently only saves one kernel per file" },
--     { ":MoltenLoad", description = "Loads cell locations and output from a JSON file generated by MoltenSave. path functions the same as MoltenSave. If shared is specified, the buffer shares an already running kernel." },
--     { ":MoltenExportOutput", description = "Export outputs from the current buffer and kernel to a jupyter notebook (.ipynb) at the given path. read more" },
--     { ":MoltenImportOutput", description = "Import outputs from a jupyter notebook (.ipynb). read more" },
--     -- stylua: ignore end
-- })

-- +---------------------------------------------------------+
-- | 3rd/image.nvim: Render Image in Terminal                |
-- +---------------------------------------------------------+

require("image").setup({
    backend = "kitty",
    integrations = {},
    max_width = 100,
    max_height = 12,
    max_height_window_percentage = math.huge,
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
})
