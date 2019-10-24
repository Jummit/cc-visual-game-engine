return {
	args = {},

	init = function(self)
	end,
	render = function(self)
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
		local w, h = term.getSize()
		cameraX = -self.x + w / 2
		cameraY = -self.y + h / 2
	end,
	editor = function(self, event, var1, var2, var3, keyboard)
	end,
	editorRender = function(self)
	end,

	needs = {
		"pos"
	}
}