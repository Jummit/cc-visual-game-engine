local args = {...}
require("utils.runSave")(function()
local gameName = args[1] or "helloworld"
local saveFile = "saves/"..gameName..".game"
local w, h = term.getSize()

local entityListHeight = 7
local componentListHeight = 7
local sideBarWidth = 12

local components = require "components"
local utils = require("utils.table").fromFiles("utils")
local ui = utils.table.fromFiles("ui")

local currentWindow
local gameWindow = window.create(term.current(), sideBarWidth + 1, 1, w - sideBarWidth, h)
local runningGameWindow = window.create(gameWindow, 1, 1, w - sideBarWidth, h)
local gameEntities = utils.gameSave.load(saveFile) or {}
local keyboard = require "keyboard"

require("utils.log").clear()
log = require("utils.log").write
cameraX, cameraY = 0, 0

componentList = ui.list({
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

entityList = ui.list({
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
      entityList:getSelected().name = io.read()
    end})

local uiElements = {
  ui.box{
      x = 1, y = 1,
      w = sideBarWidth, h = h,
      color = colors.lightGray},
      entityList,
  componentList,
  ui.centerText{
      x = 2, y = entityListHeight + 2,
      w = sideBarWidth - 2, h = 1,
      text = "Entities",
      textColor = colors.white, backgroundColor = colors.lightGray},
      ui.centerText{
      x = 2, y = entityListHeight + componentListHeight + 4,
      w = sideBarWidth - 2, h = 1,
      text = "Components",
      textColor = colors.white, backgroundColor = colors.lightGray},
  ui.buttons.addAndDelete{
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
  ui.buttons.addAndDelete{
      x = 2, y = entityListHeight + componentListHeight + 3,
      del = function()
        componentList:removeSelected()
      end,
      add = function()
        currentWindow = ui.newComponentWindow()
      end},
  ui.buttons.move{
      x = 6, y = entityListHeight + 1,
      list = entityList},
  ui.buttons.move{
      x = 6, y = entityListHeight + componentListHeight + 3,
      list = componentList},
  ui.button{
      x = w - 3, y = 1,
      w = 4, h = 1,
      label = "save",
      labelColor = colors.green, color = colors.lime, clickedColor = colors.yellow,
      onClick = function()
        utils.gameSave.save(saveFile, gameEntities)
      end},
  ui.button{
      x = w - 3, y = 2,
      w = 3, h = 1,
      label = "run",
      labelColor = colors.blue, color = colors.lightBlue, clickedColor = colors.white,
      onClick = function()
        require("utils.log").clear()
        local runningGameEntities = utils.table.copy(gameEntities)
        utils.game.run(utils.table.copy(gameEntities), runningGameWindow)
      end}
}

local function updateComponentInEditor(component, event, var1, var2, var3)
  if event:sub(1, #"mouse") == "mouse" then
    var2 = var2 - sideBarWidth
  end

  local newWindow = components[component.type].editor(
      utils.entity.entityTable(entityList:getSelected()),
      event, var1, var2, var3, keyboard)
  if newWindow then
    currentWindow = newWindow
  end
end

local function updateEditor(event, var1, var2, var3)
  keyboard:update(event, var1, var2, var3)

  if currentWindow then
    if currentWindow:update(event, var1, var2, var3) then
      currentWindow = nil
    end
  else
    for _, element in pairs(uiElements) do
      if not element.hidden then
        element:update(event, var1, var2, var3)
      end
    end
    
    if not event:find("mouse") or var2 > sideBarWidth then
      if componentList:getSelected() then
        updateComponentInEditor(componentList:getSelected(), event, var1, var2, var3)
      end
    end
  end
end

local function drawEditor()
  if currentWindow then
    currentWindow:render()
  else
    local oldTerm = term.redirect(gameWindow)
    utils.game.render(gameEntities, entityList, componentList, true)
    term.redirect(oldTerm)

    for _, element in pairs(uiElements) do
      if not element.hidden then
        element:render()
      end
    end
  end
end

os.startTimer(0)
while true do
  drawEditor()
  local event, var1, var2, var3 = os.pullEvent()
  keyboard.update(event, var1, var2, var3)
  if keyboard.q and keyboard.leftCtrl then
    break
  end
  updateEditor(event, var1, var2, var3)
end
end)
