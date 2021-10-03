local draw = require "utils.draw"
local cameraUtils = require "utils.camera"

return {
	args = {
		x = 1.0,
		y = 1.0,
	},
	editorUpdate = function(self, editor, game, event, var1, var2, var3)
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
			editor.cameraX, editor.cameraY = cameraUtils.centerOn(self.x, self.y)
		end

		if event == "mouse_click" or event == "mouse_drag" then
			self.x = var2 - editor.cameraX
			self.y = var3 - editor.cameraY
		end
	end,
	editorRender = function(self, editor)
		draw.text(self.x + editor.cameraX, self.y + editor.cameraY, "+", colors.lightGray, colors.white)
	end,
}
