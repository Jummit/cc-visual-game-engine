local draw = require "utils.draw"
local mathUtils = require "utils.math"

return function(t)
  return setmetatable(t, {__index = {
    render = function(self)
      draw.box(self.x, self.y, self.w, self.h, (self.pressed and self.clickedColor) or self.color)
      draw.center(self.x, self.y, self.w, self.h, self.label, self.labelColor, term.getBackgroundColor())
    end,
    update = function(self, event, var1, var2, var3)
      if event == "mouse_click" then
        if mathUtils.pointInBox(self.x, self.y, self.w, self.h, var2, var3) then
          self.pressed = true
          self:onClick()
        end
      elseif event == "mouse_up" then
        self.pressed = false
      end
    end,
    onClick = function(self) end,
  }})
end
