local utils = require "utils"
local newButton = require "button"
local components = require "components"
local sw, sh = term.getSize()

local title = "Choose a component"
local w = sw - 30
local h = sh - 5
local x = 22
local y = 4

local newComponentWindow

local closeButton = newButton(x + w - 1, y, 1, 1, "x", colors.red, colors.orange, colors.white, function()
  newComponentWindow.visible = false
end)

newComponentWindow = {
  visible = false,
  render = function(self)
    utils.renderBox(x, y, w, h, colors.lightGray)
    utils.renderLine(x, y, w, 1, colors.gray)
    term.setCursorPos(x, y)
    term.write(title)
    utils.renderBox(x + 3, y + 2, w - 6, h - 3, colors.gray)
    closeButton:render()
  end,
  update = function(self, event, var1, var2, var3)
    closeButton:update(event, var1, var2, var3)
  end
}

return newComponentWindow
