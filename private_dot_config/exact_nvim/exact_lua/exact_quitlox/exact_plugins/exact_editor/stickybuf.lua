return {
    'stevearc/stickybuf.nvim',
    config=function()
        local extra_supported_filetypes={
            "Outline"

        }

        require("stickybuf").setup({
          get_auto_pin = function(bufnr)
              local filetype = vim.bo[bufnr].filetype
              if vim.tbl_contains(extra_supported_filetypes, filetype) then
                  return "filetype"
              end
            return require("stickybuf").should_auto_pin(bufnr)
          end
        })
    end
}
