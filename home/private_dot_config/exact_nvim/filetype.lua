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
        jinja = "jinja",
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
        ["~/.config/ansible/.*%.yml"] = "yaml.ansible",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "checkhealth",
    group = vim.api.nvim_create_augroup("MyDisableSpellOnCheckhealth", { clear = true }),
    callback = function()
        vim.wo.spell = false
    end,
})
