local draw = require "utils.draw"
local mathUtils = require "utils.math"
local element = require "ui.element"

return element{
	draw = function(self)
		draw.box(self.x, self.y, self.w, self.h, colors.gray)

		for i, item in ipairs(self.items) do
			if i == self.selected then
				term.setTextColor(colors.white)
			else
				term.setTextColor(colors.lightGray)
			end

			local itemPos = i - 1 + self.scroll
			if itemPos >= 0 and itemPos < self.h then
				term.setCursorPos(self.x, self.y + itemPos)
				term.write(self.getLabel(item))
			end
		end
	end,
	update = function(self, event, var1, var2, var3)
		if event == "mouse_click" then
			local clickedItem = var3 - self.y + 1 - self.scroll
			if mathUtils.pointInBox(self.x, self.y, self.w, self.h, var2,
					var3) and #self.items >= clickedItem then
				if self.selected == clickedItem then
					self:onDoubleClick(self.items[self.selected])
				else
					self:select(clickedItem)
				end
			end
		elseif event == "mouse_scroll" and mathUtils.pointInBox(self.x,
				self.y, self.w, self.h, var2, var3) then
			local newScroll = self.scroll - var1
			if newScroll <= 0 and #self.items + newScroll > self.h - 2 then
				self.scroll = newScroll
			end
		end
	end,
	select = function(self, i)
		self.selected = nil
		if #self.items ~= 0 then
			self.selected = (i > 0 and i <= #self.items and i) or 1
			self:onItemSelected(self.items[self.selected])
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

	scroll = 0,
	shouldDelete = function(self, item) return true end,
	onItemSelected = function(self, item) end,
	onDoubleClick = function(self, item) end
}
