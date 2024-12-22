local jobs = require("overseer.strategy._jobs")
local log = require("overseer.log")
local shell = require("overseer.shell")
local util = require("overseer.util")

---@class overseer.SnacksTerminalStrategy : overseer.Strategy
---@field private opts overseer.SnacksTerminalStrategyOpts
---@field private terminal? snacks.terminal
local SnacksTerminalStrategy = {}

---@class overseer.SnacksTerminalStrategyOpts
---@field use_shell? boolean load user shell before running task
---@field close_on_exit? boolean close the terminal and delete terminal buffer (if open) after task exits
---@field quit_on_exit? "never"|"always"|"success" close the terminal window (if open) after task exits
---@field on_create? fun(term: table) function to execute on terminal creation

---@return overseer.Strategy
function SnacksTerminalStrategy.new()
    local opts = vim.tbl_extend("keep", opts or {}, {
        use_shell = false,
        close_on_exit = false,
        quit_on_exit = "never",
        on_create = nil,
    })

    ---@type overseer.SnacksTerminalStrategy
    local strategy = {
        opts = opts,
        terminal = nil,
    }
    setmetatable(strategy, { __index = SnacksTerminalStrategy })
    return strategy
end

function SnacksTerminalStrategy:reset()
    if self.terminal and self.terminal:valid() then
        self.terminal:close()
    end
end

function SnacksTerminalStrategy:get_bufnr()
    return self.terminal and self.terminal.buf
end

---@param task overseer.Task
function SnacksTerminalStrategy:start(task)
    local mode = vim.api.nvim_get_mode().mode
    local stdout_iter = util.get_stdout_line_iter()

    local function on_stdout(data)
        task:dispatch("on_output", data)
        local lines = stdout_iter(data)
        if not vim.tbl_isempty(lines) then
            task:dispatch("on_output_lines", lines)
        end
        vim.defer_fn(function()
            util.terminal_tail_hack(self.terminal.buf)
        end, 10)
    end

    local cmd = task.cmd
    if type(cmd) == "table" then
        cmd = shell.escape_cmd(cmd, "strong")
    end

    local passed_cmd
    if not self.opts.use_shell then
        passed_cmd = cmd
    else
        passed_cmd = "/bin/sh -c '" .. cmd .. "' && exit " .. (vim.o.shell:find("fish") and "$status" or "$?")
    end

    self.terminal = Snacks.terminal.open(passed_cmd, {
        env = task.env,
        cwd = task.cwd,
        win = {
            relative = "editor",
            position = "right",
        },
        jobstart_opts = {
            on_stdout = function(job_id, data, stream)
                if self.terminal == nil or not self.terminal:valid() then
                    return
                end
                on_stdout(data)
            end,
            on_exit = function(job_id, code)
                jobs.unregister(job_id)
                log:debug("Task %s exited with code %s", task.name, code)

                if self.terminal == nil or not self.terminal:valid() then
                    return
                end

                -- Feed one last line end to flush the output
                on_stdout({ "" })

                -- If we're exiting vim, don't call the on_exit handler
                -- We manually kill processes during VimLeavePre cleanup, and we don't want to trigger user
                -- code because of that
                if vim.v.exiting == vim.NIL then
                    task:on_exit(code)
                end

                local close = self.opts.quit_on_exit == "always" or (self.opts.quit_on_exit == "success" and code == 0)
                if close then
                    self.terminal:close()
                end
            end,
        },
    })

    -- Set the scrollback to max
    vim.bo[self.terminal.buf].scrollback = 100000
    util.hack_around_termopen_autocmd(mode)
end

function SnacksTerminalStrategy:stop()
    if self.terminal and self.terminal:valid() then
        self.terminal:close()
    end
end

function SnacksTerminalStrategy:dispose()
    if self.terminal then
        self:stop()
        self.terminal = nil
    end
end

return SnacksTerminalStrategy
