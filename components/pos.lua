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
    if event == "key" then
      local k = keys.getName(var1)
      if k == "up" or k == "w" then
        self.y = self.y - 1
      elseif k == "down" or k == "s" then
        self.y = self.y + 1
      end
      if k == "left" or k == "a" then
        self.x = self.x - 1
      elseif k == "right" or k == "d" then
        self.x = self.x + 1
      end
    end
  end,
  editorRender = function(self)
    draw.text(self.x, self.y, "+", colors.lightGray, colors.white)
  end,

  needs = {}
}
