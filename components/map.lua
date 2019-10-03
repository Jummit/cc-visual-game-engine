local newButton = require "ui.button"
local draw = require "utils.draw"
local colorRadialMenu = require "ui.colorRadialMenu"
local window = require "ui.window"
local mathUtils = require "utils.math"

local function drawTile(x, y, tile)
  term.setCursorPos(x, y)
  term.setBackgroundColor(tile.bc)
  term.setTextColor(tile.tc)
  term.write(tile.char)
end

local showTileEditorColorWheel = false
local tileEditorColorWheelParam

local mapButtons = {
  newButton{
    x = 12, y = 5, w = 16, h = 3,
    label = "Edit Character",
    color = colors.gray, labelColor = colors.lightGray,
    clickedColor = colors.white,
    onClick = function(self)
      _, self.tile.char = os.pullEvent("char")
    end
  },
  newButton{
    x = 12, y = 9, w = 16, h = 3,
    label = "Edit Color",
    color = colors.gray, labelColor = colors.lightGray,
    clickedColor = colors.white,
    onClick = function(self)
      tileEditorColorWheelParam = "bc"
      showTileEditorColorWheel = true
    end
  },
  newButton{
    x = 12, y = 13, w = 16, h = 3,
    label = "Edit Text Color",
    color = colors.gray, labelColor = colors.lightGray,
    clickedColor = colors.white,
    onClick = function(self)
      tileEditorColorWheelParam = "tc"
      showTileEditorColorWheel = true
    end
  }
}

local mapWindow = window{
  tile = nil,
  render = function(self, x, y, w, h)
    local tx, ty = x + 18, y + 3
    for x = 1, 5 do
      for y = 1, 4 do
        drawTile(tx + x, ty + y, self.tile)
      end
    end
    for _, button in ipairs(mapButtons) do
      button:render()
    end
    if showTileEditorColorWheel then
      colorRadialMenu.render(35, 10)
    end
  end,
  update = function(self, event, var1, var2, var3)
    for _, button in ipairs(mapButtons) do
      button.tile = self.tile
      button:update(event, var1, var2, var3)
    end
    if showTileEditorColorWheel then
      local c = colorRadialMenu.update(35, 10, event, var1, var2, var3)
      if c then
        showTileEditorColorWheel = false
        self.tile[tileEditorColorWheelParam] = c
      end
    end
  end,
  title = "Tile editor"
}

return {
  args = {
    tiles = {},
    tileset = {
      {
        bc = colors.blue,
        tc = colors.lightBlue,
        char = "~"
      },
      {
        bc = colors.green,
        tc = colors.green,
        char = " "
      }
    }
  },

  render = function(self)
    for x = 1, #self.tiles do
      for y = 1, #self.tiles[x] do
        drawTile(self.x + x - 1, self.y + y - 1, self.tileset[self.tiles[x][y]])
      end
    end
  end,
  update = function(self, event, var1, var2, var3, entities, keyboard, delta)
  end,
  editor = function(self, event, var1, var2, var3)
    if #self.tiles == 0 then
      for x = 1, 50 do
        self.tiles[x] = {}
        for y = 1, 50 do
          self.tiles[x][y] = 1
        end
      end
    end

    if event == "mouse_click" or event == "mouse_drag" then
      local didSelectTile = false
      for i, tile in ipairs(self.tileset) do
        if mathUtils.pointInBox(i * 2 - 1, 1, 2, 2, var2, var3) then
          if var1 == 1 then
            self.selectedTile = i
          elseif var1 == 2 then
            mapWindow.tile = self.tileset[i]
            return mapWindow
          else
            table.remove(self.tileset, i)
          end
          didSelectTile = true
        end
      end
      if var2 == #self.tileset * 2 + 1 and var3 == 1 then
        didSelectTile = true
        table.insert(self.tileset, {
          tc = colors.magenta,
          bc = colors.black,
          char = "\153"
        })
      end
      if not didSelectTile then
        local x = var2 - self.x + 1
        local y = var3 - self.y + 1
        if self.selectedTile and x > 0 and y > 0 and x <= #self.tiles and y <= #self.tiles[1] then
          if not self.tiles[x] then
            self.tiles[x] = {}
          end
          self.tiles[x][y] = self.selectedTile
        end
      end
    end
  end,
  editorRender = function(self)
    for i, tile in ipairs(self.tileset) do
      drawTile(i * 2, 1, tile)
      drawTile(i * 2, 2, tile)
      drawTile(i * 2 - 1, 1, tile)
      drawTile(i * 2 - 1, 2, tile)
    end
    draw.text(#self.tileset * 2 + 1, 1, "+", colors.lightGray, colors.gray)
  end,

  needs = {
    "pos"
  }
}
