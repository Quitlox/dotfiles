----------------------------------------------------------------------
--                               Flit                               --
----------------------------------------------------------------------
-- Extension to Leap similar to CleverF
-- Improves the functionality of f/F and t/T

return {
    "ggandor/flit.nvim",
    opts = {
        keys = { f = "f", F = "F", t = "t", T = "T" },
        -- A string like "nv", "nvo", "o", etc.
        labeled_modes = "v",
        multiline = true,
        -- Like `leap`s similar argument (call-specific overrides).
        -- E.g.: opts = { equivalence_classes = {} }
        opts = {},
    },
}
