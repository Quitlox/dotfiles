return {
    "stevearc/oil.nvim",
    opts = {
        default_file_explorer = false,
    },
    init = function()
        require('which-key').register({
            ['<leader>o'] = {
                ['o'] = { '<cmd>Oil<cr>', 'Open Oil' },
                ['c'] = { '<cmd>OilClose<cr>', 'Close Oil' },
                ['t'] = { '<cmd>OilToggle<cr>', 'Toggle Oil' },
            },
        })
    end
}
