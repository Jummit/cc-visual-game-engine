local success, message = pcall(function()
local w, h = term.getSize()
local buffer = window.create(term.current(), 1, 1, w, h)
local oldTerm = term.redirect(buffer)
local newList = require "list"
local newButton = require "button"
local utils = require "utils"
local components = require "components"
local newAddAndDeleteButtons = require "addAndDeleteButtons"
local newMoveButtons = require "moveButtons"
local newComponentWindow = require "newComponentWindow"
local windowUtils = require "window"

local gameEntities = {}
local localWindow = nil
local entityListHeight = 7
local componentListHeight = 7
local sideBarWidth = 12
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

local function saveGame()
  local file = io.open("saves/test.game", "w")
  file:write(textutils.serialize(gameEntities))
  file:close()
end

local buttons = {
  newAddAndDeleteButtons{
      x = 2, y = entityListHeight + 1,
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
      x = 2, y = entityListHeight + componentListHeight + 3,
      del = function()
        componentList:removeSelected()
      end,
      add = function()
        localWindow = newComponentWindow
      end},
  newMoveButtons{
    x = 6, y = entityListHeight + 1,
    list = entityList
  },
  newMoveButtons{
    x = 6, y = entityListHeight + componentListHeight + 3,
    list = componentList
  },
  newButton{
      x = w - 4, y = 1,
      w = 4, h = 1,
      label = "save",
      labelColor = colors.green, color = colors.lime, clickedColor = colors.yellow,
      onClick = saveGame,}
}

local function loadGame()
  local file = fs.open("saves/test.game", "r")
  local loadEntities = textutils.unserialize(file.readAll())
  for k, v in pairs(loadEntities) do
    gameEntities[k] = utils.copyTable(v)
  end
  file.close()
end

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
  if localWindow then
    windowUtils.render(localWindow)
  else
    utils.renderBox(1, 1, w, h, colors.white)
    utils.renderBox(1, 1, sideBarWidth, h, colors.lightGray)
    entityList:render()
    componentList:render()
    --utils.printCenter(2, 1, sideBarWidth - 2, 1, "Entities", colors.lightGray)
    utils.printCenter(2, entityListHeight + 2, sideBarWidth - 2, 1, "Entities", colors.white, colors.lightGray)
    --utils.printCenter(2, entityListHeight + 3, sideBarWidth - 2, 1, "Components", colors.lightGray)
    utils.printCenter(2, entityListHeight + componentListHeight + 4, sideBarWidth - 2, 1, "Components", colors.white, colors.lightGray)

    local oldTerm = term.redirect(gameWindow)
    term.setBackgroundColor(colors.white)
    term.clear()
    renderGame()
    term.redirect(oldTerm)

    for _, button in ipairs(buttons) do
      button:render()
    end
  end
end

local function handleEvents(event, var1, var2, var3)
  if localWindow then
    if windowUtils.update(localWindow, event, var1, var2, var3) then
      localWindow = nil
    end
  else
    entityList:update(event, var1, var2, var3)
    componentList:update(event, var1, var2, var3)
    for _, button in ipairs(buttons) do
      button:update(event, var1, var2, var3)
    end
    if entityList.selected then
      local event, var1, var2, var3 = event, var1, var2, var3
      if event == "mouse_click" or event == "mouse_up" or event == "mouse_drag" then
        var2 = var2 - sideBarWidth
      end
      local component = componentList.items[componentList.selected]
      local entityVars = getEntityVars(entityList.items[entityList.selected])
      if component then
        components[component.type].editor(setmetatable(component.args, {__index = entityVars}), event, var1, var2, var3)
      end
    end
  end
end

loadGame()
while true do
  buffer.setVisible(false)
  redraw()
  buffer.setVisible(true)
  local event, var1, var2, var3 = os.pullEvent()
  handleEvents(event, var1, var2, var3)
end
end)

local w, h = term.getSize()
local t = window.create(term.native(), 1, 1, w, h)
term.redirect(t)
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1, 2)

if not success then
  term.setTextColor(colors.orange)
  print(message)
end
t:redraw()
