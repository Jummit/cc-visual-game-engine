local entityUtils = require "utils.entity"

return {
  args = {
    up = "w",
    down = "s",
    left = "a",
    right = "d"
  },

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3)
    if event == "key" then
      local move = {
        x = 0,
        y = 0
      }

      local k = keys.getName(var1)
      if k == self.up then
        move.y = -1
      elseif k == self.down then
        move.y = 1
      end

      if k == self.left then
        move.x = -1
      elseif k == self.right then
        move.x = 1
      end

      self.x = self.x + move.x
      self.y = self.y + move.y

      if self.shape then
        local collided = false

        self.__MOVING = true
        for _, e in ipairs(Entities) do
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
