local utils = require 'utils'
local M = {}

M.setup = function()
  ----------------------------------------------------------------
  -- NOTE: Options
  ----------------------------------------------------------------

  -- S: Mouse

  vim.opt.mouse = 'a'
  vim.opt.mousescroll = 'ver:3,hor:32'
  vim.opt.mousemodel = 'popup_setpos'
  vim.opt.scrolloff = 0
  vim.opt_local.scrolloff = 0

  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      vim.opt.scrolloff = 0
      vim.opt_local.scrolloff = 0
    end,
  })

  -- S: Fonts

  vim.g.have_nerd_font = true

  -- S: Clipboard

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)

  -- S: Search

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- S: Editor

  -- Disable line wrapping
  vim.opt.wrap = false

  -- Decrease update time
  vim.opt.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.opt.timeoutlen = 300

  -- Session management options
  -- vim.o.sessionoptions = 'blank,buffers,curdir,folds,globals,tabpages,terminal,winsize,winpos'
  local sessionopts_basic = 'blank,buffers,curdir,folds,help,tabpages,terminal,winsize,winpos'
  local sessionopts_autosession = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  --  -> auto-session recommend session opts
  vim.o.sessionoptions = sessionopts_basic

  -- Enable break indent
  vim.opt.breakindent = true

  -- Save undo history
  vim.opt.undofile = true

  -- Whitespace characters
  vim.opt.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
  vim.opt.fillchars:append { eob = ' ' }

  -- Preview substitutions live, as you type!
  vim.opt.inccommand = 'split'

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.opt.scrolloff = 20

  -- Configure how new splits should be opened
  vim.opt.splitright = true
  vim.opt.splitbelow = true

  -- S: Folding

  vim.opt.foldcolumn = '1' -- UFO recommended
  vim.opt.foldmethod = 'indent'
  vim.opt.foldlevel = 99 -- Start with all folds expanded
  vim.opt.foldenable = true

  -- vim.opt.foldcolumn = 'auto:1'
  -- vim.opt.foldcolumn = 'auto' -- Set fold level to 99 (effectively expanding all folds)
  -- vim.opt.foldlevelstart = 99

  -- vim.opt.fillchars:append {
  --   foldsep = '│', -- Fold separator
  --   foldopen = '^', -- Mark for open folds
  --   foldclose = '>', -- Mark for closed folds
  -- }

  -- g.markdown_folding = 1 -- enable markdown folding

  -- S: Indicators

  -- Disable 'mode' already in status line
  vim.opt.showmode = false

  -- Tab Line
  vim.o.showtabline = 2

  -- Show which line your cursor is on
  vim.opt.cursorline = true

  -- Cursor customization
  -- vim.opt.guicursor = {
  --   -- 'n-v-c-sm:block', -- default
  --   -- 'i-ci-ve:ver25', -- default
  --   'n-v-c-sm:ver25-NormalCursor',
  --   'i-ci-ve:ver25-InsertCursor',
  --   'r-cr-o:hor20',
  -- }

  -- S: Columns

  -- Line number column
  vim.opt.number = true

  -- Sign column
  vim.opt.signcolumn = 'auto'

  ----------------------------------------------------------------
  --  NOTE:  Autcommands
  ----------------------------------------------------------------

  -- Autosave: on focus lost
  local autocmd_autosave = function()
    vim.api.nvim_create_autocmd('FocusLost', {
      desc = 'Autosave on focus lost',
      pattern = '*',
      command = 'silent! wa',
    })
  end

  -- Highlight: when yanking text
  local autocmd_yank_highlight = function()
    vim.api.nvim_create_autocmd('TextYankPost', {
      desc = 'Highlight when yanking (copying) text',
      group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
      callback = function()
        vim.highlight.on_yank()
      end,
    })
  end

  autocmd_yank_highlight()
  autocmd_autosave()
end

return M
