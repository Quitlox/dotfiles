----------------------------------------
-- Crates.nvim
----------------------------------------
-- Autocompletion for crates in Cargo.toml

-- Set mappings
local function register_mappings()
    local crates = require("crates")
    require("which-key").register({
        ["<localleader>"] = {
            c = {
                name = "Crates",
                t = { crates.toggle, "Crates Toggle" },
                r = { crates.reload, "Crates Reload" },
                --
                v = { crates.show_versions_popup, "Crate Version" },
                f = { crates.show_features_popup, "Crate show Features" },
                d = { crates.show_dependencies_popup, "Crate show Dependencies" },
                --
                u = { crates.update_crate, "Crate Update" },
                U = { crates.update_all_creates, "Crate Upgrade" },
                a = { crates.update_all_crates, "Crate update All" },
                A = { crates.update_all_creates, "Crate Upgrade all" },
                --
                H = { crates.open_homepage, "Crate open Homepage" },
                R = { crates.open_repository, "Crate open Repository" },
                D = { crates.open_documentation, "Crate open Documentation" },
                C = { crates.open_crates_io, "Crate open CratesIO" },
            },
        },
    })
end

return {
    "Saecki/crates.nvim",
    lazy = true,
    version = "",
    opts = {
        null_ls = {
            enabled = true,
            name = "crates.nvim",
        },
    },
    init = function()
        -- Inject crates as completion source
        vim.api.nvim_create_autocmd("BufRead", {
            group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
            pattern = "Cargo.toml",
            callback = function()
                require("cmp").setup.buffer({ sources = { { name = "crates" } } })
                register_mappings()
            end,
        })
    end,
}