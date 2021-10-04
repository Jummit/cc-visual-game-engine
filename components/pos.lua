local draw = require "utils.draw"
local cameraUtils = require "game.camera"

return {
	args = {
		x = 1.0,
		y = 1.0,
	},
	updateEditor = function(self, editor, game, event, var1, var2, var3)
		local keyboard = editor.keyboard
		if keyboard.up or keyboard.w then
			self.y = self.y - 1
		elseif keyboard.down or keyboard.s then
			self.y = self.y + 1
		end
		if keyboard.left or keyboard.a then
			self.x = self.x - 1
		elseif keyboard.right or keyboard.d then
			self.x = self.x + 1
		end
		if keyboard.f then
			game.cameraX, game.cameraY = cameraUtils.centerOn(self.x, self.y)
		end

		if event == "mouse_click" or event == "mouse_drag" then
			self.x = var2 - game.cameraX
			self.y = var3 - game.cameraY
		end
	end,
	drawEditor = function(self, editor, game)
		draw.text(self.x + game.cameraX, self.y + game.cameraY, "+", colors.lightGray, colors.white)
	end,
}
