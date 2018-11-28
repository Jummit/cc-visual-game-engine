local newList = require "list"
local utils = require "utils"

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
local entityListHeight = 8
local componentListHeight = 8
local sideBarWidth = 12

local componentList = newList(
    2, entityListHeight + 3, sideBarWidth - 2, componentListHeight,
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


local function renderGame()

end

local function redraw()
  entityList:render()
  componentList:render()
  renderGame()
end

local function handleEvents(event, var1, var2, var3)
  entityList:update(event, var1, var2, var3)
  componentList:update(event, var1, var2, var3)
end

utils.renderBox(1, 1, w, h, colors.white)
utils.renderBox(1, 1, sideBarWidth, h, colors.lightGray)
redraw()
while true do
  local event, var1, var2, var3 = os.pullEvent()
  handleEvents(event, var1, var2, var3)
end
