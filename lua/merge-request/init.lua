---@mod merge-request

local utils = require 'merge-request.utils'
local ui = require 'merge-request.ui'
local config = require 'merge-request.config'
local job = require 'plenary.job'
local M = {}

--- Loads the user's specified configuration and creates their desired keymapping
---@param opts table User-provided options, to override the default options with
M.setup = function(opts)
    -- TODO: need to error if user tries to pass an option that doesn't exist
    if opts ~= nil then
        config.opts = opts
    end

    vim.api.nvim_set_keymap(
        'n',
        config.opts['mapping'],
        [[:lua require'merge-request'.create()<CR>]],
        { noremap = true }
    )
end

--- Prompts the user for a Title for their merge request. If none is provided, then "Draft: <Need to name this MR>" is used
--- After the title is provided, the description window will be created
M.create = function()
    config._title = utils.prompt 'Title'
    if config._title == nil then
        config._title = 'Draft: <Need to name this MR>'
    end
    ui.create_window 'Description'
end

--- Executes the git push command, and consequently opens the newly-created merge request in the user's browser (if enabled)
M.submit = function()
    local branch = utils.get_branch_name()
    local title = config._title
    local description = config._description
    local args = utils.get_args(branch, title, description)

    local output = {}
    job
        :new({
            command = 'git',
            args = args,
            on_exit = function(j, _)
                for _, v in ipairs(j:stderr_result()) do
                    table.insert(output, v)
                end
            end,
        })
        :sync(10000) -- wait 10 seconds, just in case the command takes a hot minute

    local url = ''
    for _, line in ipairs(output) do
        print(line)

        url = string.match(line, 'https?://[^ ,;)]*')
        if config.opts.open_in_browser == true
            and url ~= nil
            and url ~= ''
            and string.match(url, 'merge_requests') ~= nil
        then
            utils.open_url(url)
        end
    end
end

return M
