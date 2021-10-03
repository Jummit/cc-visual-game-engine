local cameraUtils = require "game.camera"

return {
	needs = {
		"pos"
	},
	update = function(self, game)
		game.cameraX, game.cameraY = cameraUtils.centerOn(self.x, self.y)
	end,
}