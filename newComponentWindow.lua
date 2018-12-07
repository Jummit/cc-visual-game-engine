local utils = require "utils"
local components = require "components"
local newList = require "list"

local close = false

local function createComponent(type)
  local newComponent = utils.copyTable(components[type])
  newComponent.type = type
  newComponent.render = nil
  newComponent.update = nil
  newComponent.editor = nil
  return newComponent
end

local componentList = newList({
    items = {},
    getLabel = function(item)
      return item
    end,
    onDoubleClick = function(item)
      local c = components[item]

      for _, need in ipairs(c.needs) do
        local needExists = false
        for _, component in ipairs(componentList.items) do
          if need == component.type then
            needExists = true
          end
        end
        if not needExists then
          componentList:add(createComponent(need))
        end
      end

      componentList:add(createComponent(item))
      close = true
    end})

for k, v in pairs(components) do
  table.insert(componentList.items, k)
end

return {
  title = "Choose a component",
  render = function(self, x, y, w, h)
    componentList.x = x
    componentList.y = y
    componentList.w = w
    componentList.h = h
    componentList:render()
  end,
  update = function(self, event, var1, var2, var3)
    componentList:update(event, var1, var2, var3)
    if close then
      close = false
      return true
    end
  end
}
