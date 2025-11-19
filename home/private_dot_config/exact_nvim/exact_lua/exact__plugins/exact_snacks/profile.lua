-- +---------------------------------------------------------+
-- | snacks.nvim: Profile                                    |
-- +---------------------------------------------------------+

vim.keymap.set("n", "<leader>ps", require("snacks").profiler.scratch, { desc = "Profiler Scratch Buffer" })

-- Toggle the profiler
Snacks.toggle.profiler():map("<leader>pp")
-- Toggle the profiler highlights
Snacks.toggle.profiler_highlights():map("<leader>ph")

require("which-key").add({
    { "<leader>p", group = "Profile" },
})
