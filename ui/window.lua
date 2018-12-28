local draw = require "utils.draw"

local sw, sh = term.getSize()
local xm, ym = 10, 2

local x = xm + 1
local y = ym + 1
local w = sw - xm * 2
local h = sh - ym * 2

return function(t)
  return {
    title = t.title,
    visible = t.visible,
    render = function(self)
      if self.visible then
        draw.box(x - 1, y + 1, w, h, colors.black)
        draw.box(x, y, w, h, colors.lightGray)
        draw.line(x, y, w, 1, colors.gray)
        --draw.center(x, y, w, 1, window.title, colors.white, colors.gray)
        draw.text(x + w - 1, y, "x", colors.white, colors.red)

        t.render(self, x + 2, y + 2, w - 4, h - 4)
      end
    end,
    update = function(self, event, var1, var2, var3)
      if self.visible then
        if event == "mouse_click" and var2 == w + x - 1 and var3 == y then
          self.visible = false
        else
          t.update(self, event, var1, var2, var3)
        end
      end
    end
  }
end
