local utils = require "utils"

return function(x, y, w, h, items)
  local this = {
    render = function(self)
      local x, y, w, h = self.x, self.y, self.w, self.h
      utils.renderBox(x, y, w, h, colors.gray)
      local next_y = y
      for i, item in ipairs(self.items) do
        if i == self.selected then
          term.setBackgroundColor(colors.lightGray)
        end

        term.setCursorPos(x, next_y)
        term.write(item.label)

        if i == self.selected then
          term.setBackgroundColor(colors.gray)
        end

        next_y = next_y + 1
      end
    end,
    update = function(self, event, var1, var2, var3)
      if event == "mouse_click" then
        if utils.pointInBox(
              self.x, self.y, self.w, self.h,
              var2, var3) then
          self.selected = var3 - self.y + 1
          self:render()
        end
      end
    end
  }

  this.selected = 1
  this.x = x
  this.y = y
  this.w = w
  this.h = h
  this.items = items

  return this
end
