--+- Setup --------------------------------------------------+
require("oil").setup({
    default_file_explorer = true,
    keymaps = {
        ["q"] = "actions.close",
        ["<esc>"] = "actions.close",
    },
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "-", function() require("oil").open_float() end, { noremap = true, silent = true })

--+- Commands -----------------------------------------------+
require("legendary").commands({
    { ":Oil", function() require("oil").open_float() end, description = "oil: Open" },
    { ":OilRoot", function() require("oil").open_float(vim.fn.getcwd()) end, description = "oil: Open in project root" },
    { ":OilDiscard", function() require("oil").discard_all_changes() end, description = "oil: Discard changes" },
})
