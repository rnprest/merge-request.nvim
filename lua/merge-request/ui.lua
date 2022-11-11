local popup = require 'plenary.popup'
-- local mr = require 'merge-request'

local M = {}

Merge_request_popup_id = nil
Merge_request_popup_bufnr = nil

function M.close()
    require('merge-request').actually_create()
    -- vim.cmd 'bdMerge_request_popup_bufnr'
    -- vim.api.nvim_buf_delete(Merge_request_popup_bufnr, { force = true })
    vim.api.nvim_win_close(Merge_request_popup_id, true)
    Merge_request_popup_id = nil
    Merge_request_popup_bufnr = nil
end

function M.on_save()
    local lines = vim.api.nvim_buf_get_lines(Merge_request_popup_bufnr, 0, -1, true)
    local desc = ''

    for _, line in pairs(lines) do
        line = string.gsub(line, '\n', '<br>')
        line = line .. '<br>'
        -- TODO: need to NOT add that <br> if it's the last line
        desc = desc .. line
    end

    Merge_request_description = desc
    M.close()
end

function M.create_window(title)
    local width = 100
    local height = 20
    local borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }
    local bufnr = vim.api.nvim_create_buf(false, false)
    Merge_request_popup_bufnr = bufnr -- need to use this in stringify_description

    Merge_request_popup_id, _ = popup.create(bufnr, {
        title = 'Merge Request (' .. title .. ')',
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })
    vim.api.nvim_buf_set_name(bufnr, 'merge-request-description') -- buffer must have a name
    -- vim.api.nvim_buf_set_option(bufnr, 'buftype', 'acwrite') -- buffer will always be written with BufWriteCmds
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

    -- Save on write
    -- local merge_request_group = vim.api.nvim_create_augroup('merge_request', {})
    -- vim.api.nvim_create_autocmd('BufWriteCmd', {
    --     group = merge_request_group,
    --     buffer = bufnr,
    --     command = "lua require('merge-request.ui').on_save()",
    -- })

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
