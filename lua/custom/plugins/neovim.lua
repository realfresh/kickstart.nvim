-- Document existing key chains
local which_key_spec = {
  { '<leader>b', group = '[B]uffers' },
  { '<leader>bd', group = '[D]elete' },
  { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
  { '<leader>g', group = '[G]it' },
  { '<leader>gh', group = '[G]it Hunk' },
  -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
  { '<leader>l', group = '[L]SP' },
  { '<leader>o', group = '[O]ther' },
  { '<leader>p', group = '[P]rojects (sessions)' },
  { '<leader>r', group = '[R]ename' },
  { '<leader>s', group = '[S]earch' },
  { '<leader>t', group = '[T]ab' },
  -- { '<leader>d', group = '[D]ocument' },
  -- { '<leader>w', group = '[W]orkspace' },
}

local color_scheme = 'evergarden' -- 'ayu-dark' 'adwaita' 'kanagawa-wave'

--

return {
  --------------------
  ---    THEMES    ---
  --------------------

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
    'comfysage/evergarden',
    enabled = true,
    priority = 1000,
    opts = {
      -- https://github.com/comfysage/evergarden?tab=readme-ov-file#configuration
      -- transparent_background = true,
      variant = 'hard', -- 'hard'|'medium'|'soft'
      overrides = {}, -- add custom overrides
    },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    enabled = false,
    opts = {
      -- https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
    },
  },
  {
    'Shatur/neovim-ayu',
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      require('ayu').setup {
        -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
        mirage = false,
        -- Set to `false` to let terminal manage its own colors.
        terminal = true,
        -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in he.
        overrides = {},
      }
    end,
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

  -- Theme Switcher
  {
    'zaldih/themery.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('themery').setup {
        livepreview = true,
        themes = {
          'tokyonight-night',
          'tokyonight-moon',
          'kanagawa-wave',
          'kanagawa-lotus',
          'kanagawa-dragon',
          'evergarden-soft',
          'evergarden-medium',
          'evergarden-hard',
          'catppuccin-latte',
          'catppuccin-frappe',
          'catppuccin-macchiato',
          'catppuccin-mocha',
        },
      }
      vim.cmd.colorscheme(color_scheme)
    end,
  },

  ------------------------------------------

  -- Telescope: Fuzzy Finder (files, lsp, etc)
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
  -- Whichkey: Show pending keybinds
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
  -- Legendary: Command palette like
  {
    'mrjones2014/legendary.nvim',
    version = '^v2.13.12',
    -- since legendary.nvim handles all your keymaps/commands,
    -- its recommended to load legendary.nvim before other plugins
    priority = 10000,
    lazy = false,
    -- sqlite needed for frecency sorting
    dependencies = { 'kkharji/sqlite.lua' },
    opts = {
      extensions = {
        lazy_nvim = true,
        nvim_tree = true,
        op_nvim = true,
        diffview = true,
        which_key = {
          -- Automatically add which-key tables to legendary
          -- see WHICH_KEY.md for more details
          auto_register = true,
          -- you can put which-key.nvim tables here,
          -- or alternatively have them auto-register,
          -- see WHICH_KEY.md
          --  mappings = {},
          --  opts = {},
          -- controls whether legendary.nvim actually binds they keymaps,
          -- or if you want to let which-key.nvim handle the bindings.
          -- if not passed, true by default
          --  do_binding = true,
          -- controls whether to use legendary.nvim item groups
          -- matching your which-key.nvim groups; if false, all keymaps
          -- are added at toplevel instead of in a group.
          use_groups = true,
        },
      },
    },
    keys = {
      { '<leader>.', ':Legendary<CR>', desc = '[L]egendary menu' },
    },
  },
  --  Session management
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
  -- Gitsigns: Adds git signs to the gutter and utilities for managing changes
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

  ----------------------
  --- QOL Collection ---
  ----------------------

  -- Mini
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
      -- require('mini.starter').setup {}
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

  --------------------
  --- Lines & Bars ---
  --------------------

  {
    'nanozuki/tabby.nvim',
    -- event = 'VimEnter', -- if you want lazy load, see below
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local colors = require('evergarden').colors()
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
    end,
  },

  -----------------
  --- Overrides ---
  -----------------

  -- Input & Select
  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  --------------
  -- Disabled --
  --------------
  {
    'nvimdev/dashboard-nvim',
    enabled = false,
    event = 'VimEnter',
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
    config = function()
      require('dashboard').setup {
        config = {
          packages = { enable = true }, -- show how many plugins neovim loaded
          shortcut = {
            -- action can be a function type
            -- { desc = string, group = 'highlight group', key = 'shortcut key', action = 'action when you press key' },
            {
              desc = 'Projects',
              group = 'Main',
              key = 'P',
              icon = ' ',
              action = function()
                vim.cmd 'Telescope persisted'
              end,
            },
          },
          -- limit how many projects list, action when you press key or enter it will run this action.
          -- action can be a functino type, e.g.
          -- action = func(path) vim.cmd('Telescope find_files cwd=' .. path) end
          -- project = { enable = true, limit = 8, icon = 'your icon', label = '', action = '' },
          -- mru = { enable = true, limit = 10, icon = 'your icon', label = '', cwd_only = false },
          -- footer = {}, -- footer
        },
      }
    end,
  },

  --[[ {
    'echasnovski/mini.starter',
    version = false,
    event = 'VimEnter',
    lazy = false, -- Important! Make it load immediately
    priority = 1000, -- Give it high priority to load first
    config = function()
      require('mini.starter').setup {}
    end,
  },--]]
}
