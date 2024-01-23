return {
    {
        "DanilaMihailov/beacon.nvim",
        lazy = false,
    },
    require("quitlox.util").legendary({
        { ":Beacon", "Highlight current position." },
        { ":BeaconToggle", "Toggle cursor highlight." },
        { ":BeaconOn", "Enable cursor highlight." },
        { ":BeaconOff", "Disable cursor highlight." },
    }),
}
