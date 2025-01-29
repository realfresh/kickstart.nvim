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

return M
