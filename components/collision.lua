return {
	args = {
		shape = {}
	},
	needs = {
		"pos"
	},
	updateEditor = function(self, editor, game, event, var1, var2, var3)
		if event == "mouse_click" or event == "mouse_drag" then
			local x = var2 - self.x + 1 - game.cameraX
			local y = var3 - self.y + 1 - game.cameraY
			
			if not self.shape[x] then
				self.shape[x] = {}
			end
			if var1 == 1 then
				self.shape[x][y] = true
			else
				self.shape[x][y] = nil
			end
		end
	end,
	drawEditor = function(self, game)
		for x, row in pairs(self.shape) do
			for y, on in pairs(row) do
				if on then
					paintutils.drawPixel(self.x + x - 1 + game.cameraX, self.y + y - 1 + game.cameraY, colors.lightBlue)
				end
			end
		end
	end,
}
