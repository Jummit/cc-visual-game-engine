local components = require "components.components"
local newList = require "ui.list"
local newWindow = require "ui.window"

local componentList = newList({
		x = 0, y = 0, w = 0, h = 0,
		items = {}, shouldClose = false,
		getLabel = function(item)
			return item
		end,
		onDoubleClick = function(self, item)
			self.list:addComponent(item)
			self.shouldClose = true
		end})

for k, _ in pairs(components) do
	table.insert(componentList.items, k)
end

return function(list)
	componentList.list = list
	return newWindow{
		visible = true,
		title = "Choose a component",
		draw = function(self, x, y, w, h)
			componentList.x = x
			componentList.y = y
			componentList.w = w
			componentList.h = h
			componentList:draw()
		end,
		update = function(self, event, var1, var2, var3)
			componentList:update(event, var1, var2, var3)
			return componentList.shouldClose
		end
	}
end
