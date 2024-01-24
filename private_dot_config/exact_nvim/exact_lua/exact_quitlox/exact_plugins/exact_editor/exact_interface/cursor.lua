return {
    {
        "DanilaMihailov/beacon.nvim",
        lazy = false,
        enabled = function() return vim.fn.has("neovide") == 0 end,
    },
    require("quitlox.util").legendary({
        { ":Beacon", "Highlight current position." },
        { ":BeaconToggle", "Toggle cursor highlight." },
        { ":BeaconOn", "Enable cursor highlight." },
        { ":BeaconOff", "Disable cursor highlight." },
    }),
}
