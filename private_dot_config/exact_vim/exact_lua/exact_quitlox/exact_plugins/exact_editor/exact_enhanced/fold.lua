return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  init = function()
    vim.o.foldcolumn = "1" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    require("quitlox.util.which_key").register({
      z = {
        name = "Folds",
        R = { "<cmd> lua require('ufo').openAllFolds()<cr>", "Open All Folds" },
        M = { "<cmd> lua require('ufo').closeAllFolds()<cr>", "Close All Folds" },
      },
    })

    require("ufo").setup()
  end,
}
