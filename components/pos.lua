local draw = require "utils.draw"
local cameraUtils = require "utils.camera"

return {
	args = {
		x = 1.0,
		y = 1.0,
	},
	init = function(self)
	end,
	render = function(self)
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
	end,
	editor = function(self, event, var1, var2, var3, keyboard)
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
			cameraX, cameraY = cameraUtils.centerOn(self.x, self.y)
		end

		if event == "mouse_click" or event == "mouse_drag" then
			self.x = var2 - cameraX
			self.y = var3 - cameraY
		end
	end,
	editorRender = function(self)
		draw.text(self.x + cameraX, self.y + cameraY, "+", colors.lightGray, colors.white)
	end,

	needs = {}
}
