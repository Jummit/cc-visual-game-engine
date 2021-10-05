local newButton = require "ui.button"
local element = require "ui.element"

return element{
	init = function(self)
		self.add = newButton{
			x = self.x,
			y = self.y,
			w = 3,
			label = "+",
			color = colors.green,
			clickedColor = colors.lime,
			labelColor = colors.white,
			onClick = self.add,
		}
		self.del = newButton{
			x = self.x + 3,
			y = self.y,
			label = "-",
			color = colors.red,
			clickedColor = colors.orange,
			labelColor = colors.white,
			onClick = self.del,
		}
	end,
	draw = function(self)
		self.del:draw()
		self.add:draw()
	end,
	update = function(self, event, var1, var2, var3)
		self.del:update(event, var1, var2, var3)
		self.add:update(event, var1, var2, var3)
	end,
}
