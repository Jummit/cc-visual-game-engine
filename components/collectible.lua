local entityUtils = require "game.entityUtils"
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
		for _, e in ipairs(game.entities) do
			local vars = entityUtils.entityTable(e)
			if vars.x and vars.y then
				if vars.x ~= self.x and vars.y ~= self.y then
					if mathUtils.distance(self.x, self.y, vars.x, vars.y) < 4 then
						self.points = self.points + 1
						self.x = math.random(1, 25)
						self.y = math.random(1, 20)
					end
				end
			end
		end
	end,
}
