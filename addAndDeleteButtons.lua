local newButton = require "button"

return function(x, y, delFunction, addFunction)
  local del = newButton(
      x, y, 5, 1,
      "del",
      colors.red, colors.orange, colors.white,
      delFunction)
  local add = newButton(
      x + 5, y, 5, 1,
      "add",
      colors.green, colors.lime, colors.white,
      addFunction)

  local this = {
    render = function(self)
      del:render()
      add:render()
    end,
    update = function(self, event, var1, var2, var3)
      del:update(event, var1, var2, var3)
      add:update(event, var1, var2, var3)
    end
  }

  this.x = x
  this.y = y
  this.delFunction = delFunction
  this.addFunction = addFunction

  return this
end
