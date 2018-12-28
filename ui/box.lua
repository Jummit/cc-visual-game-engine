local draw = require "utils.draw"

return function(t)
  return setmetatable(t, {__index = {
    render = function(self)
      draw.box(self.x, self.y, self.w, self.h, self.color)
    end,
    update = function(self)
    end
  }})
end
