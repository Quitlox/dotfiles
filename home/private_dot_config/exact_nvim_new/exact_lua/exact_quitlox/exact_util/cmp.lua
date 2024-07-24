local M = {}

M.extend_cmp = function(updater)
    local cmp = require("cmp")
    local config = cmp.get_config()

    -- Call the provided updater function to update the config
    updater(config)

    -- Apply the updated config
    cmp.setup(config)
end

return M
