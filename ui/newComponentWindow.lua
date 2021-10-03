local tableUtils = require "utils.table"
local components = require "components.components"
local newList = require "ui.list"
local newWindow = require "ui.window"

local newComponentList
local shouldClose

local componentList = newList({
		x = 0, y = 0, w = 0, h = 0,
		items = {},
		getLabel = function(item)
			return item
		end,
		onDoubleClick = function(self, item)
			self.list:addComponent(item)
			shouldClose = true
		end})

for k, v in pairs(components) do
	table.insert(componentList.items, k)
end

return function(list)
	shouldClose = false
	componentList.list = list
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
