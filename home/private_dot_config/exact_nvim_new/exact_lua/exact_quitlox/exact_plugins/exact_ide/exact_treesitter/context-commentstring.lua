-- +---------------------------------------------------------+
-- | JoosepAlviste/nvim-ts-context-commentstring             |
-- +---------------------------------------------------------+

require("ts_context_commentstring").setup({
    enable_autocmd = false,
})

--+- Integrate with native commenting -----------------------+
-- stylua: ignore start
local get_option = vim.filetype.get_option
vim.filetype.get_option = function(filetype, option)
  return option == "commentstring"
    and require("ts_context_commentstring.internal").calculate_commentstring()
    or get_option(filetype, option)
end
-- stylua: ignore end
