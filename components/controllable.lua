local entityUtils = require "utils.entity"

local speed = 10.0

return {
  args = {
    up = "w",
    down = "s",
    left = "a",
    right = "d"
  },

  init = function(self)
  end,
  render = function(self)
  end,
  update = function(self, event, var1, var2, var3, entities, keyboard, delta)
    if keyboard[self.up] then
      if self.fallSpeed then
        if entityUtils.testMove(self, entities, 0, 1) then
          self.fallSpeed = -8
        end
      else
        entityUtils.moveAndCollide(self, entities, 0, -1, delta, speed)
      end
    elseif keyboard[self.down] then
      entityUtils.moveAndCollide(self, entities, 0, 1, delta, speed)
    end

    if keyboard[self.left] then
      entityUtils.moveAndCollide(self, entities, -1, 0, delta, speed)
    elseif keyboard[self.right] then
      entityUtils.moveAndCollide(self, entities, 1, 0, delta, speed)
    end
  end,
  editor = function(self, event, var1, var2, var3)
  end,
  editorRender = function(self)
  end,

  needs = {
    "pos"
  }
}
