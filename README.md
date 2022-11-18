<h1 align='center'>merge-request.nvim</h1>

Create GitLab Merge Requests directly from within neovim, by using their [Git push options](https://docs.gitlab.com/ee/user/project/push_options.html#push-options-for-merge-requests).

## Requirements

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- GitLab version 15+ if planning on using the [draft push option](https://gitlab.com/gitlab-org/gitlab/-/issues/296673), 12.2+ otherwise

## Installation and Setup

Using [packer](https://github.com/wbthomason/packer.nvim):

```lua
use {
    'rnprest/merge-request.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
        require('merge-request').setup {
            -- Default options are listed below - you can just call setup() if these are fine with you
            mapping = '<leader>mr',
            open_in_browser = true,
            remove_source_branch = true,
            draft = false,
        }
    end,
}
```
