local utils = require "utils"

return function(t)
  return setmetatable(t, {__index = {
    render = function(self)
      utils.renderBox(self.x, self.y, self.w, self.h, (self.pressed and self.clickedColor) or self.color)
      term.setTextColor(self.labelColor)
      utils.printCenter(self.x, self.y, self.w, self.h, self.label)
    end,
    update = function(self, event, var1, var2, var3)
      if event == "mouse_click" then
        if utils.pointInBox(self.x, self.y, self.w, self.h, var2, var3) then
          self.pressed = true
          self.onClick()
        end
      elseif event == "mouse_up" then
        self.pressed = false
      end
    end,
    onClick = function() end,
  }})
end
