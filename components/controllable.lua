local physics = require "game.physics"

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
	update = function(self, game, _, _, _, _, delta)
		local entities = game.entities
		if game.keyboard[self.up] then
			if self.fallSpeed then
				if physics.testMove(self, entities, 0, 1) then
					self.fallSpeed = -8
				end
			else
				physics.moveAndCollide(self, entities, 0, -1, delta, speed)
			end
		elseif game.keyboard[self.down] then
			physics.moveAndCollide(self, entities, 0, 1, delta, speed)
		end
		
		if game.keyboard[self.left] then
			physics.moveAndCollide(self, entities, -1, 0, delta, speed)
		elseif game.keyboard[self.right] then
			physics.moveAndCollide(self, entities, 1, 0, delta, speed)
		end
	end,
}
