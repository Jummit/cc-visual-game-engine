local success, message = pcall(function()
local newList = require "list"
local utils = require "utils"
local components = require "components"
local newAddAndDeleteButtons = require "addAndDeleteButtons"
local newMoveButtons = require "moveButtons"
local newComponentWindow = require "newComponentWindow"

local gameEntities = {}

local w, h = term.getSize()
local entityListHeight = 7
local componentListHeight = 7
local sideBarWidth = 13
local gameWindow = window.create(term.current(), sideBarWidth + 1, 1, w - sideBarWidth - 1, h)

componentList = newList({
    x = 2, y = entityListHeight + 4,
    w = sideBarWidth - 2, h = componentListHeight,
    items = {},
    getLabel = function(item)
      return item.type
    end,
    shouldDelete = function(components, toDelete)
      for _, c in ipairs(components.items) do
        for _, need in ipairs(c.needs) do
          if toDelete.type == need then
            return false
          end
        end
      end
      return true
    end})

entityList = newList({
    x = 2, y = 2,
    w = sideBarWidth - 2, h = entityListHeight,
    items = gameEntities,
    getLabel = function(item)
      return item.name
    end,
    onItemSelected = function(item)
      componentList.items = item.components
      componentList:select(1)
    end,
    onDoubleClick = function(item)
      term.setCursorPos(entityList.x, entityList.y + entityList.selected - 1)
      term.setBackgroundColor(colors.gray)
      term.setTextColor(colors.white)
      entityList.items[entityList.selected].name = io.read()
    end})

local buttons = {
  newAddAndDeleteButtons{
      x = 2, y = entityListHeight + 2,
      del = function()
        componentList.items = {}
        entityList:removeSelected()
      end,
      add = function()
        entityList:add({
          name = "new",
          components = {}
        })
      end},
  newAddAndDeleteButtons{
      x = 2, y = entityListHeight + componentListHeight + 4,
      del = function()
        componentList:removeSelected()
      end,
      add = function()
        newComponentWindow.visible = true
      end},
  newMoveButtons{
    x = 6, y = entityListHeight + 2,
    list = entityList
  },
  newMoveButtons{
    x = 6, y = entityListHeight + componentListHeight + 4,
    list = componentList
  }
}

local function getEntityVars(entity)
  local entityVars = {}
  for _, component in ipairs(entity.components) do
    for k, v in pairs(component.args) do
      entityVars[k] = v
    end
  end
  return entityVars
end

local function renderGame()
  for _, entity in ipairs(gameEntities) do
    local entityVars = getEntityVars(entity)
    for _, component in ipairs(entity.components) do
      components[component.type].render(setmetatable(component.args, {__index = entityVars}))
    end
  end
end

function redraw()
  if newComponentWindow.visible then
    newComponentWindow:render()
  else
    utils.renderBox(1, 1, w, h, colors.white)
    utils.renderBox(1, 1, sideBarWidth, h, colors.lightGray)
    entityList:render()
    componentList:render()
    for _, button in ipairs(buttons) do
      button:render()
    end

    local oldTerm = term.redirect(gameWindow)
    term.setBackgroundColor(colors.white)
    term.clear()
    renderGame()
    term.redirect(oldTerm)
  end
end

local function handleEvents(event, var1, var2, var3)
  if newComponentWindow.visible then
    newComponentWindow:update(event, var1, var2, var3)
  else
    entityList:update(event, var1, var2, var3)
    componentList:update(event, var1, var2, var3)
    for _, button in ipairs(buttons) do
      button:update(event, var1, var2, var3)
    end
    local component = componentList.items[componentList.selected]
    if component then
      components[component.type].editor(setmetatable(component.args, {__index = entityVars}), event, var1, var2, var3)
    end
  end
end

while true do
  redraw()
  local event, var1, var2, var3 = os.pullEvent()
  handleEvents(event, var1, var2, var3)
end
end)

term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1, 1)

if not success then
  term.setTextColor(colors.orange)
  print(message)
end
