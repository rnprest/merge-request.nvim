local Job = require 'plenary.job'

local M = {}

function M.get_branch_name()
    return M.command_output({
        'git',
        'symbolic-ref',
        '--short',
        'HEAD',
    })[1]
end

function M.command_output(cmd, cwd)
    local command = table.remove(cmd, 1)
    local stderr = {}
    local stdout, ret = Job
        :new({
            command = command,
            args = cmd,
            cwd = cwd,
            on_stderr = function(_, data)
                table.insert(stderr, data)
            end,
        })
        :sync()
    return stdout, ret, stderr
end

function M.prompt(arg)
    local answer
    vim.ui.input({
        prompt = 'Merge Request (' .. arg .. '): ',
    }, function(input)
        if input then
            answer = input
        end
    end)
    return answer
end

return M
