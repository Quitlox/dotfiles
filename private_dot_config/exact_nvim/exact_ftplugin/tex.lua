-- Tex options
vim.opt.formatoptions:remove("t")
vim.opt.concealcursor = "c"
vim.opt.foldexpr = "manual"

-- Always SoftWrap
require('wrapping').soft_wrap_mode()

-- VimTex Keybindings
require("which-key").register({
    ["<localleader>"] = {
        l = {
            name = "LaTeX",
            a = "Context menu",
            C = "Clean full",
            c = "Clean",
            e = "Errors",
            g = "Status",
            G = "Status all",
            I = "Info full",
            i = "Info",
            K = "Kill all",
            k = "Kill",
            l = "Compile",
            L = "Compile selected",
            m = "Mappings list",
            o = "Compilation Output",
            q = "Log",
            s = "Toggle main",
            t = "ToC open",
            T = "ToC toggle",
            v = "View",
            X = "Reload state",
            x = "Reload",
        },
    },
})

