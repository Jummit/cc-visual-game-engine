local draw = require "utils.draw"
local element = require "ui.element"

return element{
	draw = function(self)
		draw.box(self.x, self.y, self.w, self.h, self.color)
	end,
}
