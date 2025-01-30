local C = require 'config'
local U = require 'utils'
local KM = require 'setup_3_keymaps'

-- S: Notes
--
-- Find LSP servers at:
--  -> https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
--
-- Find list of tools available via Mason Tool Installer:
--  -> `:Mason`
--

---------------------------------
-- S: Module
---------------------------------

local M = {}

M.lsp = {

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

M.lsp_names = vim.tbl_keys(M.lsp)

M.lsp_disable_format_on_save = {
  -- Disable "format_on_save lsp_fallback" for languages that don't
  -- have a well standardized coding style. You can add additional
  -- languages here or re-enable it for the disabled ones.
  c = true,
  cpp = true,
  javascript = true,
  typescript = true,
  json = true,
}

M.mason_tools_list = vim.list_extend(M.lsp_names, {
  'ansible-lint',
  'cspell',
  'eslint_d',
  'goimports',
  'prettierd',
  'shellcheck',
  'shfmt',
  'stylua',
})

M.formatters = {
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

---------------------------------
-- S: Plugins: Nvim (the core of Neovim)
---------------------------------

---@type LazySpec[]
local plugins_nvim_overrides = {
  -- Override: Vim Print & Debug
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      debug = { enabled = true },
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
        end,
      })
    end,
  },
}

---@type LazySpec[]
local plugins_nvim_main = {
  -- Sessions
  {
    'rmagatti/auto-session',
    lazy = false,
    dependencies = {},
    keys = KM.plugin_autosession.keys,
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
          mappings = KM.plugin_autosession.mappings,
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

  -- Select & Fuzzy Finder
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
}

---@type LazySpec[]
local plugins_nvim_qol = {
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

  -- Window padding
  {
    'shortcuts/no-neck-pain.nvim',
    enabled = C.plugins.no_neck_pain.enabled,
    lazy = false,
    keys = KM.plugin_no_neck_pain,
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
  },
}

---@type LazySpec[]
local plugins_nvim_snacks = {
  -- Buffers, LazyGit, Scope, Words, Toggle
  {
    'folke/snacks.nvim',
    keys = KM.plugin_snacks.keys,
    ---@type snacks.Config
    opts = {
      bufdelete = { enabled = true },
      lazygit = { enabled = true },
      scope = { enabled = true },
      words = { enabled = true },
      toggle = { enabled = true },
    },
    init = function()
      KM.plugin_snacks.setup()
    end,
  },
}

---------------------------------
-- S: Plugins: UI (the user-interface of Neovim)
---------------------------------

---@type LazySpec[]
local plugins_ui_themes = {
  { 'ramojus/mellifluous.nvim' },
  { 'rose-pine/neovim', name = 'rose-pine' },
  { 'vague2k/vague.nvim' },
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
}

---@type LazySpec[]
local plugins_ui_customization = {
  -- Vim Input & Notifications & Status Column
  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      input = {
        enabled = true,
      },
      statuscolumn = {
        enabled = true,
      },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
    },
  },

  -- Menu
  { 'nvzone/volt', lazy = true },
  { 'nvzone/menu', lazy = true, keys = KM.plugin_nvzone_menu },

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
  },
}

---@type LazySpec[]
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
}

---------------------------------
-- S: Plugins: Editor (when code is being written))
---------------------------------

---@type LazySpec[]
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
        KM.plugin_gitsigns(bufnr)
        vim.cmd [[
            highlight GitSignsAdd    guifg=green        guibg=NONE
            highlight GitSignsChange guifg=darkyellow   guibg=NONE
            highlight GitSignsDelete guifg=red          guibg=NONE
          ]]
      end,
    },
  },
}

---@type LazySpec[]
local plugins_editor_navigation = {
  -- Navigation
  {
    'ggandor/leap.nvim',
    lazy = false,
    dependencies = { 'tpope/vim-repeat' },
    config = function()
      KM.plugin_leap()
    end,
  },

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
      leader_key = KM.plugin_arrow.leader,
      buffer_leader_key = KM.plugin_arrow.leader_buffer,
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
    keys = KM.plugin_nvim_tree,
    config = function()
      require('nvim-tree').setup {}
    end,
  },
}

---------------------------------
-- S: Plugins: Coding (the code itself)
---------------------------------

---@type LazySpec[]
local plugins_coding = {
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
      local hl = vim.api.nvim_set_hl
      hl(0, 'MultiCursorCursor', { link = 'Cursor' })
      hl(0, 'MultiCursorVisual', { link = 'Visual' })
      hl(0, 'MultiCursorSign', { link = 'SignColumn' })
      hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })

      KM.plugin_multicursor()
    end,
  },
}

---@type LazySpec[]
local plugins_coding_languages = {

  -- S: Editor: Formatting

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = KM.plugin_conform,
    opts = {
      formatters_by_ft = M.formatters,
      notify_on_error = false,
      format_on_save = function(bufnr)
        local lsp_format_opt
        if M.lsp_disable_format_on_save[vim.bo[bufnr].filetype] then
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
      KM.plugin_ufo()
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
        callback = KM.plugin_lsp_config_attach,
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
        ensure_installed = M.mason_tools_list,
      }

      ---@diagnostic disable-next-line: missing-fields
      require('mason-lspconfig').setup {
        -- automatic_installation = true,
        -- ensure_installed = mason_tools_lsp_keys,
        handlers = {
          function(server_name)
            local server = M.lsp[server_name] or {}
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
    keys = KM.plugin_trouble,
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
        mouse_providers = { 'LSP' },
        mouse_delay = 1000,
      }
      KM.plugin_hover()
      vim.o.mousemoveevent = true
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
          keymap = KM.plugin_copilot.panel,
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
          keymap = KM.plugin_copilot.suggestion,
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
        mapping = cmp.mapping.preset.insert(KM.plugin_cmp()),
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

---------------------------------
---S: Plugins Initialize
---------------------------------

M.setup = function()
  M.lazy_setup {
    plugins_nvim_overrides,
    plugins_nvim_main,
    plugins_nvim_qol,
    plugins_nvim_snacks,
    plugins_ui_themes,
    plugins_ui_customization,
    plugins_bundles,
    plugins_editor_indicators,
    plugins_editor_navigation,
    plugins_coding,
    plugins_coding_languages,
  }
end

---------------------------------
-- S: Plugin Manager
---------------------------------

--@param plugins LazySpec[]
M.lazy_setup = function(plugins)
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

  ---@diagnostic disable-next-line: missing-fields
  require('lazy').setup(plugins, {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = lazyicons,
    },
  })
end

return M
