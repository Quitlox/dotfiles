return {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    keys = {
        { "gd", "<cmd>Glance definitions<cr>", "Go Definition" },
        { "gi", "<cmd>Glance implementations<cr>", "Go Implementation" },
        { "gt", "<cmd>Glance type_definitions<cr>", "Peek Type Definition" },
        { "gr", "<cmd>Glance references<cr>", "Go References" },
    },
    config = function()
        local actions = require("glance").actions
        require("glance").setup({
            hooks = {
                before_open = function(results, open, jump, method)
                    -- Always show Glance for references | implementations
                    if method == "references" or method == "implementations" then
                        open(results)
                        return
                    end

                    -- For definitions | type definitions, jump to the first result
                    if #results == 1 then
                        jump(results[1])
                    else
                        open(results)
                    end
                end,
            },
            mappings = {
                list = {
                    ["<leader>l"] = false,
                    ["i"] = actions.enter_win("preview"),
                    ["<C-t>"] = actions.quickfix,
                },
                preview = {
                    ["Q"] = actions.close,
                    ["<leader>l"] = false,
                    ["q"] = actions.enter_win("list"),
                    ["<C-t>"] = actions.quickfix,
                },
            },
            use_trouble_qf = true,
        })
    end,
}
