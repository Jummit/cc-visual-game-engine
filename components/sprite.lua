local draw = require "utils.draw"
local colorRadialMenu = require "ui.colorRadialMenu"

return {
	args = {
		texture = {},
		showTools = false,
		clickedX = 0, clickedY = 0,
		drawColor = colors.black
	},
	init = function(self)
	end,
	render = function(self)
		for x, row in pairs(self.texture) do
			for y, color in pairs(row) do
				paintutils.drawPixel(self.x + x - 1 + cameraX, self.y + y - 1 + cameraY, color)
			end
		end
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
	end,
	editor = function(self, event, var1, var2, var3)
		if event == "mouse_click" or event == "mouse_drag" then
			if var1 == 2 then
				self.showTools = true
				self.clickedX, self.clickedY = var2, var3
			elseif self.showTools then
				local color = colorRadialMenu.update(self.clickedX, self.clickedY, event, var1, var2, var3)
				self.showTools = false
				self.drawColor = color
			else
				local x = var2 - self.x + 1
				local y = var3 - self.y + 1
				
				if not self.texture[x] then
					self.texture[x] = {}
				end
				if self.drawColor == -1 then
					self.texture[x][y] = nil
					if #self.texture[x] == 0 then
						table.remove(self.texture, x)
					end
				else
					self.texture[x][y] = self.drawColor
				end
			end
		end
	end,
	editorRender = function(self)
		if not (self.texture[1] and self.texture[1][1]) then
			draw.text(self.x, self.y, "·", colors.lightGray, colors.white)
		else
			draw.text(self.x, self.y, "·", colors.lightGray, self.texture[1][1])
		end
		if self.showTools then
			colorRadialMenu.render(self.clickedX, self.clickedY)
		end
	end,
	
	needs = {
		"pos"
	}
}
