local draw = require "utils.draw"
local colorRadialMenu = require "ui.colorRadialMenu"

return {
	args = {
		texture = {},
		showTools = false,
		clickedX = 0, clickedY = 0,
		drawColor = colors.black
	},
	needs = {
		"pos"
	},
	draw = function(self, game)
		for x, row in pairs(self.texture) do
			for y, color in pairs(row) do
				paintutils.drawPixel(self.x + x - 1 + game.cameraX, self.y + y - 1 + game.cameraY, color)
			end
		end
	end,
	updateEditor = function(self, editor, game, event, var1, var2, var3)
		if event == "mouse_click" or event == "mouse_drag" then
			if var1 == 2 then
				self.showTools = true
				self.clickedX, self.clickedY = var2, var3
			elseif self.showTools then
				local color = colorRadialMenu.update(self.clickedX, self.clickedY, event, var1, var2, var3)
				self.showTools = false
				self.drawColor = color
			else
				local x = var2 - self.x + 1 - game.cameraX
				local y = var3 - self.y + 1 - game.cameraY

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
	drawEditor = function(self, editor, game)
		if not (self.texture[1] and self.texture[1][1]) then
			draw.text(self.x + game.cameraX, self.y + game.cameraY, "+", colors.lightGray, colors.white)
		else
			draw.text(self.x + game.cameraX, self.y + game.cameraY, "+", colors.lightGray, self.texture[1][1])
		end
		if self.showTools then
			colorRadialMenu.draw(self.clickedX, self.clickedY)
		end
	end,
}
