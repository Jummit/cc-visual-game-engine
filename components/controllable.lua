local entityUtils = require "game.entityUtils"

local speed = 10.0

return {
	args = {
		up = "w",
		down = "s",
		left = "a",
		right = "d"
	},
	needs = {
		"pos"
	},
	update = function(self, game, event, var1, var2, var3, delta)
		local entities = game.entities
		if game.keyboard[self.up] then
			if self.fallSpeed then
				if entityUtils.testMove(self, entities, 0, 1) then
					self.fallSpeed = -8
				end
			else
				entityUtils.moveAndCollide(self, entities, 0, -1, delta, speed)
			end
		elseif game.keyboard[self.down] then
			entityUtils.moveAndCollide(self, entities, 0, 1, delta, speed)
		end
		
		if game.keyboard[self.left] then
			entityUtils.moveAndCollide(self, entities, -1, 0, delta, speed)
		elseif game.keyboard[self.right] then
			entityUtils.moveAndCollide(self, entities, 1, 0, delta, speed)
		end
	end,
}
