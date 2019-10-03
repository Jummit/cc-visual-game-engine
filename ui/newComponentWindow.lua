local tableUtils = require "utils.table"
local components = require "components"
local newList = require "ui.list"
local newWindow = require "ui.window"

local newComponentList

local function createComponent(type)
  local newComponent = tableUtils.copy(components[type])
  newComponent.type = type
  newComponent.render = nil
  newComponent.update = nil
  newComponent.editor = nil
  newComponent.editorRender = nil
  return newComponent
end

local componentList = newList({
    x = 0, y = 0, w = 0, h = 0,
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
      newComponentList.hidden = true
    end})

for k, v in pairs(components) do
  table.insert(componentList.items, k)
end

newComponentList = newWindow{
  visible = true,
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
  end
}

newComponentList.hidden = true

return newComponentList