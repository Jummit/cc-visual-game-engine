local mathUtils = require "utils.math"
local draw = require "utils.draw"

return function(t)
	return setmetatable(t, {__index = {
		draw = function(self)
			term.setBackgroundColor(colors.gray)
			term.setTextColor(colors.white)
			draw.line(self.x, self.y, self.x + self.w - 1, self.y, colors.gray)
			term.setCursorPos(self.position.x, self.position.y)
			term.write(self.text:sub(1, self.size.x))
		end,
		update = function(self, event, var1, var2, var3)
			if event == "mouse_click" and mathUtils.pointInBox(self.x, self.y,
					self.size.x, 1, var2, var3) then
				draw.line(self.x, self.y, self.x + self.w - 1, self.y,
						colors.gray)
				term.setTextColor(colors.white)
				term.setCursorPos(self.position.x, self.position.y)
				self.text = io.read()
			end
		end,
		text = "",
	}})
end
