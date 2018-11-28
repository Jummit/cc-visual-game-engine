local utils = require "utils"

return function(x, y, w, h, label, color, clickedColor, labelColor, onClick)
  local this = {
    render = function(self)
      local c = self.color
      if self.pressed then
        c = self.clickedColor
      end
      utils.renderBox(self.x, self.y, self.w, self.h, c)
      term.setTextColor(self.labelColor)
      utils.printCenter(self.x, self.y, self.w, self.h, self.label)
    end,
    update = function(self, event, var1, var2, var3)
      if event == "mouse_click" then
        if utils.pointInBox(self.x, self.y, self.w, self.h, var2, var3) then
          self.pressed = true
          self.onClick()
          self:render()
        end
      elseif event == "mouse_up" then
        self.pressed = false

        self:render()
      end
    end
  }

  this.x = x
  this.y = y
  this.w = w
  this.h = h
  this.label = label
  this.color = color
  this.labelColor = labelColor
  this.clickedColor = clickedColor
  this.onClick = onClick

  return this
end
