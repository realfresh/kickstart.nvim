local C = require 'config'
local U = require 'utils'

---------------------------------
-- S: Locals
---------------------------------

local set = vim.keymap.set

--@param keymaps table
local mapbulk = function(keymaps)
  for _, k in ipairs(keymaps) do
    local modes = k[1]
    local key = k[2]
    local cmd = k[3]
    local desc = k.desc
    -- print('keymaps', modes, key, cmd, desc)
    set(modes, key, cmd, { desc = desc })
  end
end

---------------------------------
-- S: Module
---------------------------------

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

---------------------------------
-- S: Setup Function
---------------------------------

M.setup_base = function()
  -- Leaders
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','

  -- Clear highlights on search when pressing <Esc> in normal mode
  set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic keymaps
  set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- [note] This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Keybinds to make split navigation easier.
  set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Allow clipboard copy paste in neovim
  set('', '<D-v>', '+p<CR>', { silent = true })
  set({ 't', 'v', '!' }, '<D-v>', '<C-R>+', { silent = true })

  -- Execute Lua
  set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Lua: execute current file' })
  set('n', '<leader>x', ':.lua<CR>')
  set('v', '<leader>x', ':lua<CR>')

  -- Editor Utils
  set('n', '<localleader>w', ':wqa<CR>', { desc = 'Quit All (Write)' })
end

M.setup_plugins = function()
  --
end

---------------------------------
-- S: Plugins
---------------------------------

M.plugin_autosession = {
  keys = {
    { '<leader>pr', '<cmd>SessionSearch<CR>', desc = 'Session search' },
    { '<leader>ps', '<cmd>SessionSave<CR>', desc = 'Save session' },
    { '<leader>pa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
  },
  mappings = {
    -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
    delete_session = { 'i', '<C-D>' },
    alternate_session = { 'i', '<C-S>' },
    copy_session = { 'i', '<C-Y>' },
  },
}

M.plugin_no_neck_pain = {
  { '<leader>ept', ':NoNeckPain<CR>', desc = 'Toggle Padding (No Neck Pain)' },
  { '<leader>epl', ':NoNeckPainToggleLeftSide<CR>', desc = 'Toggle Padding Left (No Neck Pain)' },
  { '<leader>epr', ':NoNeckPainToggleRightSide<CR>', desc = 'Toggle Padding Right (No Neck Pain)' },
  { '<leader>ep-', ':NoNeckPainWidthDown<CR>', desc = 'Less Padding (No Neck Pain)' },
  { '<leader>ep=', ':NoNeckPainWidthUp<CR>', desc = 'More Padding (No Neck Pain)' },
}

M.plugin_nvzone_menu = {
  {
    mode = { 'n', 'v' },
    '<C-RightMouse>',
    desc = 'Menu: Open',
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
}

M.plugin_tabby = {
  { 'n', '<leader>tn', ':$tabnew<CR>', desc = 'Tab: New' },
  { 'n', '<leader>tc', ':tabclose<CR>', desc = 'Tab: Close' },
  { 'n', '<leader>to', ':tabonly<CR>', desc = 'Tab: Only' },
  { 'n', '<leader>tf', ':tabn<CR>', desc = 'Tab: Go Forward' },
  { 'n', '<leader>tb', ':tabp<CR>', desc = 'Tab: Go Backward' },
  { 'n', '<leader>t-', ':-tabmove<CR>', desc = 'Tab: Move Backward' },
  { 'n', '<leader>t=', ':+tabmove<CR>', desc = 'Tab: Move Forward' },
  {
    'n',
    '<leader>tr',
    desc = 'Tab: Rename',
    function()
      Snacks.input({ prompt = 'Tab Name:' }, function(v)
        require('tabby').tab_rename(v)
      end)
    end,
  },
}

M.plugin_snacks = {
  setup = function()
    -- Snacks -> Toggle mappings
    local Snacks = require 'snacks'
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
  keys = {
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
}

M.plugin_gitsigns = function(bufnr)
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
end

---------------------------------
-- S: Plugins: Motions
---------------------------------

M.plugin_multicursor = function()
  local mc = require 'multicursor-nvim'

  mc.setup()
  -- Add all matches in the document
  set({ 'n', 'v' }, '<leader>cca', mc.matchAllAddCursors, { desc = 'Cursor: Add all matches' })

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
end

M.plugin_leap = function()
  -- require('leap').create_default_mappings()
  set({ 'n', 'x', 'o' }, 'gl', '<Plug>(leap-forward)', { desc = 'Leap: Forward' })
  set({ 'n', 'x', 'o' }, 'gL', '<Plug>(leap-backward)', { desc = 'Leap: Backward' })
  set({ 'n', 'x', 'o' }, 'gW', '<Plug>(leap-from-window)', { desc = 'Leap: From Window' })
end

M.plugin_arrow = {
  leader = ';',
  leader_buffer = 'm',
}

M.plugin_nvim_tree = {
  {
    '<leader>1',
    desc = 'NvimTree',
    -- ':NvimTreeOpen<CR>'
    function()
      local nvimtree = require 'nvim-tree.api'
      nvimtree.tree.toggle()
    end,
  },
}

---------------------------------
-- S: Plugins: Code & LSP
---------------------------------

M.plugin_hover = function()
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
    ---@diagnostic disable-next-line: missing-parameter
    require('hover').hover_switch 'previous'
  end, { desc = 'hover.nvim (previous source)' })

  vim.keymap.set('n', '<C-n>', function()
    ---@diagnostic disable-next-line: missing-parameter
    require('hover').hover_switch 'next'
  end, { desc = 'hover.nvim (next source)' })

  -- Mouse support
  vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = 'hover.nvim (mouse)' })
end

M.plugin_conform = {
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
}

M.plugin_trouble = {
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
}

M.plugin_ufo = function()
  local ufo = require 'ufo'

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
end

M.plugin_lsp_config_attach = function(event)
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
end

M.plugin_copilot = {
  panel = {
    jump_prev = '[[',
    jump_next = ']]',
    accept = '<CR>',
    refresh = 'gr',
    open = '<M-CR>',
  },
  suggestion = {
    accept = '<C-CR>',
    accept_word = false,
    accept_line = false,
    next = '<C-d>',
    prev = '<C-u>',
    dismiss = '<C-Space>',
  },
}

M.plugin_cmp = function()
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
  -- local lspkind = require 'lspkind'

  return {
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
  }
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
