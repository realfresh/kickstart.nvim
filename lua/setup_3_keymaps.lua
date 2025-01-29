local C = require 'config'
local U = require 'utils'

-- Locals

local map = vim.keymap.set

-- Module
local M = {}

M.config = {
  -- Which Key: main legend
  wk_legend = {
    -- { '<leader>`', group = 'Global' },
    { '<leader>b', group = '[B]uffers' },
    { '<leader>bd', group = '[D]elete' },
    { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
    { '<leader>cc', group = '[C]ursors', mode = { 'n', 'x' } },
    { '<leader>e', group = '[E]ditor' },
    { '<leader>g', group = '[G]it' },
    { '<leader>gh', group = '[G]it Hunk' },
    -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>l', group = '[L]SP' },
    { '<leader>o', group = '[O]ther' },
    { '<leader>p', group = '[P]rojects (sessions)' },
    { '<leader>r', group = '[R]ename' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]ab' },
    { '<leader>z', group = ' Editor' },
    -- { '<leader>d', group = '[D]ocument' },
    -- { '<leader>w', group = '[W]orkspace' },
  },
}

M.setup_base = function()
  -- Leaders
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- Clear highlights on search when pressing <Esc> in normal mode
  map('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic keymaps
  map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- [note] This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Keybinds to make split navigation easier.
  map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Allow clipboard copy paste in neovim
  map('', '<D-v>', '+p<CR>', { silent = true })
  map({ 't', 'v', '!' }, '<D-v>', '<C-R>+', { silent = true })

  -- Execute Lua
  map('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Lua: execute current file' })
  map('n', '<leader>x', ':.lua<CR>')
  map('v', '<leader>x', ':lua<CR>')

  -- Editor Utils
  map('n', '<localleader>w', ':wqa<CR>', { desc = 'Quit All (Write)' })
end

M.setup_plugins = function()
  --
end

return M

--[[ 

When you use `<cmd>`, it executes the command and then immediately returns to normal mode without consuming the `<Esc>` keypress. This is different from using `:` which would consume the keypress.

Here's a breakdown of different approaches:

```lua
-- Good: Uses <cmd>, won't break Esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Bad: Using :, might interfere with Esc functionality
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>')

-- Also good: Using a Lua function
vim.keymap.set('n', '<Esc>', function()
    vim.cmd('nohlsearch')
end)
```

If you want to be extra safe and ensure `<Esc>` works in all contexts, you can add the original `<Esc>` functionality back explicitly:

```lua
vim.keymap.set('n', '<Esc>', function()
    vim.cmd('nohlsearch')
    return '<Esc>'
end, { expr = true })
```

But in practice, the simple `<cmd>` version is perfectly fine and won't interfere with normal `<Esc>` functionality. 

]]
