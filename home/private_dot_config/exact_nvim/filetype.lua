vim.filetype.add({
    filename = {
        -- Configuration files
        ["~/.config/i3/config"] = "i3config",
        ["~/.config/polybar/config"] = "dosini",
        ["~/.config/Code/User/settings.json"] = "jsonc",
        -- Misc
        ["launch.json"] = "jsonc",
    },
    extension = {
        http = "http", -- required for kulala.nvim
        hl = "hyprlang",
        -- Python
        mpc = "python", -- MP-SPDZ Compiler
        sage = "python",
        spyx = "python",
        pyx = "python",
        -- Misc
        sbatch = "bash", -- Slurm
    },
    pattern = {
        ["~/.config/hypr/.*%.conf"] = "hyprlang",
    },
})
