----------------------------------------------------------------------
--                       VimTex: Keybindings                        --
----------------------------------------------------------------------

require("which-key").register({
    ["<localleader>"] = {
        l = {
            name = "[L]aTeX",
            a = "context menu",
            C = "[c]lean full",
            c = "[c]lean",
            e = "[e]rrors",
            g = "status",
            G = "status all",
            I = "[i]nfo full",
            i = "[i]nfo",
            K = "stop all",
            k = "stop",
            l = "compile",
            L = "compile selected",
            m = "i[m]aps list",
            o = "compile [o]utput",
            q = "log",
            s = "toggle main",
            t = "[t]oc open",
            T = "[t]oc toggle",
            v = "[v]iew",
            X = "reload state",
            x = "reload",
        },
    },
})
