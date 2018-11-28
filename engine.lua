local newList = require "list"
local utils = require "utils"

local gameEntities = {
  {
    label = "test",
    components = {
      {
        label = "pos"
      },
      {
        label = "map"
      },
      {
        label = "movable"
      }
    }
  },
  {
    label = "map"
  },
  {
    label = "player"
  }
}
local w, h = term.getSize()
local entityListHeight = 8
local componentListHeight = 8
local entityList = newList(
    2, 2, 8, entityListHeight,
    gameEntities)
local componentList = newList(
    2, entityListHeight + 3, 8, componentListHeight,
    gameEntities[1].components)

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
utils.renderBox(1, 1, 10, h, colors.lightGray)
redraw()
while true do
  local event, var1, var2, var3 = os.pullEvent()
  handleEvents(event, var1, var2, var3)
end
