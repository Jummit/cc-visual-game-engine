local draw = require "utils.draw"

local getSlotPos = function (self, slotNum)
	return self.x + (slotNum - 1) * 4, self.y
end

return {
	args = {
		holding = "",
		slots = {
			"a",
			"",
			"g",
			""
		},

	},

	init = function(self)
	end,
	render = function(self)
		for slotNum, item in ipairs(self.slots) do
			local slotX, slotY = getSlotPos(self, slotNum)
			paintutils.drawFilledBox(slotX, slotY, slotX + 2, slotY + 2, colors.gray)
			paintutils.drawPixel(slotX + 1, slotY + 1, colors.lightGray)
			if item ~= "" then
				draw.text(slotX + 1, slotY + 1, item, colors.black, colors.red)
			end
		end
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
		if event == "mouse_click" then
			for slotNum, item in ipairs(self.slots) do
				local slotX, slotY = getSlotPos(self, slotNum)
				if var2 == slotX + 1 and var3 == slotY + 1 then
					if item ~= "" then
						self.slots[slotNum] = self.holding
						self.holding = item
					elseif self.holding ~= "" then
						self.slots[slotNum] = self.holding
						self.holding = item
					end
				end
			end
		end
	end,
	editor = function(self, event, var1, var2, var3, keyboard)
	end,
	editorRender = function(self)
	end,

	needs = {
		"pos"
	}
}