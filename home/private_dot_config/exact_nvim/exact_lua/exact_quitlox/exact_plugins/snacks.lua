require("snacks").setup({
    bigfile = { enabled = true, notify = true },
    init = { enabled = true },
    profiler = { enabled = true },
    scratch = { enabled = true },
    toggle = { enabled = true },
    quickfile = { enabled = true, exclude = { "latex" } },
})

-- Toggle the profiler
Snacks.toggle.profiler():map("<leader>pp")
-- Toggle the profiler highlights
Snacks.toggle.profiler_highlights():map("<leader>ph")

require("which-key").add({
    { "<leader>p", group = "Profile" },
    { "<leader>ps", function() require("snacks").profiler.scratch() end, desc = "Profiler Scratch Buffer" },
})
