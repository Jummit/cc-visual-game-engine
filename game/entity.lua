local newComponent = require "game.component"

return function(data)
	local entity = {
		components = {},
		name = data.name,
		save = function(self)
			local components = {}
			for _, component in ipairs(self.components) do
				table.insert(components, component:save())
			end
			return {
				components = components,
				name = self.name
			}
		end,
	}
	if data.components then
		for _, componentData in ipairs(data.components) do
			table.insert(entity.components, newComponent.fromData(entity,
					componentData))
		end
	end
	setmetatable(entity, {
		__index = function(self, key)
			for _, component in ipairs(self.components) do
				if component[key] ~= nil then
					return component[key]
				end
			end
		end,
		__newindex = function(self, key, value)
			for _, component in ipairs(self.components) do
				if component[key] ~= nil then
					component[key] = value
				end
			end
		end
	})
	return entity
end