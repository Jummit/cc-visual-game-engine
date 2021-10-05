local tableUtils = require "utils.table"
local newButton = require "ui.button"
local element = require "ui.element"

local function moveListItems(t, f)
	local items = tableUtils.copy(t.list.items)
	local selected = t.list.selected
	local selectedItem = items[selected]
	if selectedItem then
		table.remove(items, selected)
		tableUtils.clear(t.list.items)

		for n, item in ipairs(items) do
			f(n, item, selected, selectedItem)
		end
	end
end

return element{
	init = function(self)
		self.up = newButton{
			x = self.x,
			y = self.y,
			w = 3,
			label = "^",
			color = colors.blue, clickedColor = colors.cyan,
			labelColor = colors.white,
			onClick = function()
				if self.list.selected and self.list.selected > 1 then
					moveListItems(self, function(n, item, selected, selectedItem)
								if n == selected - 1 then
									table.insert(self.list.items, selectedItem)
								end
								table.insert(self.list.items, item)
							end)
					self.list:select(self.list.selected - 1)
				end
			end
		}
		self.down = newButton{
			x = self.x + 3, y = self.y,
			w = 3, h = 1,
			label = "v",
			color = colors.cyan, clickedColor = colors.lightBlue,
			labelColor = colors.white,
			onClick = function()
				if self.list.selected and self.list.selected < #self.list.items then
					moveListItems(self, function(n, item, selected, selectedItem)
								table.insert(self.list.items, item)
								if n == selected then
									table.insert(self.list.items, selectedItem)
								end
							end)
					self.list:select(self.list.selected + 1)
				end
			end
		}
	end,
	draw = function(self)
		self.up:draw()
		self.down:draw()
	end,
	update = function(self, event, var1, var2, var3)
		self.up:update(event, var1, var2, var3)
		self.down:update(event, var1, var2, var3)
	end
}