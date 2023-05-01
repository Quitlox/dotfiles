return {
    "mrjones2014/legendary.nvim",
    version = "",
    dependencies = { "kkharji/sqlite.lua" },
    priority = 900, -- Should be earlier than which-key
    config = function()
        require("legendary").setup({
            commands = { {
                    
                    ':DismissNotifications',
                    function()
                        require('notify').dismiss({pending = true, silent=true})
                    end,
                    description = 'Dismiss all notifications'
                },
                {
                        ':DeleteShadaFile',
                        function()
                                  local shada_file = vim.fn.stdpath('data') .. '/shada/main.shada'
  local file_exists = io.open(shada_file, "r")

  if file_exists then
    file_exists:close()

    local success, err = os.remove(shada_file)
    if success then
      print("Shada file deleted successfully.")
    else
      print("Error deleting shada file: " .. tostring(err))
    end
  else
    print("Shada file not found.")
  end
                        end,
                        description = 'Delete the Shada file, in case of corruptions'
                }
        },
            which_key = {
                auto_register = false,
                do_binding = false,
            },
        })
        require("which-key").register({
            k = { "<cmd>Legendary<cr>", "Vim Keymap" },
        }, { prefix = "<leader>v" })
    end,
    extensions = {
        nvim_tree=true,
        smart_splits=true,
        diffview=true,
    }
}
