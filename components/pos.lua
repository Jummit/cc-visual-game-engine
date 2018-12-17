local draw = require "utils.draw"

return {
  args = {
    x = 1,
    y = 1,
  },

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3)
  end,
  editor = function(self, event, var1, var2, var3)
    if Keyboard.up or Keyboard.w then
      self.y = self.y - 1
    elseif Keyboard.down or Keyboard.s then
      self.y = self.y + 1
    end
    if Keyboard.left or Keyboard.a then
      self.x = self.x - 1
    elseif Keyboard.right or Keyboard.d then
      self.x = self.x + 1
    end
  end,
  editorRender = function(self)
    draw.text(self.x, self.y, "+", colors.lightGray, colors.white)
  end,

  needs = {}
}
