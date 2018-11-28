local success, message = pcall(function()
local newList = require "list"
local utils = require "utils"
local newAddAndDeleteButtons = require "addAndDeleteButtons"

local gameEntities = {
  {
    name = "enemy",
    components = {
      {
        type = "pos"
      },
      {
        type = "enemyai"
      },
      {
        type = "light"
      }
    }
  },
  {
    name = "map",
    components = {
      {
        type = "pos"
      },
      {
        type = "map"
      },
      {
        type = "collision"
      }
    }
  },
  {
    name = "player",
    components = {
      {
        type = "pos"
      },
      {
        type = "light"
      },
      {
        type = "movable"
      }
    }
  }
}
local w, h = term.getSize()
local entityListHeight = 7
local componentListHeight = 8
local sideBarWidth = 12

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
      componentList.selected = 1
      componentList:render()
    end)

--[[local buttons = {
  newButton(
      2, entityListHeight + 2, 5, 1,
      "del",
      colors.red, colors.orange, colors.white,
      function()
      end),
  newButton(
      sideBarWidth - 5, entityListHeight + 2, 5, 1,
      "add",
      colors.green, colors.lime, colors.white,
      function()
      end)
}]]
local buttons = {
  newAddAndDeleteButtons(
      2, entityListHeight + 2,
      function()
      end,
      function()
      end)
}

local function renderButtons()
  for _, button in ipairs(buttons) do
    button:render()
  end
end

local function updateButtons(event, var1, var2, var3)
  for _, button in ipairs(buttons) do
    button:update(event, var1, var2, var3)
  end
end

local function renderGame()

end

local function redraw()
  entityList:render()
  componentList:render()
  renderGame()
  renderButtons()
end

local function handleEvents(event, var1, var2, var3)
  entityList:update(event, var1, var2, var3)
  componentList:update(event, var1, var2, var3)
  updateButtons(event, var1, var2, var3)
end

utils.renderBox(1, 1, w, h, colors.white)
utils.renderBox(1, 1, sideBarWidth, h, colors.lightGray)
redraw()
while true do
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
