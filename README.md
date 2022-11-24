<h1 align="center">
  <br>
  merge-request.nvim
  <br>
  <br>
  <img width="800" alt="merge-request.nvim" src="https://user-images.githubusercontent.com/47462344/203835794-892ac60e-8c02-48b3-8ae4-2efbd5ccfbdb.png">
  <br>
</h1>
<h2 align="center">
  <img alt="PR" src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat"/>
  <img alt="Lua" src="https://img.shields.io/badge/lua-%232C2D72.svg?&style=flat&logo=lua&logoColor=white"/>
</h2>
<h3 align="center">
  <a href="#requirements">Requirements</a> •
  <a href="#installation-and-setup">Installation and Setup</a>
</h3>

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
