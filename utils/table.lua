local table = {}

function table.clear(t)
  for k, v in pairs(t) do
    t[k] = nil
  end
end

local copy
function copy(t)
  local n = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      n[k] = copy(v)
    else
      n[k] = v
    end
  end
  return n
end

table.copy = copy

return table
