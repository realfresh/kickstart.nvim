local C = require 'config'
local KM = require '3_keymaps'
local U = require 'utils'

-- S: Things To Install

-- Find LSP servers at:
-- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
--
-- Find list of tools available via Mason Tool Installer:
-- `:Mason`

-- Tools to install via Mason (with their LSP config)
local mason_tools_lsp = {
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

-- Extra tools to install via Mason (no config required)
local mason_tools_extra = {
  'ansible-lint',
  'cspell',
  'eslint_d',
  'goimports',
  'prettierd',
  'shellcheck',
  'shfmt',
  'stylua',
}

local mason_tools_lsp_keys = vim.tbl_keys(mason_tools_lsp or {})
local mason_tools_keys = vim.list_extend(mason_tools_lsp_keys, mason_tools_extra)

-- S: LSP

-- Disable "format_on_save lsp_fallback" for languages that don't
-- have a well standardized coding style. You can add additional
-- languages here or re-enable it for the disabled ones.
local lsp_format_on_save_disable = {
  c = true,
  cpp = true,
  javascript = true,
  typescript = true,
  json = true,
}

-- S: Formatting

local formatters_by_ft = {
  -- Conform will run multiple formatters sequentially
  -- You can also customize some of the format options for the filetype
  -- You can use 'stop_after_first' to run the first available formatter from the list
  lua = { 'stylua' },
  go = { 'goimports', 'gofmt' },
  rust = { 'rustfmt', lsp_format = 'fallback' },
  bash = { 'shfmt', lsp_format = 'fallback' },
  -- Web
  css = { 'prettierd', 'prettier', stop_after_first = true },
  scss = { 'prettierd', 'prettier', stop_after_first = true },
  less = { 'prettierd', 'prettier', stop_after_first = true },
  html = { 'prettierd', 'prettier', stop_after_first = true },
  -- Config
  json = { 'prettierd', 'prettier', stop_after_first = true },
  jsonc = { 'prettierd', 'prettier', stop_after_first = true },
  yaml = { 'prettierd', 'prettier', stop_after_first = true },
  -- Documentation
  markdown = { 'prettierd', 'prettier', stop_after_first = true },
  -- Typescript / Javascript
  javascript = { 'prettierd', 'prettier', stop_after_first = true },
  typescript = { 'prettierd', 'prettier', stop_after_first = true },
  javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
  typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
  -- Database
  graphql = { 'prettierd', 'prettier', stop_after_first = true },
}

local M = {}

M.setup = function()
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
      dependencies = {},
      keys = {
        -- Will use Telescope if installed or a vim.ui.select picker otherwise
        { '<leader>pr', '<cmd>SessionSearch<CR>', desc = 'Session search' },
        { '<leader>ps', '<cmd>SessionSave<CR>', desc = 'Save session' },
        { '<leader>pa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
      },
      ---enables autocomplete for opts
      ---@module "auto-session"
      ---@type function|AutoSession.Config
      opts = function()
        local pre_save_cmds = {}
        local post_save_cmds = {}
        local post_restore_cmds = {}

        -- No Neck Pain integration
        if U.plugin_enabled 'no-neck-pain' then
          table.insert(pre_save_cmds, function()
            -- Remove empty side buffers before saving session
            ---> check if `state` table exists and if `state.enabled` is true
            local nnp = require 'no-neck-pain'
            if nnp and nnp.state and nnp.state.enabled then
              C.sessions.pre_save_nnp_disabled = true
              nnp.disable()
            end
          end)

          table.insert(post_save_cmds, function()
            -- Restore empty side buffers after saving session
            if C.sessions.pre_save_nnp_disabled then
              C.sessions.pre_save_nnp_disabled = false
              local nnp = require 'no-neck-pain'
              nnp.enable()
            end
          end)

          -- table.insert(post_restore_cmds, function()
          --   -- Enable No Neck Pain after restoring session
          --   local nnp = require 'no-neck-pain'
          --   nnp.enable()
          -- end)
        end

        return {
          enabled = true, -- Enables/disables auto creating, saving and restoring
          auto_save = true, -- Enables/disables auto saving session on exit
          auto_restore = true, -- Enables/disables auto restoring session on start
          auto_create = true, -- Enables/disables auto creating new session files. Can take a function that should return true/false if a new session file should be created or not
          continue_restore_on_error = true, -- Keep loading the session even if there's an error
          show_auto_restore_notif = true, -- Whether to show a notification when auto-restoring
          suppressed_dirs = { '/', '~/', '~/Downloads' },
          close_unsupported_windows = true,
          -- Avoid issues with session saving and plugins that don't like it
          -- See: https://github.com/shortcuts/no-neck-pain.nvim/issues/221#issuecomment-1986951083
          bypass_session_save_file_types = {
            '',
            'no-neck-pain',
            'neo-tree',
            'noice',
            'notify',
            'fugitive',
            'neotest-summary',
          },
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
          -- [Hooks]
          pre_save_cmds = pre_save_cmds,
          post_save_cmds = post_save_cmds,
          post_restore_cmds = post_restore_cmds,
        }
      end,
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
        -- See `:help telescope` and b :help telescope.setup()`
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
          pickers = {
            colorscheme = {
              enable_preview = true,
            },
          },
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
        spec = KM.config.wk_legend,
      },
    },

    -- Main window padding
    {
      'shortcuts/no-neck-pain.nvim',
      enabled = C.plugins.no_neck_pain,
      lazy = false,
      opts = {
        width = 130,
        autocmds = {
          -- enableOnVimEnter = true,
          enableOnTabEnter = true,
        },
        buffers = {
          colors = {
            -- blend = 0.2,
          },
          wo = {
            wrap = false,
          },
        },
        integrations = {
          Nvimtree = {
            reopen = true,
            position = 'left',
          },
        },
      },
      keys = {
        { '<leader>ept', ':NoNeckPain<CR>', desc = 'Toggle Padding (No Neck Pain)' },
        { '<leader>epl', ':NoNeckPainToggleLeftSide<CR>', desc = 'Toggle Padding Left (No Neck Pain)' },
        { '<leader>epr', ':NoNeckPainToggleRightSide<CR>', desc = 'Toggle Padding Right (No Neck Pain)' },
        { '<leader>ep-', ':NoNeckPainWidthDown<CR>', desc = 'Less Padding (No Neck Pain)' },
        { '<leader>ep=', ':NoNeckPainWidthUp<CR>', desc = 'More Padding (No Neck Pain)' },
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
        -- scroll = {
        --   spamming = 10, -- threshold for spamming detection
        --   animate = { duration = { step = 10, total = 250 }, easing = 'outSine' },
        -- },
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
          style = {
            types = {},
            keyword = { 'bold' },
            comment = {},
            tabline = { 'reverse' },
            search = { 'italic' },
            incsearch = { 'reverse' },
            sign = { highlight = false },
          },
          overrides = {
            -- #0b1115 - dark
            -- #10161a - medium
            Normal = { bg = C.colors.custom.bg, fg = C.colors.evergarden.text },
            -- Keyword = {
            --   -- fg = '#ce96de',
            --   -- bg = '#ae45be',
            -- },
          },
        }

        vim.cmd 'colorscheme evergarden'

        -- local colors = colors_get()
        -- vim.cmd [[
        --   highlight NormalCursor guifg=#FFFFFF guibg=#5F87AF
        --   highlight InsertCursor guifg=#FFFFFF guibg=#87AF87
        -- ]]
      end,
    },

    { 'marko-cerovac/material.nvim' },
    { 'ramojus/mellifluous.nvim' },
    { 'rose-pine/neovim', name = 'rose-pine' },
    { 'vague2k/vague.nvim' },
  }

  local plugins_bars = {
    -- Statusline
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        local colors = C.colors.evergarden
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
        local colors = C.colors.evergarden
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
        formatters_by_ft = formatters_by_ft,
        notify_on_error = false,
        format_on_save = function(bufnr)
          local lsp_format_opt
          if lsp_format_on_save_disable[vim.bo[bufnr].filetype] then
            lsp_format_opt = 'never'
          else
            lsp_format_opt = 'fallback'
          end
          return {
            timeout_ms = 500,
            lsp_format = lsp_format_opt,
          }
        end,
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
      enabled = C.plugins.ufo,
      dependencies = {
        'kevinhwang91/promise-async',
        'nvim-treesitter/nvim-treesitter',
        'neovim/nvim-lspconfig',
      },
      config = function()
        local ufo = require 'ufo'
        local ufo_default_providers = { 'treesitter', 'indent' }

        -- Using ufo provider need remap `zR` and `zM`
        vim.keymap.set('n', 'zR', ufo.openAllFolds)
        vim.keymap.set('n', 'zM', ufo.closeAllFolds)
        vim.keymap.set('n', 'zm', ufo.closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

        -- LSP Hover configured here to handle folded lines
        vim.keymap.set('n', 'K', function()
          local winid = ufo.peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end)

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
            return ufo_default_providers
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

        require('mason-tool-installer').setup {
          ensure_installed = mason_tools_keys,
        }

        ---@diagnostic disable-next-line: missing-fields
        require('mason-lspconfig').setup {
          -- automatic_installation = true,
          -- ensure_installed = mason_tools_lsp_keys,
          handlers = {
            function(server_name)
              local server = mason_tools_lsp[server_name] or {}
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

    -- S: Enhancements

    -- Trouble
    {
      'folke/trouble.nvim',
      opts = {},
      cmd = 'Trouble',
      keys = {
        {
          '<leader>xx',
          '<cmd>Trouble diagnostics toggle<cr>',
          desc = 'Diagnostics (Trouble)',
        },
        {
          '<leader>xX',
          '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
          desc = 'Buffer Diagnostics (Trouble)',
        },
        {
          '<leader>cs',
          '<cmd>Trouble symbols toggle focus=false<cr>',
          desc = 'Symbols (Trouble)',
        },
        {
          '<leader>cl',
          '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
          desc = 'LSP Definitions / references / ... (Trouble)',
        },
        {
          '<leader>xL',
          '<cmd>Trouble loclist toggle<cr>',
          desc = 'Location List (Trouble)',
        },
        {
          '<leader>xQ',
          '<cmd>Trouble qflist toggle<cr>',
          desc = 'Quickfix List (Trouble)',
        },
      },
    },
    -- LSP Hover

    {
      'lewis6991/hover.nvim',
      dependenceis = {
        'kevinhwang91/nvim-ufo',
      },
      config = function()
        require('hover').setup {
          init = function()
            -- Require providers
            require 'hover.providers.lsp'
            -- require('hover.providers.gh')
            -- require('hover.providers.gh_user')
            -- require('hover.providers.jira')
            -- require('hover.providers.dap')
            -- require('hover.providers.fold_preview')
            -- require('hover.providers.diagnostic')
            -- require('hover.providers.man')
            -- require('hover.providers.dictionary')
          end,
          preview_opts = {
            border = 'single',
          },
          -- Whether the contents of a currently open hover window should be moved
          -- to a :h preview-window when pressing the hover keymap.
          preview_window = false,
          title = true,
          mouse_providers = {
            'LSP',
          },
          mouse_delay = 1000,
        }

        -- Setup keymaps
        vim.keymap.set('n', 'K', function(_)
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            require('hover').hover(_)
          end
        end, { desc = 'hover.nvim' })

        vim.keymap.set('n', 'gK', function(_)
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            require('hover').hover_select(_)
          end
        end, { desc = 'hover.nvim' })

        -- vim.keymap.set('n', 'gK', require('hover').hover_select, { desc = 'hover.nvim (select)' })

        vim.keymap.set('n', '<C-p>', function()
          require('hover').hover_switch 'previous'
        end, { desc = 'hover.nvim (previous source)' })

        vim.keymap.set('n', '<C-n>', function()
          require('hover').hover_switch 'next'
        end, { desc = 'hover.nvim (next source)' })

        -- Mouse support
        vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = 'hover.nvim (mouse)' })
        vim.o.mousemoveevent = true
      end,
    },

    -- LSP Enhance
    {
      'nvimdev/lspsaga.nvim',
      enabled = false,
      -- event = 'LspAttach',
      dependencies = {
        'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons', -- optional
      },
      config = function()
        -- Options: https://github.com/nvimdev/lspsaga.nvim/blob/main/lua/lspsaga/init.lua

        require('lspsaga').setup {
          hover = {
            max_width = 0.9,
            max_height = 0.8,
            open_link = 'gx',
            open_cmd = '!chrome',
          },
          symbol_in_winbar = {
            enable = false,
            hide_keyword = true,
            show_file = false,
          },
          lightbulb = {
            enable = true,
          },
        }

        vim.keymap.set('n', 'K', '<CMD>Lspsaga hover_doc<CR>')
        vim.keymap.set('n', '\\', '<CMD>Lspsaga hover_doc<CR>')

        -- local hover = require 'lspsaga.hover'
        -- local hover_visible = false
        --
        -- vim.keymap.set({ 'n', 'i', 'v' }, '<C-LeftMouse>', function()
        --   hover_visible = true
        --   hover.render_hover_doc {}
        -- end, { noremap = false })
        --
        -- vim.keymap.set({ 'n', 'i', 'v' }, '<LeftMouse>', function()
        --   if hover_visible then
        --     hover_visible = false
        --     hover.render_hover_doc {}
        --   end
        -- end, { noremap = false })
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
        'onsails/lspkind-nvim',
      },
      config = function()
        -- See `:help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        local lspkind = require 'lspkind'

        luasnip.config.setup {}

        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          completion = { completeopt = 'menu,menuone,noinsert' },
          formatting = {
            fields = { 'kind', 'menu', 'abbr' },
            expandable_indicator = true,
            format = lspkind.cmp_format {
              -- defines how annotations are shown (default: symbols)
              -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
              mode = 'symbol_text',
              -- default symbol map (default: 'default')
              -- can be either 'default' (requires nerd-fonts font) or
              -- 'codicons' for codicon preset (requires vscode-codicons font)
              preset = 'default',
              -- mode = 'symbol', -- show only symbol annotations
              maxwidth = {
                -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                -- can also be a function to dynamically calculate max width such as
                -- menu = function() return math.floor(0.45 * vim.o.columns) end,
                menu = 100, -- leading text (labelDetails)
                abbr = 50, -- actual suggestion item
              },
              ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
              show_labelDetails = true, -- show labelDetails in menu. Disabled by default

              -- The function below will be called before any actual modifications from lspkind
              -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
              before = function(entry, vim_item)
                -- ...
                return vim_item
              end,
            },
          },
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

        -- Completion menu colors
        -- gray
        -- vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
        -- blue
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
        -- light blue
        vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
        vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
        vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
        -- pink
        vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
        vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
        -- front
        vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
        vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
        vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })
      end,
    },
  }

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
  require('lazy').setup({
    plugins_overrides,
    plugins_qol,
    plugins_bundles,
    plugins_themes,
    plugins_bars,
    plugins_editor,
    plugins_editor_navigation,
    plugins_editor_indicators,
    plugins_editor_languages,
    ---@diagnostic disable-next-line: missing-fields
  }, {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = lazyicons,
    },
  })
end

return M
