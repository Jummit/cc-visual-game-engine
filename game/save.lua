local gameSave = {}

function gameSave.save(saveFile, gameEntities)
	local file = io.open(saveFile, "w")
	file:write(textutils.serialize(gameEntities))
	file:close()
end

function gameSave.load(saveFile)
	if not fs.exists(saveFile) then
		return {}
	end
	local file = fs.open(saveFile, "r")
	local entities = textutils.unserialize(file.readAll())
	file.close()
	return entities
end

return gameSave
