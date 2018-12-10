local args = {...}

require("utils.runSave")(function()
-- constants
local gameName = args[1]
local saveFile = "saves/"..gameName..".game"
local w, h = term.getSize()
local entityListHeight = 7
local componentListHeight = 7
local sideBarWidth = 12

-- buffer and game window
local buffer = window.create(term.current(), 1, 1, w, w)
local oldTerm = term.redirect(buffer)
local gameWindow = window.create(term.current(), sideBarWidth + 1, 1, w - sideBarWidth, h)

-- libraries
local newList = require "ui.list"
local newButton = require "ui.button"
local draw = require "utils.draw"
local mathUtils = require "utils.math"
local tableUtils = require "utils.table"
local components = require "components"
local newAddAndDeleteButtons = require "ui.buttons.addAndDelete"
local newMoveButtons = require "ui.buttons.move"
local newComponentWindow = require "ui.newComponentWindow"
local windowUtils = require "ui.window"
local gameSave = require "utils.gameSave"
local entityUtils = require "utils.entity"

-- variables
local gameEntities = gameSave.load(saveFile) or {}
local localWindow = nil

-- lists
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

-- functions
local function renderGame(entities, inEditor)
  term.setBackgroundColor(colors.white)
  term.clear()
  for n, entity in ipairs(entities) do
    local entityVars = entityUtils.getVars(entity)
    for i, component in ipairs(entity.components) do
      setmetatable(component.args, {__index = entityVars})
      components[component.type].render(component.args)
      if n == entityList.selected and i == componentList.selected and inEditor then
        components[component.type].editorRender(component.args)
      end
    end
  end
end

local function updateGame(entities)
  local event, var1, var2, var3 = os.pullEvent()
  for _, entity in ipairs(entities) do
    local entityVars = entityUtils.getVars(entity)
    for _, component in ipairs(entity.components) do
      components[component.type].update(setmetatable(component.args, {__index = entityVars}), event, var1, var2, var3)
    end
  end
end

local function runGame()
  local e = tableUtils.copy(gameEntities)
  local gameTerm = window.create(term.current(), 1, 1, w, h)
  local oldTerm = term.redirect(gameTerm)
  entities = gameEntities
  while true do
    gameTerm.setVisible(false)
    renderGame(e)
    gameTerm.setVisible(true)
    updateGame(e)
  end
  term.redirect(oldTerm)
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
      x = w - 3, y = 1,
      w = 4, h = 1,
      label = "save",
      labelColor = colors.green, color = colors.lime, clickedColor = colors.yellow,
      onClick = function()
        gameSave.save(saveFile, gameEntities)
      end},
  newButton{
      x = w - 3, y = 2,
      w = 3, h = 1,
      label = "run",
      labelColor = colors.blue, color = colors.lightBlue, clickedColor = colors.white,
      onClick = runGame},

}

function redraw()
  if localWindow then
    windowUtils.render(localWindow)
  else
    draw.box(1, 1, w, h, colors.white)
    draw.box(1, 1, sideBarWidth, h, colors.lightGray)
    entityList:render()
    componentList:render()
    --utils.printCenter(2, 1, sideBarWidth - 2, 1, "Entities", colors.lightGray)
    draw.center(2, entityListHeight + 2, sideBarWidth - 2, 1, "Entities", colors.white, colors.lightGray)
    --utils.printCenter(2, entityListHeight + 3, sideBarWidth - 2, 1, "Components", colors.lightGray)
    draw.center(2, entityListHeight + componentListHeight + 4, sideBarWidth - 2, 1, "Components", colors.white, colors.lightGray)

    local oldTerm = term.redirect(gameWindow)
    renderGame(gameEntities, true)
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
      local entityVars = entityUtils.getVars(entityList.items[entityList.selected])
      if component then
        components[component.type].editor(setmetatable(component.args, {__index = entityVars}), event, var1, var2, var3)
      end
    end
  end
end

while true do
  buffer.setVisible(false)
  redraw()
  buffer.setVisible(true)
  local event, var1, var2, var3 = os.pullEvent()
  handleEvents(event, var1, var2, var3)
end
end)
