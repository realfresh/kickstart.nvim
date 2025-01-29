local M = {
  session = {},
  plugins = {
    ufo = { enabled = true },
    no_neck_pain = { enabled = true },
  },
}

M.theme = {
  -- 'ayu-dark' 'adwaita' 'kanagawa-wave'
  colorscheme = 'evergarden',
}

M.colors = {
  custom = {
    bg = '#0b1115',
  },
  evergarden = {
    aqua = '#93C9A1',
    base = '#232A2E',
    blue = '#9BB5CF',
    crust = '#171C1F',
    green = '#B2C98F',
    mantle = '#1C2225',
    orange = '#E69875',
    overlay0 = '#617377',
    overlay1 = '#738A8B',
    overlay2 = '#839E9A',
    pink = '#E3A8D1',
    purple = '#D6A0D1',
    red = '#E67E80',
    skye = '#97C9C3',
    softbase = '#2B3538',
    subtext0 = '#94AAA0',
    subtext1 = '#CACCBE',
    surface0 = '#313B40',
    surface1 = '#3D494D',
    surface2 = '#4F5E62',
    text = '#DDDECF',
    yellow = '#DBBC7F',
  },
  -- To get colors
  --> :lua print(vim.inspect(require('evergarden.colors').colors))
  evergarden_require = function()
    return require('evergarden.colors').colors
  end,
}

return M
