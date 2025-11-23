return {
    cmd = { "pytest-language-server" },
    filetypes = { "python" },
    root_dir = function(fname)
        return require("lspconfig").util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "pytest.ini")(fname)
    end,
}
