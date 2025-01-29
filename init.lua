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

require '1_options'
require '2_plugins'
require '3_keymaps'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
