local components = require "components.components"
local tableUtils = require "utils.table"

local function fromData(parent, data)
	local component = {
		parent = parent,
		editorArgs = tableUtils.copy(components[data.type].editorArgs),
		args = data.args,
		type = data.type,
		save = function(self)
			return {
				args = self.args,
				type = self.type,
			}
		end,
	}
	setmetatable(component, {
		__index = function(self, key)
			if self.args[key] ~= nil then
				return self.args[key]
			elseif self.editorArgs[key] ~= nil then
				return self.editorArgs[key]
			elseif components[self.type][key] ~= nil then
				return components[self.type][key]
			end
		end,
		__newindex = function(self, key, value)
			if self.args[key] ~= nil then
				self.args[key] = value
			elseif self.editorArgs[key] ~= nil then
				self.editorArgs[key] = value
			else
				rawset(self, key, value)
			end
		end,
	})
	return component
end

return {
	fromType = function(parent, componentType)
		return fromData(parent, {
			type = componentType,
			args = tableUtils.copy(components[componentType].args),
		})
	end,
	fromData = fromData,
}