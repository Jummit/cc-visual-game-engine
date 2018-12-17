local draw = require "utils.draw"
local colorRadialMenu = require "ui.colorRadialMenu"

return {
  args = {
    texture = {}
  },

  render = function(self)
    for x, row in pairs(self.texture) do
      for y, color in pairs(row) do
        paintutils.drawPixel(self.x + x - 1, self.y + y - 1, color)
      end
    end
  end,
  update = function(self, event, var1, var2, var3)
  end,
  editor = function(self, event, var1, var2, var3)
    if event == "mouse_click" or event == "mouse_drag" then
      if var1 == 2 then
        self.showTools = true
        self.clickedX, self.clickedY = var2, var3
      elseif self.showTools then
        local color = colorRadialMenu.update(self.clickedX, self.clickedY, event, var1, var2, var3)
        self.showTools = false
        self.drawColor = color
      elseif self.drawColor then
        local x = var2 - self.x + 1
        local y = var3 - self.y + 1

        if not self.texture[x] then
          self.texture[x] = {}
        end
        self.texture[x][y] = self.drawColor
      end
    end
  end,
  editorRender = function(self)
    if not (self.texture[1] and self.texture[1][1]) then
      draw.text(self.x, self.y, "·", colors.lightGray, colors.white)
    else
      draw.text(self.x, self.y, "·", colors.lightGray, self.texture[1][1])
    end
    if self.showTools then
      colorRadialMenu.render(self.clickedX, self.clickedY)
    end
  end,

  needs = {
    "pos"
  }
}
