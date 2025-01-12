----------------------------------------------------------------
-- NOTE: Configurations
----------------------------------------------------------------

--  See `:help vim.opt`
--  For more options, you can see `:help option-list`

local function config_main()
  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.opt.mouse = 'a'
  vim.opt.mousescroll = 'ver:2,hor:4'
  vim.opt.mousemodel = 'popup_setpos'
  -- Don't show the mode, since it's already in the status line
  vim.opt.showmode = false
  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- Decrease update time
  vim.opt.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.opt.timeoutlen = 300

  -- Session management options
  vim.o.sessionoptions = 'blank,buffers,curdir,folds,globals,help,tabpages,winsize,winpos,terminal,localoptions'

  -- Tab Line
  vim.o.showtabline = 2

  -- Autosave: on focus lost
  vim.api.nvim_create_autocmd({ 'FocusLost' }, {
    pattern = '*',
    command = 'silent! wa', -- 'wa' means write all changed buffers
  })
end

local function config_editor()
  -- Make line numbers default
  vim.opt.number = true
  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  -- vim.opt.relativenumber = true

  -- Enable break indent
  vim.opt.breakindent = true

  -- Save undo history
  vim.opt.undofile = true

  -- Keep signcolumn on by default
  vim.opt.signcolumn = 'yes'

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  vim.opt.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
  vim.opt.fillchars:append { eob = ' ' }

  -- Preview substitutions live, as you type!
  vim.opt.inccommand = 'split'

  -- Show which line your cursor is on
  vim.opt.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.opt.scrolloff = 20

  -- vim.opt.fillchars = { fold = ' ' }
  -- vim.opt.foldmethod = 'indent'
  -- vim.opt.foldenable = false
  -- vim.opt.foldlevel = 99
  -- g.markdown_folding = 1 -- enable markdown folding

  -- Configure how new splits should be opened
  vim.opt.splitright = true
  vim.opt.splitbelow = true

  -- Cursor
  -- vim.opt.guicursor = {
  --   -- 'n-v-c-sm:block', -- default
  --   -- 'i-ci-ve:ver25', -- default
  --   'n-v-c-sm:ver25-NormalCursor',
  --   'i-ci-ve:ver25-InsertCursor',
  --   'r-cr-o:hor20',
  -- }
end

local function config_keybinds()
  -- See `:help vim.keymap.set()`
  -- Set <space> as the leader key (see `:help mapleader`)
  -- [note] Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- [note] This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })

  -- Execute Lua
  vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>')
  vim.keymap.set('n', '<leader>x', ':.lua<CR>')
  vim.keymap.set('v', '<leader>x', ':lua<CR>')

  -- Editor Utils
  vim.keymap.set('n', '<leader>``', ':wqa<CR>', { desc = 'Quit All (Write)' })
end

config_main()
config_editor()
config_keybinds()

----------------------------------------------------------------
--  NOTE:  GUI - Neovide
----------------------------------------------------------------

--  See: https://neovide.dev/configuration.html

if vim.g.neovide then
  -- vim.o.guifont = 'CommitMono Nerd Font:h14.5'
  -- vim.o.guifont = 'Maple Mono NF:h14.5'
  vim.g.neovide_scale_factor = 1.0
  vim.opt.linespace = 6

  vim.g.neovide_position_animation_length = 0.30
  vim.g.neovide_scroll_animation_length = 0.0

  vim.g.neovide_remember_window_size = true

  vim.g.neovide_cursor_animation_length = 0.07
  vim.g.neovide_cursor_trail_size = 0.2

  -- <D-?>: `D` is the CMD key
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

----------------------------------------------------------------
--  NOTE:  Autcommands
----------------------------------------------------------------

--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text, see `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

----------------------------------------------------------------
--  NOTE:  Plugins
----------------------------------------------------------------

--  Manager (lazy.nvim)
--   1. `:Lazy` to check status of plugins, press `?` for help in the menu and `:q` to close
--   2. `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
--   3. `:Lazy update` to update plugins

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

--  Plugins List

require('lazy').setup({
  { import = 'custom.plugins.neovim' },
  { import = 'custom.plugins.layout' },
  { import = 'custom.plugins.editor' },
  { import = 'custom.plugins.editor_syntax' },
  { import = 'custom.plugins.editor_lsp' },

  ----------------------------
  --> Notes
  ----------------------------
  --
  -- Useful plugin configs including in the Kickstart repo
  --   require 'kickstart.plugins.debug',
  --   require 'kickstart.plugins.indent_line',
  --   require 'kickstart.plugins.lint',
  --   require 'kickstart.plugins.autopairs',
  --   require 'kickstart.plugins.neo-tree',
  --   require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- Autoloading all *.lua files from `lua/custom/plugins/*.lua`
  --   This is the easiest way to modularize your config
  --   just uncomment the following line
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope! In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
  --
  --
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
