local M = {}

-- Stolen from resession
function M.close_everything()
    local is_floating_win = vim.api.nvim_win_get_config(0).relative ~= ""
    if is_floating_win then
        -- Go to the first window, which will not be floating
        vim.cmd.wincmd({ args = { "w" }, count = 1 })
    end

    local scratch = vim.api.nvim_create_buf(false, true)
    vim.bo[scratch].bufhidden = "wipe"
    vim.api.nvim_win_set_buf(0, scratch)
    vim.bo[scratch].buftype = ""
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted then
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end
    end
    vim.cmd.tabonly({ mods = { emsg_silent = true } })
    vim.cmd.only({ mods = { emsg_silent = true } })
end

function M.get_session_name(cwd)
    local name = cwd or vim.fn.getcwd()
    local branch = vim.trim(vim.fn.system("git branch --show-current"))
    if vim.v.shell_error == 0 then
        return name .. ":" .. branch
    else
        return name
    end
end

function M.notify(msg, level)
    vim.notify(msg, level, { title = "Session", icon = " ", hl = { title = "Comment", border = "Comment", msg = "Comment" } })
end

return M
