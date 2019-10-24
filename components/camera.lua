local cameraUtils = require "utils.camera"

return {
	args = {},
	
	init = function(self)
	end,
	render = function(self)
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
		cameraX, cameraY = cameraUtils.centerOn(self.x, self.y)
	end,
	editor = function(self, event, var1, var2, var3, keyboard)
	end,
	editorRender = function(self)
	end,
	
	needs = {
		"pos"
	}
}