local utils = require "utils"
local newButton = require "button"
local components = require "components"
local newList = require "list"
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

local function createComponent(type)
  local newComponent = utils.copyTable(components[type])
  newComponent.type = type
  newComponent.render = nil
  newComponent.update = nil
  return newComponent
end

local componentList = newList(x + 3, y + 2, w - 6, h - 3, {},
    function(item)
      return item
    end,
    function(item)
      local c = components[item]
      componentsToAdd = {}

      for _, need in ipairs(c.needs) do
        table.insert(componentsToAdd, createComponent(need))
      end

      table.insert(componentsToAdd, createComponent(item))

      newComponentWindow.visible = false
    end)

for k, v in pairs(components) do
  table.insert(componentList.items, k)
end

newComponentWindow = {
  visible = false,
  render = function(self)
    utils.renderBox(x, y, w, h, colors.lightGray)
    utils.renderLine(x, y, w, 1, colors.gray)
    term.setCursorPos(x, y)
    term.write(title)
    componentList:render()
    closeButton:render()
  end,
  update = function(self, event, var1, var2, var3)
    closeButton:update(event, var1, var2, var3)
    componentList:update(event, var1, var2, var3)
  end
}

return newComponentWindow
