return {
    {
        "DanilaMihailov/beacon.nvim",
        lazy = false,
        enabled = function() return vim.g.neovide == nil end,
    },
    require("quitlox.util").legendary({
        { ":Beacon", "Highlight current position." },
        { ":BeaconToggle", "Toggle cursor highlight." },
        { ":BeaconOn", "Enable cursor highlight." },
        { ":BeaconOff", "Disable cursor highlight." },
    }),
}
