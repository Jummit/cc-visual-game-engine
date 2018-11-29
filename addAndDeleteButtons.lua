local newButton = require "button"

return function(t)
  local del = newButton{
      x = t.x, y = t.y,
      w = 5, h = 1,
      label = "del",
      color = colors.red, clickedColor = colors.orange, labelColor = colors.white,
      onClick = t.del}
  local add = newButton{
      x = t.x + 5, y = t.y,
      w = 5, h = 1,
      label = "add",
      color = colors.green, clickedColor = colors.lime, labelColor = colors.white,
      onClick = t.add}

  return {
    render = function(self)
      del:render()
      add:render()
    end,
    update = function(self, event, var1, var2, var3)
      del:update(event, var1, var2, var3)
      add:update(event, var1, var2, var3)
    end
  }
end
