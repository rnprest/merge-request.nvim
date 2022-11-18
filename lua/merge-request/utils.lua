local job = require 'plenary.job'
local config = require 'merge-request.config'

local M = {}

--- Get's the current branch name, even if it hasn't been pushed yet
---@return string Current branch name
function M.get_branch_name()
    local args = {
        'symbolic-ref',
        '--short',
        'HEAD',
    }
    local stdout, _ = job
        :new({
            command = 'git',
            args = args,
        })
        :sync()
    local branch_name = stdout[1]
    return branch_name
end

--- Opens the given url in the user's browser
---@param url string The url to open
function M.open_url(url)
    vim.cmd('exec "!open \'' .. url .. '\'"')
end

--- Prompts the user for input
---@param arg string The title of the prompt to provide to the user
---@return string The user's input
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

--- Creates the required arguments for a merge request
---@param branch string The current branch name
---@param title string The merge request title
---@param description string The merge request description
---@return table The required arguments for the user's desired merge request to be created
function M.get_args(branch, title, description)
    local args = {
        'push',
        '-u',
        'origin',
        branch,
        '-o',
        'merge_request.create',
        '-o',
        'merge_request.title=' .. title,
        '-o',
        'merge_request.description=' .. description,
    }
    return config.add_push_options(args)
end

return M
