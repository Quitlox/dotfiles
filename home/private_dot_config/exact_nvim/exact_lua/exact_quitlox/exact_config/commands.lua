-- :W saves file using sudo
vim.api.nvim_create_user_command("W", "execute 'w !sudo tee % > /dev/null' <bar> edit!", { bang = true })
