local utils = require 'merge-request.utils'
local ui = require 'merge-request.ui'
local M = {}

Merge_request_title = nil
Merge_request_description = nil
-- Need to create a config and put description in there

M.create = function()
    Merge_request_title = utils.prompt 'Title'
    if Merge_request_title == nil then
        Merge_request_title = 'Draft: <Need to name this MR>'
    end
    ui.create_window 'Description'
end

M.actually_create = function()
    if Merge_request_description == nil then
        print 'Aborting merge request creation'
        return
    end
    local title_arg = 'merge_request.title=' .. Merge_request_title
    local description_arg = 'merge_request.description=' .. Merge_request_description
    -- maybe I should use plenary async job here instead?
    -- local job = require('plenary.job')
    -- job:new({
    --     command = 'curl',
    --     args = {'icanhazip.com'},
    --     on_exit = function(j, exit_code)
    --         local res = table.concat(j:result(), "\n")
    --         local type = "Success!"
    --
    --         if exit_code ~=0 then
    --             type = "Error!"
    --         end
    --         print(type, res)
    --     end,
    -- }):start()
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
    -- Set these to nil again
    Merge_request_title = nil
    Merge_request_description = nil

    local link_line = stderr[3]
    local trimmed = vim.trim(link_line)
    local link_start, _ = string.find(trimmed, 'http')
    local url = string.sub(trimmed, link_start)
    print('Merge request created at: ' .. url)
    -- TODO: open the link automatically with browse
end

return M
