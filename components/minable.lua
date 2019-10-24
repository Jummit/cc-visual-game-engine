return {
	args = {},

	init = function(self)
	end,
	render = function(self)
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
		if event == "mouse_click" or event == "mouse_drag" then
			local tx, ty = math.floor(var2 - cameraX), math.floor(var3 - cameraY)
			self.tiles[tx][ty] = 1
			self.shape[tx][ty] = false
		end
	end,
	editor = function(self, event, var1, var2, var3, keyboard)
	end,
	editorRender = function(self)
	end,

	needs = {
		"map"
	}
}