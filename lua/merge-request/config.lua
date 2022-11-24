---@mod merge-request.config

local M = {}

M._title = nil
M._description = nil

--- These will be applied unless overridden in the setup method
M.default_opts = {
    mapping = '<leader>mr',
    open_in_browser = true,
    remove_source_branch = true, -- Set the merge request to remove the source branch when it’s merged.
    draft = false, -- Mark the merge request as a draft
}

--- Maps config option names --> cli option names
M.push_options = {
    remove_source_branch = 'merge_request.remove_source_branch',
    draft = 'merge_request.draft',
}

--- Adds any push options that the user has enabled in their config
---@param command table The current cli arguments to push with
---@return table An updated table of arguments, that now includes the user's desired push options
M.add_push_options = function(command)
    for name, opt in pairs(M.push_options) do
        if M.opts[name] == true then
            table.insert(command, '-o')
            table.insert(command, opt)
        end
    end
    return command
end

M.opts = {}

return M
