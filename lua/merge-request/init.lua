local utils = require 'merge-request.utils'
local M = {}

M.create = function()
    local title = utils.prompt 'Title'
    if title == nil then
        title = 'Draft: <Need to name this MR>'
    end
    local description = utils.prompt 'Description'
    if description == nil then
        print 'Aborting due to empty description'
        return
    end

    local title_arg = 'merge_request.title=' .. title
    local description_arg = 'merge_request.description=' .. description
    local _, _, stderr = utils.command_output {
        'git',
        'push',
        '-u',
        'origin',
        utils.get_branch_name(),
        '-o',
        'merge_request.create',
        '-o',
        title_arg,
        '-o',
        description_arg,
        '-o',
        'merge_request.remove_source_branch',
        -- '-o',
        -- 'merge_request.assign="email_address"',
    }

    local link_line = stderr[3]
    local trimmed = vim.trim(link_line)
    local link_start, _ = string.find(trimmed, 'http')
    local url = string.sub(trimmed, link_start)
    print('Merge request created at: ' .. url)

    -- TODO: open the link automatically with browse

    -- TODO: need to replace the description with a buffer that you can write newlines to, THEN
    -- replace all newlines with <br>
end

return M
