local draw = require "utils.draw"
local mathUtils = require "utils.math"

return function(t)
	return setmetatable(t, {__index = {
		render = function(self)
			draw.box(self.x, self.y, self.w, self.h, colors.gray)

			for i, item in ipairs(self.items) do
				if i == self.selected then
					term.setTextColor(colors.white)
				else
					term.setTextColor(colors.lightGray)
				end

				term.setCursorPos(self.x, self.y + i - 1)
				term.write(self.getLabel(item))
			end
		end,
		update = function(self, event, var1, var2, var3)
			if event == "mouse_click" then
				local clickedItem = var3 - self.y + 1
				if mathUtils.pointInBox(self.x, self.y, self.w, self.h, var2, var3) and #self.items >= clickedItem then
					if self.selected == clickedItem then
						self.onDoubleClick(self.items[self.selected])
					else
						self:select(clickedItem)
					end
				end
			end
		end,
		select = function(self, i)
			self.selected = nil
			if #self.items ~= 0 then
				self.selected = (i > 0 and i <= #self.items and i) or 1
				self.onItemSelected(self.items[self.selected])
			end
		end,
		removeSelected = function(self)
			if self.selected and self:shouldDelete(self.items[self.selected]) then
				table.remove(self.items, self.selected)
				self:select(self.selected)
			end
		end,
		add = function(self, item)
			table.insert(self.items, item)
			self:select(#self.items)
		end,
		getSelected = function(self)
			return self.items[self.selected]
		end,

		shouldDelete = function() return true end,
		onItemSelected = function() end,
		onDoubleClick = function() end
	}})
end
