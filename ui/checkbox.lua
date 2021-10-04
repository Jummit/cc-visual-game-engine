return function(t)
	return setmetatable(t, {__index = {
		draw = function(self)
			term.setBackgroundColor(colors.gray)
			term.setTextColor(colors.white)
			term.setCursorPos(self.x, self.y)
			if self.ticked then
				term.write("x")
			else
				term.write(" ")
			end
		end,
		update = function(self, event, var1, var2, var3)
			if event == "mouse_click" and var2 == self.x and var3 == self.y then
				self.ticked = not self.ticked
			end
		end,
		ticked = false,
	}})
end