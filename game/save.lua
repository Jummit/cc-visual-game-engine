local gameSave = {}

local loadEntity = require "game.entity"
function gameSave.save(saveFile, entities)
	local file = io.open(saveFile, "w")
	local savedEntities = {}
	for _, entity in ipairs(entities) do
		table.insert(savedEntities, entity:save())
	end
	file:write(textutils.serialize(savedEntities))
	file:close()
end

function gameSave.load(saveFile)
	if not fs.exists(saveFile) then
		return {}
	end
	local file = fs.open(saveFile, "r")
	local entities = {}
	for _, entityData in ipairs(textutils.unserialize(file.readAll())) do
		table.insert(entities, loadEntity(entityData))
	end
	file.close()
	return entities
end

return gameSave
