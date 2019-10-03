local draw = require "utils.draw"

local newParticle = function()
  return {
    dx = math.random(-10, 10)/10,
    x = 0,
    y = 0,
    state = 1
  }
end

local colorFlow = {
  colors.white,
  colors.yellow,
  colors.orange,
  colors.red,
  colors.gray,
  colors.lightGray
}

return {
  args = {
    particles = {}
  },

  render = function(self)
    for _, p in ipairs(self.particles) do
      paintutils.drawPixel(self.x + p.x, self.y + p.y, colorFlow[p.state])
    end
  end,
  update = function(self, event, var1, var2, var3, entities, keyboard, delta)
    if math.random(1, 5) then
      table.insert(self.particles, newParticle())
    end
    if #self.particles == 0 then
      for i = 1, 5 do
        self.particles[i] = newParticle()
      end
    end
    for i, p in ipairs(self.particles) do
      if math.random(1, 5) == 1 then
        p.x = p.x + p.dx

        if math.random(1, 2) == 1 then
          p.y = p.y - 1
        end

        p.state = p.state + 1
        if p.state > #colorFlow then
          table.remove(self.particles, i)
        end
      end
    end
  end,
  editor = function(self, event, var1, var2, var3)
  end,
  editorRender = function(self)
    draw.box(self.x - 1, self.y - 2, 3, 3, colors.red)
  end,

  needs = {
    "pos"
  }
}
