local draw = require "utils.draw"

local getSlotPos = function (self, slotNum)
	return self.x + (slotNum - 1) * 4, self.y
end

return {
	args = {
		holding = {},
		slots = {
			{}, {}, {}, {}, {}
		}
	},
	needs = {
		"pos"
	},
	draw = function(self)
		for slotNum, item in ipairs(self.slots) do
			local slotX, slotY = getSlotPos(self, slotNum)
			paintutils.drawFilledBox(slotX, slotY, slotX + 2, slotY + 2, colors.gray)
			paintutils.drawPixel(slotX + 1, slotY + 1, colors.lightGray)
			if item.amount then
				draw.text(slotX + 1, slotY + 2, tostring(item.amount), colors.white, colors.gray)
				draw.pixelTexture(slotX + 1, slotY + 1, item.texture)
			end
		end
	end,
	update = function(self, game, event, var1, var2, var3)
		if event == "mouse_click" then
			for slotNum, item in ipairs(self.slots) do
				local slotX, slotY = getSlotPos(self, slotNum)
				if var2 == slotX + 1 and var3 == slotY + 1 then
					if item.amount then
						self.slots[slotNum] = self.holding
						self.holding = item
					elseif self.holding.amount then
						self.slots[slotNum] = self.holding
						self.holding = item
					end
				end
			end
		end
	end,
}