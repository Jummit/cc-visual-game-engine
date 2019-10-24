local draw = require "utils.draw"

return function(t)
	return setmetatable(t, {__index = {
		render = function(self)
			draw.centerText(self.x, self.y, self.w, self.h, self.text, self.textColor, self.backgroundColor)
		end,
		update = function(self)
		end
	}})
end
