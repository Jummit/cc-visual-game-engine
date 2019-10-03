local draw = require "utils.draw"
local keyboard = require "keyboard"

return {
  args = {
    x = 1.0,
    y = 1.0,
  },

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3)
  end,
  editor = function(self, event, var1, var2, var3)
    keyboard:update(event, var1, var2, var3)

    if keyboard.up or keyboard.w then
      self.y = self.y - 1
    elseif keyboard.down or keyboard.s then
      self.y = self.y + 1
    end
    if keyboard.left or keyboard.a then
      self.x = self.x - 1
    elseif keyboard.right or keyboard.d then
      self.x = self.x + 1
    end
  end,
  editorRender = function(self)
    draw.text(self.x, self.y, "+", colors.lightGray, colors.white)
  end,

  needs = {}
}
