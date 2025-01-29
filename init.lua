-- TODO:
-- - Repeat last command
-- - Window broders
-- - Popup borders
-- - LSP popup visuals
-- -> Lazyvim: Which key
-- -> Lazyvim: Cmdline

local options = require 'setup_1_options'
local plugins = require 'setup_2_plugins'
local keymaps = require 'setup_3_keymaps'

options.setup()
keymaps.setup_base()
plugins.setup()
keymaps.setup_plugins()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
