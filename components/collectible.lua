local mathUtils = require "utils.math"

return {
	args = {
		points = 0
	},
	needs = {
		"pos",
		"collision"
	},
	draw = function(self)
		term.setTextColor(colors.black)
		term.setCursorPos(1, 1)
		term.write("Points: " .. self.points)
	end,
	update = function(self, game)
		for _, entity in ipairs(game.entities) do
			if entity.x and entity.y then
				if entity.x ~= self.x and entity.y ~= self.y then
					if mathUtils.distance(self.x, self.y, entity.x, entity.y) < 4 then
						self.points = self.points + 1
						self.x = math.random(1, 25)
						self.y = math.random(1, 20)
					end
				end
			end
		end
	end,
}
