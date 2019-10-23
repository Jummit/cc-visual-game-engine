local newParticle = function()
	return {
	  time = 0,
	  x = 0,
	  y = 0
	}
  end

return {
	args = {
		particles = {}
	},
	init = function(self)
		for i = 1, 10 do
			table.insert(self.particles, newParticle())
		end
	end,
	render = function(self)
		for _, p in ipairs(self.particles) do
			paintutils.drawPixel(self.x + p.x + cameraX, self.y + p.y + cameraY, colors.lightBlue)
		end
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
		for i, p in ipairs(self.particles) do
			p.y = p.y + math.random(5, 9) / 10
			p.time = p.time + 1
			if p.time > 10 then
				table.remove(self.particles, i)
				table.insert(self.particles, newParticle())
			end
		end
	end,
	editor = function(self, event, var1, var2, var3, keyboard)
	end,
	editorRender = function(self)
	end,
	needs = {
	  "pos"
	}
  }