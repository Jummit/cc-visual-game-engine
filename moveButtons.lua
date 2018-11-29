local newButton = require "button"

return function(t)
  local up = newButton{
    x = t.x, y = t.y,
    w = 3, h = 1,
    label = "^",
    color = colors.gray, clickedColor = colors.cyan,
    labelColor = colors.white,
    onClick = function()

    end
  }
  local down = newButton{
    x = t.x + 4, y = t.y,
    w = 3, h = 1,
    label = "v",
    color = colors.gray, clickedColor = colors.cyan,
    labelColor = colors.white,
    onClick = function()

    end
  }

  return {
    render = function(self)
      up:render()
      down:render()
    end,
    update = function(self, event, var1, var2, var3)
      up:update(event, var1, var2, var3)
      down:update(event, var1, var2, var3)
    end
  }
end
