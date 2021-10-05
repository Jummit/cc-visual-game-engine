local draw = require "utils.draw"
local element = require "ui.element"

return element{
	draw = function(self)
		draw.centerText(self.x, self.y, self.w, self.h, self.text,
				self.textColor, self.backgroundColor)
	end,
}
