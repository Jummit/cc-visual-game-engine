local components = require "components.components"

local gameSave = {}

function gameSave.save(saveFile, gameEntities)
	local file = io.open(saveFile, "w")
	file:write(textutils.serialize(gameEntities))
	file:close()
end

function gameSave.load(saveFile)
	if fs.exists(saveFile) then
		local file = fs.open(saveFile, "r")
		local loadEntities = textutils.unserialize(file.readAll())
		for _, entity in ipairs(loadEntities) do
			for _, component in ipairs(entity.components) do
				for argName, argValue in pairs(components[component.type].args) do
					if not component.args[argName] then
						component.args[argName] = argValue
					end
				end
			end
		end
		file.close()
		return loadEntities
	end
end

return gameSave
