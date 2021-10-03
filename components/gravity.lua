local entityUtils = require "game.entityUtils"

return {
	args = {
		fallSpeed = 0
	},
	needs = {
		"pos",
		"collision"
	},
	update = function(self, game)
		if entityUtils.moveAndCollide(self, game.entities, 0, self.fallSpeed, game.delta, 1) then
			self.fallSpeed = 0
		else
			self.fallSpeed = self.fallSpeed + 1
		end
	end,
}