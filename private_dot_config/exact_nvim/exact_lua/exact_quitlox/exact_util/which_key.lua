
local wk = require("which-key")
local legendary = require('legendary.integrations.which-key')

local register = function(tables, opts)
    wk.register(tables, opts)
    -- legendary.bind_whichkey(tables, opts,false)
end

return {
    register = register,
}
