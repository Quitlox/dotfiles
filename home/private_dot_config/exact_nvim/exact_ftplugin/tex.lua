-- +----------------------------------------------------------+
-- | lervag/vimtex: LaTeX Support                             |
-- +----------------------------------------------------------+

-- +- Options ------------------------------------------------+
vim.opt.formatoptions:remove("t")
vim.opt.concealcursor = "c"
vim.opt.conceallevel = 2
vim.opt.foldexpr = "manual"

-- +- Quickfix -----------------------------------------------+
vim.g.vimtex_quickfix_enabled = 1
vim.g.vimtex_quickfix_mode = 0

vim.g.vimtex_quickfix_ignore_filters = {
    "Underfull \\hbox",
    "Overfull \\hbox",
    "LaTeX Warning: .\\+ float specifier changed to",
    "LaTeX hooks Warning",
    'Package siunitx Warning: Detected the "physics" package:',
    "Package hyperref Warning: Token not allowed in a PDF string",
}

-- +- Table of Contents --------------------------------------+
vim.g.vimtex_toc_config = {
    split_pos = "vert rightbelow",
}

-- +- Documentation ------------------------------------------+
vim.g.vimtex_doc_handlers = { "vimtex#doc#handlers#texdoc" }

-- +- Indentation --------------------------------------------+
vim.g.vimtex_indent_conditionals = {
    ["open"] = [[\v%(%(\\newif)@<!\\if%(f>|field|name|numequal|thenelse)@!)|%(\\pcfor>)' ]],
    ["else"] = "\\else>",
    ["close"] = "%(\\fi\\>)|%(\\pcendfor\\>)",
}

-- +- Conceal ------------------------------------------------+
vim.g.vimtex_syntax_conceal = {
    accents = 1,
    cites = 1,
    fancy = 1,
    greek = 1,
    math_bounds = 1,
    math_delimiters = 1,
    math_fracs = 1,
    math_super_sub = 1,
    math_symbols = 1,
    sections = 1,
    styles = 1,
}

-- +- Compilation --------------------------------------------+
-- Linux
if vim.fn.has("unix") == 1 then
    vim.g.vimtex_quickfix_method = "pplatex"
    vim.g.vimtex_view_method = "zathura"
end

-- Windows
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    -- Ensure sioyek is in the system PATH, otherwise specify complete path
    -- vim.g.vimtex_view_sioyek_exe = "C:\\Users\\witloxkhd\\Applications\\sioyek\\sioyek.exe"
    vim.g.vimtex_view_method = "sioyek"
end

-- WSL2
if vim.fn.has("unix") == 1 and vim.fn.has("wsl") then
    -- Possible locations for sioyek.exe across different systems
    local sioyek_paths = {
        "/mnt/c/Users/witloxkhd/Applications/sioyek/sioyek.exe",
        -- "/mnt/c/Users/witloxkhd/AppData/Local/sioyek/sioyek.exe",
        -- "/mnt/c/Program Files/sioyek/sioyek.exe",
    }

    -- Find the first valid sioyek path
    local sioyek_exe = nil
    for _, path in ipairs(sioyek_paths) do
        if vim.fn.filereadable(path) == 1 then
            sioyek_exe = path
            break
        end
    end

    if sioyek_exe then
        -- Configure vimtex with the found sioyek path
        vim.g.vimtex_view_method = "sioyek"
        vim.g.vimtex_view_sioyek_exe = sioyek_exe
        vim.g.vimtex_callback_progpath = "wsl nvim"

        -- Define function to reload sioyek
        SioyekReload = function()
            local cmd = { sioyek_exe, "--execute-command", "reload" }
            local job_id = vim.fn.jobstart(cmd, {
                on_exit = function(_, exit_status)
                    vim.notify("Sioyek exited with code: " .. exit_status, "info")
                end,
            })

            if job_id == 0 then
                vim.notify("Failed to reload sioyek", vim.log.levels.ERROR)
            end
        end

        -- Autocommand for compile success
        vim.api.nvim_create_autocmd("User", {
            pattern = "VimtexEventCompileSuccess",
            group = vim.api.nvim_create_augroup("MySioyekReloadOnCompileSuccess", { clear = true }),
            callback = function()
                SioyekReload()
            end,
        })
    else
        vim.notify("Sioyek not found in any of the expected locations", vim.log.levels.WARN)
    end
end

-- +- Integration --------------------------------------------+
-- Use LSP
vim.g.vimtex_complete_enabled = 0

-- Use matchup.vim
vim.g.matchup_override_vimtex = 1
vim.g.vimtex_matchparen_enabled = 0

-- Use treesitter
vim.g.vimtex_syntax_enabled = 0
vim.g.vimtex_indent_enabled = 0
vim.g.vimtex_indent_bib_enabled = 0

-- +- Integration: Wrapping.nvim -----------------------------+
require("wrapping").soft_wrap_mode()

-- +- Integration: Luasnip -----------------------------------+
require("luasnip").setup({
    enable_autosnippets = true,
})

-- +- Integration: Which-key.nvim ----------------------------+
require("which-key").add({
    { "<localleader>l", group = "LaTeX" },
    { "<localleader>la", desc = "Context menu" },
    { "<localleader>lC", desc = "Clean full" },
    { "<localleader>lc", desc = "Clean" },
    { "<localleader>le", desc = "Errors" },
    { "<localleader>lg", desc = "Status" },
    { "<localleader>lG", desc = "Status all" },
    { "<localleader>lI", desc = "Info full" },
    { "<localleader>li", desc = "Info" },
    { "<localleader>lK", desc = "Kill all" },
    { "<localleader>lk", desc = "Kill" },
    { "<localleader>ll", desc = "Compile" },
    { "<localleader>lL", desc = "Compile selected" },
    { "<localleader>lm", desc = "Mappings list" },
    { "<localleader>lo", desc = "Compilation Output" },
    { "<localleader>lq", desc = "Log" },
    { "<localleader>ls", desc = "Toggle main" },
    { "<localleader>lt", desc = "ToC open" },
    { "<localleader>lT", desc = "ToC toggle" },
    { "<localleader>lv", desc = "View" },
    { "<localleader>lX", desc = "Reload state" },
    { "<localleader>lx", desc = "Reload" },

    -- Override outline with toc
    { "<leader>o", group = "Outline" },
    { "<leader>oo", "<cmd>VimtexTocToggle<cr>", desc = "Open ToC" },
})
