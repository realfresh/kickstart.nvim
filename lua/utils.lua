----------------------------------------------------------------
-- NOTE: Utilities
----------------------------------------------------------------

local M = {}

M.merge_tables_list = function(...)
  local result = {}
  for _, list in ipairs { ... } do
    for _, item in ipairs(list) do
      table.insert(result, item)
    end
  end
  return result
end

M.merge_tables_kv = function(...)
  local result = {}
  for _, list in ipairs { ... } do
    for key, value in pairs(list) do
      result[key] = value
    end
  end
  return result
end

--@param module string
--@return table
M.safe_require = function(module)
  local ok, result = pcall(require, module)
  if not ok then
    return nil
  end
  return result
end

--@param plugin string
--@return boolean
M.plugin_enabled = function(plugin)
  local plug = require('lazy.core.config').plugins[plugin]
  if plug == nil then
    return false
  end
  return true
end

--@param plugin string
--@return boolean
M.plugin_loaded = function(plugin)
  local plug = require('lazy.core.config').plugins[plugin]
  if plug == nil then
    return false
  end
  return plug._.loaded
end

return M
