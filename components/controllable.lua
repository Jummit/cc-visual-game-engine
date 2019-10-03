local entityUtils = require "utils.entity"
local keyboard = require "keyboard"

return {
  args = {
    up = "w",
    down = "s",
    left = "a",
    right = "d"
  },

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3, entities)
    keyboard:update(event, var1, var2, var3)

    local move = {
      x = 0,
      y = 0
    }

    if keyboard[self.up] then
      move.y = -1
    elseif keyboard[self.down] then
      move.y = 1
    end

    if keyboard[self.left] then
      move.x = -1
    elseif keyboard[self.right] then
      move.x = 1
    end

    self.x = self.x + move.x/2
    self.y = self.y + move.y/2

    if self.shape then
      local collided = false

      self.__MOVING = true
      for _, e in ipairs(entities) do
        local vars = entityUtils.getVars(e)
        if not vars.__MOVING then
          local shape = vars.shape

          if shape then
            for x, row in pairs(shape) do
              for y, on in pairs(row) do
                if on then
                  local x, y =
                      x + vars.x - self.x,
                      y + vars.y - self.y
                  if self.shape[x] and self.shape[x][y] then
                    collided = true
                    break
                  end
                end
              end
            end
          end
        end
      end

      if collided then
        self.x = self.x - move.x
        self.y = self.y - move.y
      end
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
