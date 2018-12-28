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
local components = require "components"
local tableUtils = require "utils.table"
local ui = tableUtils.fromFiles("ui")
local utils = tableUtils.fromFiles("utils")
local gameEntities = utils.gameSave.load(saveFile) or {}
Keyboard = require "keyboard"

-- lists
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
      entityList.items[entityList.selected].name = io.read()
    end})

-- ui
local uiElements
uiElements = {
  {
    render = function() end,
    update = function() end,
    visible = false
  },
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
        uiElements[1] = ui.newComponentWindow
        uiElements[1].visible = true
      end},
  ui.buttons.move{
    x = 6, y = entityListHeight + 1,
    list = entityList
  },
  ui.buttons.move{
    x = 6, y = entityListHeight + componentListHeight + 3,
    list = componentList
  },
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
        utils.game.run(gameEntities)
      end}
}

function redraw()
  if uiElements[1].visible then
    uiElements[1]:render()
  else
    -- draw game window
    local oldTerm = term.redirect(gameWindow)
    utils.game.render(gameEntities, entityList, componentList, true)
    term.redirect(oldTerm)

    -- draw ui elements
    for _, element in ipairs(uiElements) do
      element:render()
    end
  end
end

local function updateComponentInEditor(component, event, var1, var2, var3)
  -- calculate mouse position
  if event:sub(1, #"mouse" + 1) == "mouse" then
    var2 = var2 - sideBarWidth
  end

  -- update component
  setmetatable(component.args, {__index = utils.entity.getVars(entityList.items[entityList.selected])})
  components[component.type].editor(component.args, event, var1, var2, var3)
end

local function handleEvents(event, var1, var2, var3)
  if event == "timer" then
    os.startTimer(0)
  end

  Keyboard:update(event, var1, var2, var3)

  -- update window if it is visible
  if uiElements[1].visible then
    uiElements[1]:update(event, var1, var2, var3)
  else
    -- update ui
    for _, element in ipairs(uiElements) do
      element:update(event, var1, var2, var3)
    end

    -- update the selected component if there is one
    local component = componentList.items[componentList.selected]
    if component then
      updateComponentInEditor(component, event, var1, var2, var3)
    end
  end
end

os.startTimer(0)
while true do
  buffer.setVisible(false)
  redraw()
  buffer.setVisible(true)
  local event, var1, var2, var3 = os.pullEvent()
  handleEvents(event, var1, var2, var3)
end
end)
