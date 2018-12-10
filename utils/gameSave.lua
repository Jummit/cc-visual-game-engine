local tableUtils = require "utils.table"
local gameSave = {}

function gameSave.save(saveFile, gameEntities)
  local file = io.open(saveFile, "w")
  file:write(textutils.serialize(gameEntities))
  file:close()
end

function gameSave.load(saveFile)
  if fs.exists(saveFile) then
    local gameEntities = {}
    local file = fs.open(saveFile, "r")
    local loadEntities = textutils.unserialize(file.readAll())
    for k, v in pairs(loadEntities) do
      gameEntities[k] = tableUtils.copy(v)
    end
    file.close()
    return gameEntities
  end
end

return gameSave
