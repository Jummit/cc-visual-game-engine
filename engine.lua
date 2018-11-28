local success, message = pcall(function()
local newList = require "list"
local utils = require "utils"
local components = require "components"
local newAddAndDeleteButtons = require "addAndDeleteButtons"
local newComponentWindow = require "newComponentWindow"

local gameEntities = {
  {
    name = "enemy",
    components = {
      {
        type = "pos",
        args = {
          x = 2,
          y = 4
        }
      },
      {
        type = "sprite",
        args = {
          x = 10,
          y = 4
        }
      }
    }
  },
  {
    name = "map",
    components = {
      {
        type = "pos",
        args = {
          x = 2,
          y = 4
        }
      },
      {
        type = "map",
        args = {

        }
      }
    }
  },
  {
    name = "player",
    components = {
      {
        type = "controllable",
        args = {

        }
      },
      {
        type = "sprite",
        args = {

        }
      },
      {
        type = "pos",
        args = {
          x = 10,
          y = 10
        }
      }
    }
  }
}

local w, h = term.getSize()
local entityListHeight = 7
local componentListHeight = 7
local sideBarWidth = 12
local gameWindow = window.create(term.current(), sideBarWidth + 1, 1, w - sideBarWidth - 1, h)

local componentList = newList(
    2, entityListHeight + 4, sideBarWidth - 2, componentListHeight,
    gameEntities[1].components,
    function(item)
      return item.type
    end,
    function(item)

    end)

local entityList = newList(
    2, 2, sideBarWidth - 2, entityListHeight,
    gameEntities,
    function(item)
      return item.name
    end,
    function(item)
      componentList.items = item.components
      componentList:select(1)
    end)

local buttons = {
  newAddAndDeleteButtons(
      2, entityListHeight + 2,
      function()
        componentList:clear()
        entityList:removeSelected()
      end,
      function()
        entityList:add({
          name = "new",
          components = {}
        })
      end),
  newAddAndDeleteButtons(
      2, entityListHeight + componentListHeight + 4,
      function()
        componentList:removeSelected()
      end,
      function()
        newComponentWindow.visible = true
      end),
}

local function renderGame()
  for _, entity in ipairs(gameEntities) do
    local entityVars = {}
    for _, component in ipairs(entity.components) do
      for k, v in pairs(component.args) do
        entityVars[k] = v
      end
    end
    for _, component in ipairs(entity.components) do
      local c = components[component.type]
      c.render(setmetatable(entityVars, {
          __index = c.args}))
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
