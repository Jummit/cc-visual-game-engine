local tableUtils = require "utils.table"
local components = require "components"
local newList = require "ui.list"
local newWindow = require "ui.window"

local newComponentList
local shouldClose

local function createComponent(type)
	local newComponent = tableUtils.copy(components[type])
	newComponent.type = type
	newComponent.init = nil
	newComponent.render = nil
	newComponent.update = nil
	newComponent.editor = nil
	newComponent.editorRender = nil
	return newComponent
end

local componentList = newList({
		x = 0, y = 0, w = 0, h = 0,
		items = {},
		getLabel = function(item)
			return item
		end,
		onDoubleClick = function(self, item)
			local newComponent = components[item]

			for _, neededComponent in ipairs(newComponent.needs) do
				local neededExists = false
				for _, existingComponent in ipairs(componentList.items) do
					if existingComponent.type == neededComponent then
						neededExists = true
					end
				end
				if not neededExists then
					componentList:add(createComponent(neededComponent))
				end
			end

			componentList:add(createComponent(item))
			shouldClose = true
		end})

for k, v in pairs(components) do
	table.insert(componentList.items, k)
end

return function()
	shouldClose = false
	return newWindow{
		visible = true,
		title = "Choose a component",
		render = function(self, x, y, w, h)
			componentList.x = x
			componentList.y = y
			componentList.w = w
			componentList.h = h
			componentList:render()
		end,
		update = function(self, event, var1, var2, var3)
			componentList:update(event, var1, var2, var3)
			return shouldClose
		end
	}
end
