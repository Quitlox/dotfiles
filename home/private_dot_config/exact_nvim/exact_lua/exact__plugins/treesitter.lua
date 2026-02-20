-- +---------------------------------------------------------+
-- | nvim-treesitter/nvim-treesitter                         |
-- +---------------------------------------------------------+

local ts = require("nvim-treesitter")

-- Install default parsers
ts.install({
    -- Programming Languages
    "lua",
    "luadoc",
    "nix",
    "python",
    "rust",
    "vim",
    "vimdoc",
    -- Text
    "comment",
    "bibtex",
    "markdown",
    "markdown_inline",
    -- Web
    "css",
    "html",
    "htmldjango",
    "javascript",
    "jsdoc",
    -- Template
    "embedded_template",
    "jinja",
    "jinja_inline",
    -- Terminal
    "awk",
    "bash",
    "jq",
    -- Common Tooling
    "cmake",
    "diff",
    "dockerfile",
    "editorconfig",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "http",
    "make",
    -- Common Dataformats
    "csv",
    "ini",
    "toml",
    "yaml",
    -- Misc
    "dap_repl",
    "hyprlang",
})

-- Auto-install parsers and enable highlighting on FileType
local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })
local ignore_filetypes = {
    "checkhealth",
    "lazy",
    "mason",
    "snacks_dashboard",
    "snacks_notif",
    "snacks_win",
}

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    desc = "Enable treesitter highlighting and indentation",
    callback = function(event)
        if vim.tbl_contains(ignore_filetypes, event.match) then
            return
        end

        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        local buf = event.buf

        -- Start highlighting immediately (works if parser exists)
        pcall(vim.treesitter.start, buf, lang)

        -- Enable treesitter indentation
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        -- Install missing parsers (async, no-op if already installed)
        ts.install({ lang })
    end,
})
