local entityUtils = require "utils.entity"

local speed = 10.0

local function tryToMove(self, entities, dx, dy, delta)
  local newX, newY = self.x + dx * delta * speed, self.y + dy * delta * speed

  if self.shape then
    self.me = true
    for _, e in ipairs(entities) do
      local vars = entityUtils.getVars(e)
      if not vars.me then
        local shape = vars.shape

        if shape then
          for x, row in pairs(shape) do
            for y, on in pairs(row) do
              if on then
                local x = x + vars.x - newX
                local y = y + vars.y - newY
                if self.shape[x] and self.shape[x][y] then
                  return
                end
              end
            end
          end
        end
      end
    end
    self.me = nil
  end

  self.x = newX
  self.y = newY
end

return {
  args = {
    up = "w",
    down = "s",
    left = "a",
    right = "d"
  },

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3, entities, keyboard, delta)
    keyboard:update(event, var1, var2, var3)

    if keyboard[self.up] then
      tryToMove(self, entities, 0, -1, delta)
    elseif keyboard[self.down] then
      tryToMove(self, entities, 0, 1, delta)
    end

    if keyboard[self.left] then
      tryToMove(self, entities, -1, 0, delta)
    elseif keyboard[self.right] then
      tryToMove(self, entities, 1, 0, delta)
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
