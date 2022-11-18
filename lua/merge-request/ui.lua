local popup = require 'plenary.popup'
local config = require 'merge-request.config'

local M = {}

M.popup_id = nil
M.popup_bufnr = nil

--- Closes the floating window used to provide the description
function M.close()
    vim.api.nvim_win_close(M.popup_id, true)
    M.popup_id = nil
    M.popup_bufnr = nil
end

--- Submits the merge request with the description provided in the floating window
function M.on_save()
    local lines = vim.api.nvim_buf_get_lines(M.popup_bufnr, 0, -1, true)
    local desc = ''

    for _, line in pairs(lines) do
        line = string.gsub(line, '\n', '<br>')
        line = line .. '<br>'
        desc = desc .. line
    end

    if desc == nil or desc == '' then
        print 'Aborting merge request creation'
        return
    end

    -- Trim the trailing <br>
    config._description = string.sub(desc, 1, string.len(desc) - 4)

    require('merge-request').submit()
    M.close()
end

--- Creates a floating window to input the description into
---@param title string The title to display at the top of the floating window
function M.create_window(title)
    local width = 100
    local height = 20
    local borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
    local bufnr = vim.api.nvim_create_buf(false, false)
    M.popup_bufnr = bufnr -- need to use this in stringify_description

    M.popup_id, _ = popup.create(bufnr, {
        title = 'Merge Request (' .. title .. ')',
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })
    vim.api.nvim_buf_set_name(bufnr, 'merge-request-description') -- buffer must have a name
    vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'delete') -- delete buf when no longer displayed in a window
    -- Close popup window on q or esc
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', "<Cmd>lua require('merge-request.ui').close()<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(
        bufnr,
        'n',
        '<ESC>',
        "<Cmd>lua require('merge-request.ui').close()<CR>",
        { silent = true }
    )

    -- 'Write' buffer by hitting Enter
    vim.api.nvim_buf_set_keymap(
        bufnr,
        'n',
        '<CR>',
        "<Cmd>lua require('merge-request.ui').on_save()<CR>",
        { silent = true }
    )
end

return M
