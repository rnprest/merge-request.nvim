vim.api.nvim_set_keymap('n', '<leader>mr', [[:lua require'merge-request'.create()<CR>]], { noremap = true })
