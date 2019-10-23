local entityUtils = require "utils.entity"
local strength = 1
return {
	args = {
		fallSpeed = 0
	},
  
	init = function(self)
	end,
	render = function(self)
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
		if entityUtils.moveAndCollide(self, entities, 0, self.fallSpeed, delta, strength) then
			self.fallSpeed = 0
		else
			self.fallSpeed = self.fallSpeed + strength
		end
	end,
	editor = function(self, event, var1, var2, var3, keyboard)
	end,
	editorRender = function(self)
	end,
  
	needs = {
	  "pos",
	  "collision"
	}
  }