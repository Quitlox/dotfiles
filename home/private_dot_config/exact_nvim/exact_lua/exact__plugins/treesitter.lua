-- +---------------------------------------------------------+
-- | nvim-treesitter/nvim-treesitter                         |
-- +---------------------------------------------------------+

local ts = require("nvim-treesitter")

-- Override the rust parser to use tree-sitter-rust-orchard.
-- nvim-treesitter's tarball download assumes GitHub naming ({repo}-{rev}/), but
-- Codeberg/Gitea extracts to just {repo}/, causing ENOENT on rename. We work
-- around this by pointing `path` at a local clone instead.
-- Clone with: git clone --depth 1 https://codeberg.org/grammar-orchard/tree-sitter-rust-orchard.git ~/.local/share/nvim/tree-sitter-grammars/tree-sitter-rust-orchard
local rust_orchard_path = vim.fn.stdpath("data") .. "/tree-sitter-grammars/tree-sitter-rust-orchard"
vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
        require("nvim-treesitter.parsers").rust = {
            install_info = {
                path = rust_orchard_path,
                url = "https://codeberg.org/grammar-orchard/tree-sitter-rust-orchard",
            },
            maintainers = {},
            tier = 4,
        }
    end,
})

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
-- NOTE: Add filetypes to ignore to suppress "warning: skipping unsupported lanaguage"
local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })
local ignore_filetypes = {
    "blink",
    "checkhealth",
    "figdet",
    "lazy",
    "mason",
    "oil",
    "Overseer",
    "sidekick",
    "snacks_",
    "tex", -- VimTeX provides its own indentexpr
}

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    desc = "Enable treesitter highlighting and indentation",
    callback = function(event)
        for _, pattern in ipairs(ignore_filetypes) do
            if event.match:match(pattern) then
                return
            end
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
