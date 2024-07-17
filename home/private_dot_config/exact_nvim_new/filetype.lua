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
		-- Python
		mpc = "python", -- MP-SPDZ Compiler
		sage = "python",
		spyx = "python",
		pyx = "python",
		-- Misc
		sbatch = "bash", -- Slurm
	},
})
