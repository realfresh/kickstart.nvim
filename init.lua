-- TODO:
-- - Repeat last command
-- - Window broders
-- - Popup borders
-- - LSP popup visuals
-- -> Lazyvim: Which key
-- -> Lazyvim: Cmdline

-- Global state for the configuration
local GS = {
  plugin = {
    no_neck_pain = false,
    ufo = true,
  },
}

local options = require '1_options'
local plugins = require '2_plugins'
local keymaps = require '3_keymaps'

options.setup()
keymaps.setup_base()
plugins.setup()
keymaps.setup_plugins()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
