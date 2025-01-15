----------------------------------------------------------------
-- NOTE: Utilities
----------------------------------------------------------------

local util_merge_tables_list = function(...)
  local result = {}
  for _, list in ipairs { ... } do
    for _, item in ipairs(list) do
      table.insert(result, item)
    end
  end
  return result
end

local util_merge_tables_kv = function(...)
  local result = {}
  for _, list in ipairs { ... } do
    for key, value in pairs(list) do
      result[key] = value
    end
  end
  return result
end

----------------------------------------------------------------
-- NOTE: Configurations
----------------------------------------------------------------

--  See `:help vim.opt`
--  For more options, you can see `:help option-list`

local function config_main()
  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.opt.mouse = 'a'
  vim.opt.mousescroll = 'ver:3,hor:4'
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
end

local function config_editor()
  -- Enable break indent
  vim.opt.breakindent = true

  -- Save undo history
  vim.opt.undofile = true

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

  -- NOTE: Columns

  -- Make line numbers default
  vim.opt.number = true
  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  -- vim.opt.relativenumber = true

  -- Keep signcolumn on by default
  vim.opt.signcolumn = 'auto'

  -- Enable fold column
  vim.opt.foldcolumn = 'auto'
  -- Set fold level to 99 (effectively expanding all folds)
  vim.opt.foldlevel = 99
  -- Start with all folds expanded
  vim.opt.foldlevelstart = 99
  -- Use nvim-ufo provider
  vim.opt.foldenable = true

  -- vim.opt.foldcolumn = 'auto:1'
  -- vim.opt.signcolumn = 'auto'

  -- vim.opt.fillchars:append {
  --   foldsep = '│', -- Fold separator
  --   foldopen = '^', -- Mark for open folds
  --   foldclose = '>', -- Mark for closed folds
  -- }
end

local function config_keybinds()
  -- See `:help vim.keymap.set()`
  -- Set <space> as the leader key (see `:help mapleader`)
  -- [note] Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

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
  vim.keymap.set('n', '<localleader>w', ':wqa<CR>', { desc = 'Quit All (Write)' })
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

-- Autosave on focus lost
local autocmd_autosave = function()
  vim.api.nvim_create_autocmd('FocusLost', {
    desc = 'Autosave on focus lost',
    pattern = '*',
    command = 'silent! wa',
  })
end

-- Highlight when yanking (copying) text, see `:help vim.highlight.on_yank()`
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

----------------------------------------------------------------
--  NOTE:  Plugin Manager
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

local lazyicons = vim.g.have_nerd_font and {}
  or {
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
  }

----------------------------------------------------------------
--  NOTE:  Plugin Variables
----------------------------------------------------------------

-- Document existing key chains
local which_key_spec = {
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
}

local color_scheme = 'evergarden' -- 'ayu-dark' 'adwaita' 'kanagawa-wave'
local colors_get = function()
  return require('evergarden').colors()
end

-- LSP Servers
-- For help run
--  `:help lspconfig-all`
-- Find LSP servers at:
--  - https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers

local lsp_servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},

  -- NOTE: Scripting

  ansiblels = {
    settings = {},
  },

  bashls = {
    settings = {},
  },

  -- shellcheck

  -- NOTE: Containers & K8s

  dockerls = {
    settings = {},
  },
  docker_compose_language_service = {
    settings = {},
  },
  helm_ls = {
    settings = {},
  },

  -- NOTE: Database

  graphql = {
    settings = {},
  },

  -- NOTE: Formats

  jsonls = {
    settings = {},
  },
  yamlls = {
    settings = {},
  },

  -- NOTE: JS & TS

  eslint = {
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
  },
  vtsls = {
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
  },

  -- NOTE: Lua

  lua_ls = {
    -- cmd = { ... },
    -- filetypes = { ... },
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
}

----------------------------------------------------------------
--  NOTE:  Plugin List
----------------------------------------------------------------

local plugins_overrides = {
  -- Input & Select
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
}
local plugins_qol = {
  -- Session management
  {
    'rmagatti/auto-session',
    lazy = false,
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { '<leader>pr', '<cmd>SessionSearch<CR>', desc = 'Session search' },
      { '<leader>ps', '<cmd>SessionSave<CR>', desc = 'Save session' },
      { '<leader>pa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
    },
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '/', '~/', '~/Downloads' },
      -- log_level = 'debug',
      session_lens = {
        load_on_setup = true, -- Initialize on startup (requires Telescope)
        theme_conf = { -- Pass through for Telescope theme options
          -- layout_config = { -- As one example, can change width/height of picker
          --   width = 0.8,    -- percent of window
          --   height = 0.5,
          -- },
        },
        previewer = false, -- File preview for session picker

        mappings = {
          -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
          delete_session = { 'i', '<C-D>' },
          alternate_session = { 'i', '<C-S>' },
          copy_session = { 'i', '<C-Y>' },
        },

        session_control = {
          control_dir = vim.fn.stdpath 'data' .. '/auto_session/', -- Auto session control dir, for control files, like alternating between two sessions with session-lens
          control_filename = 'session_control.json', -- File name of the session control file
        },
      },
    },
  },

  -- Telescope: Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- Whichkey
  {
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = which_key_spec,
    },
  },
}
local plugins_bundles = {
  -- Mini
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Autoclose pairs
      require('mini.pairs').setup {
        -- In which modes mappings from this `config` should be created
        modes = { insert = true, command = false, terminal = false },
        -- Global mappings. Each right hand side should be a pair information, a
        -- table with at least these fields (see more in |MiniPairs.map|):
        -- - <action> - one of 'open', 'close', 'closeopen'.
        -- - <pair> - two character string for pair to be used.
        -- By default pair is not inserted after `\`, quotes are not recognized by
        -- `<CR>`, `'` does not insert pair after a letter.
        -- Only parts of tables can be tweaked (others will use these defaults).
        mappings = {
          ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
          ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
          ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

          [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
          [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
          ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

          ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
          ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
          ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
        },
      }

      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()
    end,
  },

  -- Snacks
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      input = { enabled = false },
      quickfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = false },
      bigfile = { enabled = false },
      -- Enabled
      bufdelete = { enabled = true },
      debug = { enabled = true },
      lazygit = { enabled = true },
      ---@class snacks.scroll.Config
      ---@field animate snacks.animate.Config
      scroll = {
        spamming = 10, -- threshold for spamming detection
        animate = {
          duration = { step = 10, total = 250 },
          easing = 'outSine',
        },
      },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      toggle = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        },
      },
    },
    keys = {
      --[[
      {
        '<leader>.',
        desc = 'Toggle Scratch Buffer',
        function()
          Snacks.scratch()
        end,
      },
      {
        '<leader>S',
        desc = 'Select Scratch Buffer',
        function()
          Snacks.scratch.select()
        end,
      },
      --]]
      -- Notifications
      {
        '<leader>nh',
        desc = 'Notification History',
        function()
          Snacks.notifier.show_history()
        end,
      },
      {
        '<leader>nd',
        desc = 'Dismiss All Notifications',
        function()
          Snacks.notifier.hide()
        end,
      },
      {
        '<leader>nN',
        desc = 'Neovim News',
        function()
          Snacks.win {
            file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = 'yes',
              statuscolumn = ' ',
              conceallevel = 3,
            },
          }
        end,
      },
      -- Buffer
      {
        '<leader>bdc',
        desc = 'Delete Current Buffer',
        function()
          Snacks.bufdelete()
        end,
      },
      {
        '<leader>bda',
        desc = 'Delete All Buffers',
        function()
          Snacks.bufdelete.all()
        end,
      },
      {
        '<leader>bdo',
        desc = 'Delete Other Buffers',
        function()
          Snacks.bufdelete.other()
        end,
      },
      -- Rename
      {
        '<leader>rf',
        desc = 'Rename File',
        function()
          Snacks.rename.rename_file()
        end,
      },
      -- Git
      {
        '<leader>gb',
        desc = 'Git Browse',
        mode = { 'n', 'v' },
        function()
          Snacks.gitbrowse()
        end,
      },
      {
        '<leader>gB',
        desc = 'Git Blame',
        function()
          Snacks.git.blame_line()
        end,
      },
      {
        '<leader>gf',
        desc = 'Lazygit Current File History',
        function()
          Snacks.lazygit.log_file()
        end,
      },
      {
        '<leader>gg',
        desc = 'Lazygit',
        function()
          Snacks.lazygit()
        end,
      },
      {
        '<leader>gl',
        desc = 'Lazygit Log (cwd)',
        function()
          Snacks.lazygit.log()
        end,
      },
      -- Other
      {
        '<leader>ot',
        desc = 'Toggle Terminal',
        function()
          Snacks.terminal()
        end,
      },
      {
        '<leader>oi',
        desc = 'Which Key Ignore',
        function()
          Snacks.terminal()
        end,
      },
      -- Words
      {
        ']]',
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = 'Next Reference',
        mode = { 'n', 't' },
      },
      {
        '[[',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          local Snacks = require 'snacks'
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
          Snacks.toggle.diagnostics():map '<leader>ud'
          Snacks.toggle.line_number():map '<leader>ul'
          Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
          Snacks.toggle.treesitter():map '<leader>uT'
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
          Snacks.toggle.inlay_hints():map '<leader>uh'
          Snacks.toggle.indent():map '<leader>ug'
          Snacks.toggle.dim():map '<leader>uD'
        end,
      })
    end,
  },
}
local plugins_themes = {
  {
    'rebelot/kanagawa.nvim',
    enabled = false,
    priority = 1000,
    config = function()
      local dragon_colors = require('kanagawa.colors').setup { theme = 'dragon' }

      -- vim.cmd.hi 'Comment gui=none'

      -- bg_dim     = palette.dragonBlack1,
      -- bg_gutter  = palette.dragonBlack4,

      dragon_colors.theme.ui.bg_gutter = 'none'
      -- dragon_colors.theme.ui.bg_dim = 'green'
      -- dragon_colors.theme.ui.bg_m3 = 'green'
      -- dragon_colors.theme.ui.bg_m2 = 'blue'
      -- dragon_colors.theme.ui.bg_m1 = 'red'
      -- dragon_colors.theme.ui.bg = 'black'
      -- dragon_colors.theme.ui.bg_p1 = 'blue' -- other
      -- dragon_colors.theme.ui.bg_p2 = 'red' -- highlight

      require('kanagawa').setup {
        -- https://github.com/rebelot/kanagawa.nvim?tab=readme-ov-file#configuration
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = {
          italic = false,
        },
        functionStyle = {},
        keywordStyle = {
          italic = false,
        },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {
              ui = dragon_colors.theme.ui,
              vcs = dragon_colors.theme.vcs,
              diff = dragon_colors.theme.diff,
              diag = dragon_colors.theme.diag,
              term = dragon_colors.theme.term,
              -- ui = {
              --  bg_m3 = dragon_colors.theme.ui.bg_m3,
              --  bg_m2 = dragon_colors.theme.ui.bg_m2,
              --  bg_m1 = dragon_colors.theme.ui.bg_m1,
              --  bg = dragon_colors.theme.ui.bg,
              --  bg_p1 = dragon_colors.theme.ui.bg_p1,
              --  bg_p2 = dragon_colors.theme.ui.bg_p2,
              -- },
            },
            lotus = {},
            dragon = {},
            all = {
              ui = {
                -- bg_gutter = 'none',
              },
            },
          },
        },
        overrides = function(colors) -- add/modify highlights
          return {}
        end,
        theme = 'wave',
        background = {
          dark = 'wave',
          light = 'lotus',
        },
      }
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    enabled = false,
    opts = {},
  },
  {
    'folke/tokyonight.nvim',
    enabled = true,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'tokyonight-night'
      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'comfysage/evergarden',
    enabled = true,
    priority = 1000,
    config = function()
      require('evergarden').setup {
        -- https://github.com/comfysage/evergarden?tab=readme-ov-file#configuration
        -- transparent_background = true,
        variant = 'hard', -- 'hard'|'medium'|'soft'
        overrides = {}, -- add custom overrides
      }

      vim.cmd 'colorscheme evergarden'

      -- local colors = colors_get()
      -- vim.cmd [[
      --   highlight NormalCursor guifg=#FFFFFF guibg=#5F87AF
      --   highlight InsertCursor guifg=#FFFFFF guibg=#87AF87
      -- ]]
    end,
  },
}
local plugins_bars = {
  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local colors = colors_get()
      local theme = require 'lualine.themes.auto'

      -- Colors: normal
      theme.normal.b.bg = colors.surface1
      theme.normal.b.fg = colors.text
      theme.normal.c.bg = colors.base

      -- Colors: insert
      -- theme.insert.b.bg = colors.surface1
      theme.insert.b.fg = colors.text
      -- theme.insert.c.bg = colors.base

      -- Colors: visual
      theme.visual.b.bg = colors.surface1
      theme.visual.b.fg = colors.text
      -- theme.visual.c.bg = colors.base

      require('lualine').setup {
        options = {
          theme = theme,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
      }
    end,
  },

  -- Tabline
  {
    'nanozuki/tabby.nvim',
    event = 'VimEnter', -- if you want lazy load, see below
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local colors = colors_get()
      local theme = {
        fill = { fg = colors.text, bg = colors.base },
        head = { fg = colors.text, bg = colors.surface1, style = 'bold' },
        current_tab = { fg = colors.text, bg = colors.overlay0, style = 'bold' },
        tab = { fg = colors.text, bg = colors.surface0 },
        win = { fg = colors.text, bg = colors.surface0 },
        tail = { fg = colors.text, bg = colors.surface0 },
      }
      require('tabby').setup {
        line = function(line)
          return {
            {
              { '  ', hl = theme.head },
              -- line.sep('', theme.head, theme.fill),
              line.sep(' ', theme.head, theme.fill),
            },
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.tab
              return {
                -- line.sep('', hl, theme.fill),
                line.sep('', hl, theme.fill),
                tab.is_current() and '' or '󰆣',
                tab.number(),
                tab.name(),
                tab.close_btn '',
                line.sep('', hl, theme.fill),
                -- line.sep('', hl, theme.fill),
                hl = hl,
                margin = ' ',
              }
            end),
            line.spacer(),
            {
              -- line.sep('', theme.tail, theme.fill),
              { '  ', hl = theme.tail },
            },
            hl = theme.fill,
          }
        end,
        -- option = {}, -- setup modules' option,
      }
      require 'tabby'
    end,
    keys = {
      { '<leader>tn', mode = 'n', desc = 'Tab: New', ':$tabnew<CR>' },
      { '<leader>tc', mode = 'n', desc = 'Tab: Close', ':tabclose<CR>' },
      { '<leader>to', mode = 'n', desc = 'Tab: Only', ':tabonly<CR>' },
      { '<leader>tf', mode = 'n', desc = 'Tab: Go Forward', ':tabn<CR>' },
      { '<leader>tb', mode = 'n', desc = 'Tab: Go Backward', ':tabp<CR>' },
      { '<leader>t-', mode = 'n', desc = 'Tab: Move Backward', ':-tabmove<CR>' },
      { '<leader>t=', mode = 'n', desc = 'Tab: Move Forward', ':+tabmove<CR>' },
      {
        '<leader>tr',
        mode = 'n',
        desc = 'Tab: Rename',
        function()
          Snacks.input({ prompt = 'Tab Name:' }, function(v)
            require('tabby').tab_rename(v)
          end)
        end,
      },
    },
  },

  -- Menu
  {
    'nvzone/volt',
    lazy = true,
  },
  {
    'nvzone/menu',
    lazy = true,
    config = function() end,
    keys = {
      {
        '<C-RightMouse>',
        mode = { 'n', 'v' },
        function()
          require('menu.utils').delete_old_menus()

          vim.cmd.exec '"normal! \\<RightMouse>"'

          -- clicked buf
          local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
          local options = vim.bo[buf].ft == 'NvimTree' and 'nvimtree' or 'default'
          print(vim.bo[buf].ft)

          require('menu').open(options, { mouse = true })
        end,
      },
    },
  },
}

local plugins_editor = {
  -- Detect tabstop and shiftwidth
  'tpope/vim-sleuth',

  -- Main window padding
  {
    'shortcuts/no-neck-pain.nvim',
    dependencies = { 'folke/snacks.nvim' },
    lazy = false,
    config = function()
      require('no-neck-pain').setup {
        width = 120,
        autocmds = {
          enableOnVimEnter = true,
          enableOnTabEnter = true,
        },
        integrations = {
          Nvimtree = {
            reopen = true,
            position = 'left',
          },
        },
      }

      -- print 'No Neck Pain loaded'
      -- Snacks.notify 'No Neck Pain loaded'
      -- vim.cmd ':NoNeckPain<CR>'
    end,
    keys = {
      { '<leader>ept', ':NoNeckPain<CR>', desc = 'Toggle Padding (No Neck Pain)' },
      { '<leader>epl', ':NoNeckPainToggleLeftSide<CR>', desc = 'Toggle Padding Left (No Neck Pain)' },
      { '<leader>epr', ':NoNeckPainToggleRightSide<CR>', desc = 'Toggle Padding Right (No Neck Pain)' },
      { '<leader>epm', ':NoNeckPainWidthDown<CR>', desc = 'Increase Padding (No Neck Pain)' },
      { '<leader>epl', ':NoNeckPainWidthUp<CR>', desc = 'Decrease Padding (No Neck Pain)' },
    },
  },

  -- Comments: Line & Block
  {
    'numToStr/Comment.nvim',
    opts = {},
  },

  -- Comments: Highlighting
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      keywords = {
        FIX = {
          icon = ' ', -- icon used for the sign, and in search results
          color = 'error', -- can be a hex color, or a named color (see below)
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE', '!!' }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = ' ', color = 'info' },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
        S = { icon = '@', color = 'default', alt = {} },
        -- ['!'] = { icon = '!', color = 'default', alt = {} },
      },
      gui_style = {
        fg = 'BOLD', -- The gui style to use for the fg highlight group.
        bg = 'BOLD', -- The gui style to use for the bg highlight group.
      },
      colors = {
        error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
        warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
        info = { 'DiagnosticInfo', '#2563EB' },
        hint = { 'DiagnosticHint', '#10B981' },
        default = { 'Identifier', '#7C3AED' },
        test = { 'Identifier', '#FF00FF' },
      },
      -- FIX: asdasdasd
      -- ISSUE:
      -- TODO:
      -- HACK:
      -- WARN:
      -- PERF:
      -- TEST:
      -- NOTE:
      -- S: asdasd
    },
  },

  -- Multicursors
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local set = vim.keymap.set
      local mc = require 'multicursor-nvim'

      mc.setup()

      -- Add or skip cursor above/below the main cursor.
      -- set({ 'n', 'v' }, '<up>', function()
      --   mc.lineAddCursor(-1)
      -- end)
      -- set({ 'n', 'v' }, '<down>', function()
      --   mc.lineAddCursor(1)
      -- end)
      -- set({ 'n', 'v' }, '<leader><up>', function()
      --   mc.lineSkipCursor(-1)
      -- end)
      -- set({ 'n', 'v' }, '<leader><down>', function()
      --   mc.lineSkipCursor(1)
      -- end)

      -- Add or skip adding a new cursor by matching word/selection
      -- set({ 'n', 'v' }, '<leader>n', function()
      --   mc.matchAddCursor(1)
      -- end)
      -- set({ 'n', 'v' }, '<leader>s', function()
      --   mc.matchSkipCursor(1)
      -- end)
      -- set({ 'n', 'v' }, '<leader>N', function()
      --   mc.matchAddCursor(-1)
      -- end)
      -- set({ 'n', 'v' }, '<leader>S', function()
      --   mc.matchSkipCursor(-1)
      -- end)

      -- Add all matches in the document
      set({ 'n', 'v' }, '<leader>cca', mc.matchAllAddCursors, { desc = 'Cursor: Add all matches' })

      -- You can also add cursors with any motion you prefer:
      -- set("n", "<right>", function()
      --     mc.addCursor("w")
      -- end)
      -- set("n", "<leader><right>", function()
      --     mc.skipCursor("w")
      -- end)

      -- Rotate the main cursor.

      set({ 'n', 'v' }, '<leader>cc<left>', mc.nextCursor, { desc = 'Cursor: Rotate left' })
      set({ 'n', 'v' }, '<leader>cc<right>', mc.prevCursor, { desc = 'Cursor: Rotate right' })

      -- Delete the main cursor.
      set({ 'n', 'v' }, '<leader>ccx', mc.deleteCursor, { desc = 'Cursor: Delete' })

      -- Add and remove cursors with control + left click.
      set('n', '<c-leftmouse>', mc.handleMouse, { desc = 'Cursor: Set With Mouse' })

      -- Easy way to add and remove cursors using the main cursor.
      set({ 'n', 'v' }, '<c-q>', mc.toggleCursor, { desc = 'Cursor: Toggle' })

      -- Clone every cursor and disable the originals.
      set({ 'n', 'v' }, '<leader>ccd', mc.duplicateCursors, { desc = 'Cursor: Duplicate' })

      -- Enable curosrs or clear all cursors
      set('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          return '<esc>'
        end
      end, { remap = true })

      -- bring back cursors if you accidentally clear them
      set('n', '<leader>ccv', mc.restoreCursors)

      -- Align cursor columns.
      set('n', '<leader>cca', mc.alignCursors)

      -- Split visual selections by regex.
      set('v', '<leader>ccs', mc.splitCursors)

      -- Append/insert for each line of visual selections.
      set('v', 'I', mc.insertVisual)
      set('v', 'A', mc.appendVisual)

      -- match new cursors within visual selections by regex.
      set('v', 'M', mc.matchCursors)

      -- Rotate visual selection contents.
      set('v', '<leader>cct', function()
        mc.transposeCursors(1)
      end, { desc = 'Cursor: Transpose (1)' })
      set('v', '<leader>ccT', function()
        mc.transposeCursors(-1)
      end, { desc = 'Cursor: Transpose (-1)' })

      -- Jumplist support
      set({ 'v', 'n' }, '<c-i>', mc.jumpForward)
      set({ 'v', 'n' }, '<c-o>', mc.jumpBackward)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, 'MultiCursorCursor', { link = 'Cursor' })
      hl(0, 'MultiCursorVisual', { link = 'Visual' })
      hl(0, 'MultiCursorSign', { link = 'SignColumn' })
      hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
    end,
  },

  -- Navigation
  {
    'ggandor/leap.nvim',
    lazy = false,
    dependencies = { 'tpope/vim-repeat' },
    config = function()
      -- require('leap').create_default_mappings()
      vim.keymap.set({ 'n', 'x', 'o' }, 'gl', '<Plug>(leap-forward)', { desc = 'Leap: Forward' })
      vim.keymap.set({ 'n', 'x', 'o' }, 'gL', '<Plug>(leap-backward)', { desc = 'Leap: Backward' })
      vim.keymap.set({ 'n', 'x', 'o' }, 'gW', '<Plug>(leap-from-window)', { desc = 'Leap: From Window' })
    end,
  },
}
local plugins_editor_navigation = {
  -- Jumplists & Bookmarks
  {
    'otavioschwanck/arrow.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      -- or if using `mini.icons`
      -- { "echasnovski/mini.icons" },
    },
    opts = {
      show_icons = true,
      leader_key = ';', -- Recommended to be a single key
      buffer_leader_key = 'm', -- Per Buffer Mappings
    },
  },

  -- Buffers, Marks, Jumps
  {
    'gcmt/vessel.nvim',
    config = function()
      require('vessel').setup {
        create_commands = true,
        commands = { -- not required unless you want to customize each command name
          view_marks = 'Marks',
          view_jumps = 'Jumps',
          view_buffers = 'Buffers',
        },
      }
      local vessel = require 'vessel'
      vessel.opt.buffers.view = 'tree'
    end,
  },

  -- Files: NvimTree
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      {
        '<leader>1',
        desc = 'NvimTree',
        -- ':NvimTreeOpen<CR>'
        function()
          local nvimtree = require 'nvim-tree.api'
          nvimtree.tree.toggle()
        end,
      },
    },
    config = function()
      require('nvim-tree').setup {}
    end,
  },

  -- Files: NeoTree
  {
    'nvim-neo-tree/neo-tree.nvim',
    enabled = false,
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      { '<leader>e', ':Neotree<CR>', desc = 'Neotree' },
    },
  },

  -- Files: Oil
  {
    'stevearc/oil.nvim',
    enabled = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      -- Id is automatically added at the beginning, and name at the end
      -- See :help oil-columns
      columns = {
        'icon',
        -- "permissions",
        -- "size",
        -- "mtime",
      },
      -- Buffer-local options to use for oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = 'hide',
      },
      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = 'no',
        cursorcolumn = false,
        foldcolumn = '0',
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = 'nvic',
      },
      -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
      delete_to_trash = false,
      -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
      skip_confirm_for_simple_edits = false,
      -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
      -- (:help prompt_save_on_select_new_entry)
      prompt_save_on_select_new_entry = true,
      -- Oil will automatically delete hidden buffers after this delay
      -- You can set the delay to false to disable cleanup entirely
      -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
      cleanup_delay_ms = 2000,
      lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = true,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
      },
      -- Constrain the cursor to the editable parts of the oil buffer
      -- Set to `false` to disable, or "name" to keep it on the file names
      constrain_cursor = 'editable',
      -- Set to true to watch the filesystem for changes and reload oil
      watch_for_changes = false,
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      -- See :help oil-actions for a list of all available actions
      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          local m = name:match '^%.'
          return m ~= nil
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return false
        end,
        -- Sort file names with numbers in a more intuitive order for humans.
        -- Can be "fast", true, or false. "fast" will turn it off for large directories.
        natural_order = 'fast',
        -- Sort file and directory names case insensitive
        case_insensitive = false,
        sort = {
          -- sort order can be "asc" or "desc"
          -- see :help oil-columns to see which columns are sortable
          { 'type', 'asc' },
          { 'name', 'asc' },
        },
        -- Customize the highlight group for the file name
        highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
          return nil
        end,
      },
      -- Extra arguments to pass to SCP when moving/copying files over SSH
      extra_scp_args = {},
      -- EXPERIMENTAL support for performing file operations with git
      git = {
        -- Return true to automatically git add/mv/rm files
        add = function(path)
          return false
        end,
        mv = function(src_path, dest_path)
          return false
        end,
        rm = function(path)
          return false
        end,
      },
      -- Configuration for the floating window in oil.open_float
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
        -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
        get_win_title = nil,
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = 'auto',
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },
      -- Configuration for the file preview window
      preview_win = {
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
        -- How to open the preview window "load"|"scratch"|"fast_scratch"
        preview_method = 'fast_scratch',
        -- A function that returns true to disable preview on a file e.g. to avoid lag
        disable_preview = function(filename)
          return false
        end,
        -- Window-local options to use for preview window buffers
        win_options = {},
      },
      -- Configuration for the floating action confirmation window
      confirmation = {
        -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a single value or a list of mixed integer/float types.
        -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
        max_width = 0.9,
        -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
        min_width = { 40, 0.4 },
        -- optionally define an integer/float for the exact width of the preview window
        width = nil,
        -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a single value or a list of mixed integer/float types.
        -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
        max_height = 0.9,
        -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
        min_height = { 5, 0.1 },
        -- optionally define an integer/float for the exact height of the preview window
        height = nil,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
      },
      -- Configuration for the floating progress window
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = 'rounded',
        minimized_border = 'none',
        win_options = {
          winblend = 0,
        },
      },
      -- Configuration for the floating SSH window
      ssh = {
        border = 'rounded',
      },
      -- Configuration for the floating keymaps help window
      keymaps_help = {
        border = 'rounded',
      },
    },
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
}
local plugins_editor_indicators = {
  -- Gitsigns
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged_enable = true,
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end)

        -- Keybinds
        map('n', '<leader>ghp', gitsigns.preview_hunk)

        vim.cmd [[
          highlight GitSignsAdd    guifg=green        guibg=NONE
          highlight GitSignsChange guifg=darkyellow   guibg=NONE
          highlight GitSignsDelete guifg=red          guibg=NONE
        ]]

        --[[
        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end)
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end)
        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hu', gitsigns.undo_stage_hunk)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hb', function()
          gitsigns.blame_line { full = true }
        end)
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>hd', gitsigns.diffthis)
        map('n', '<leader>hD', function()
          gitsigns.diffthis '~'
        end)
        map('n', '<leader>td', gitsigns.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        --]]
      end,
    },
  },
}
local plugins_editor_languages = {
  -- S: Editor: Formatting

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  -- S: Editor: Treesitter

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'apple/pkl-neovim' },
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'pkl',
        'query',
        'vim',
        'vimdoc',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- S: Editor: Folding

  {
    'kevinhwang91/nvim-ufo',
    enabled = true,
    dependencies = {
      'kevinhwang91/promise-async',
      'nvim-treesitter/nvim-treesitter',
      'neovim/nvim-lspconfig',
    },
    config = function()
      -- Using ufo provider need remap `zR` and `zM`
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
      vim.keymap.set('n', 'K', function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
          -- choose one of coc.nvim and nvim lsp
          vim.fn.CocActionAsync 'definitionHover' -- coc.nvim
          vim.lsp.buf.hover()
        end
      end)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local language_servers = require('lspconfig').util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
      for _, ls in ipairs(language_servers) do
        require('lspconfig')[ls].setup {
          capabilities = capabilities,
          -- you can add other fields for setting up lsp server in this table
        }
      end

      local ufo = require 'ufo'

      -- Configure UFO
      ufo.setup {
        open_fold_hl_timeout = 400,
        close_fold_kinds_for_ft = {},
        enable_get_fold_virt_text = false,
        preview = {
          win_config = {
            border = 'rounded',
            winblend = 12,
            winhighlight = 'Normal:Normal',
            maxheight = 20,
          },
        },
        enable_fold_indicator = false,
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      }
    end,
  },

  -- S: Editor: Language Servers

  -- Neovim
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = '"/Users/reemus/.hammerspoon/Spoons/EmmyLua.spoon/annotations', words = { 'hs' } },
      },
    },
  },
  {
    'Bilal2453/luvit-meta',
    lazy = true,
  },

  -- All Languages
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- [note] Mason must be loaded before dependants
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      --   [note] `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>ld', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>lsd', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>lsw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>lt', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      -- if vim.g.have_nerd_font then
      --   local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
      --   local diagnostic_signs = {}
      --   for type, icon in pairs(signs) do
      --     diagnostic_signs[vim.diagnostic.severity[type]] = icon
      --   end
      --   vim.diagnostic.config { signs = { text = diagnostic_signs } }
      -- end

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- Mason Tool Installer: Get the list of names for LSP servers to install
      local mason_tools_lsp = vim.tbl_keys(lsp_servers or {})

      -- Mason Tool Installer: Add any additional tools you want to install
      local mason_tools = vim.list_extend(mason_tools_lsp, {
        'stylua', -- Used to format Lua code
      })

      require('mason-tool-installer').setup {
        ensure_installed = mason_tools,
      }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = lsp_servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- S: Editor: AI

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-CR>',
          },
          layout = {
            position = 'bottom', -- | top | left | right | horizontal | vertical
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = '<C-CR>',
            accept_word = false,
            accept_line = false,
            next = '<C-d>',
            prev = '<C-u>',
            dismiss = '<C-Space>',
          },
        },
        filetypes = {
          -- yaml = false,
          -- markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ['.'] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {
          settings = {
            advanced = {
              listCount = 5,
              inlineSuggestCount = 3,
            },
          },
        },
      }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    dependencies = { 'zbirenbaum/copilot.lua' },
    config = function()
      require('copilot_cmp').setup()
    end,
  },

  -- S: Editor: Autocompletion

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Close completion when you hit <esc>
          ['<Esc>'] = cmp.mapping.close(),
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<tab>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          -- { name = 'copilot' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
}

local plugins_list = util_merge_tables_list(
  plugins_overrides,
  plugins_qol,
  plugins_bundles,
  plugins_themes,
  plugins_bars,
  plugins_editor,
  plugins_editor_navigation,
  plugins_editor_indicators,
  plugins_editor_languages
)

require('lazy').setup(plugins_list, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = lazyicons,
  },
})

----------------------------
--> Plugin Notes
----------------------------

-- Useful plugin configs including in the Kickstart repo
--   See `kickstart.plugins.<file>` for more information
--   -> 'debug',
--   -> 'indent_line',
--   -> 'lint',
--   -> 'autopairs',
--   -> 'neo-tree',
--   -> 'gitsigns', -- adds gitsigns recommend keymaps

-- Autoloading all *.lua files from `lua/custom/plugins/*.lua`
-- { import = 'custom.plugins' },
-- { import = 'custom.plugins.<filename>' },

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
