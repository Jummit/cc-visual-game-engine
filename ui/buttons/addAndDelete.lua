local newButton = require "ui.button"

return function(t)
	local add = newButton{
		x = t.x, y = t.y,
		w = 3, h = 1,
		label = "+",
		color = colors.green,
		clickedColor = colors.lime,
		labelColor = colors.white,
		onClick = t.add,
	}
	local del = newButton{
		x = t.x + 3, y = t.y,
		w = 1, h = 1,
		label = "-",
		color = colors.red,
		clickedColor = colors.orange,
		labelColor = colors.white,
		onClick = t.del,
	}

	return {
		draw = function(self)
			del:draw()
			add:draw()
		end,
		update = function(self, event, var1, var2, var3)
			del:update(event, var1, var2, var3)
			add:update(event, var1, var2, var3)
		end
	}
end
