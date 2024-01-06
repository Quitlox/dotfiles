return {
    "chrisgrieser/nvim-chainsaw",
    keys = {
        { "gll", ":lua require('chainsaw').messageLog()<cr>", desc= "Log statement"},
        { "glv", ":lua require('chainsaw').variableLog()<cr>", desc= "Log Variable"},
        { "glo", ":lua require('chainsaw').objectLog()<cr>", desc= "Log Object"},
        { "glb", ":lua require('chainsaw').beepLog()<cr>", desc= "Log Beep"},
        { "glt", ":lua require('chainsaw').timeLog()<cr>", desc= "Log Time"},
        { "glr", ":lua require('chainsaw').removeLogs()<cr>", desc= "Remove Logs"},
    }
}
