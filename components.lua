local components = {}
local newButton = require "ui.button"
local draw = require "utils.draw"
local mathUtils = require "utils.math"
local colorRadialMenu = require "ui.colorRadialMenu"

local template = {
  args = {
    var1 = 1,
    var2 = "a",
    var3 = {}
  },

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3)
  end,
  editor = function(self, event, var1, var2, var3)
  end,
  editorRender = function(self)
  end,

  needs = {
    "foo"
  }
}

components.pos = {
  args = {
    x = 1,
    y = 1,
  },

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3)
  end,
  editor = function(self, event, var1, var2, var3)
    if event == "key" then
      local k = keys.getName(var1)
      if k == "up" then
        self.y = self.y - 1
      elseif k == "down" then
        self.y = self.y + 1
      end
      if k == "left" then
        self.x = self.x - 1
      elseif k == "right" then
        self.x = self.x + 1
      end
    end
  end,
  editorRender = function(self)
    draw.text(self.x, self.y, "+", colors.lightGray, colors.white)
  end,

  needs = {}
}

components.sprite = {
  args = {
    texture = {}
  },

  render = function(self)
    for x, row in pairs(self.texture) do
      for y, color in pairs(row) do
        if x == 1 and y == 1 then
          draw.text(self.x, self.y, "·", colors.lightGray, color)
        else
          paintutils.drawPixel(self.x + x - 1, self.y + y - 1, color)
        end
      end
    end
  end,
  update = function(self, event, var1, var2, var3)
  end,
  editor = function(self, event, var1, var2, var3)
    if event == "mouse_click" or event == "mouse_drag" then
      if var1 == 2 then
        self.showTools = true
        self.clickedX, self.clickedY = var2, var3
      elseif self.showTools then
        local color = colorRadialMenu.update(self.clickedX, self.clickedY, event, var1, var2, var3)
        self.showTools = false
        self.drawColor = color
      elseif self.drawColor then
        local x = var2 - self.x + 1
        local y = var3 - self.y + 1

        if not self.texture[x] then
          self.texture[x] = {}
        end
        self.texture[x][y] = self.drawColor
      end
    end
  end,
  editorRender = function(self)
    if not (self.texture[1] and self.texture[1][1]) then
      draw.text(self.x, self.y, "·", colors.lightGray, colors.white)
    end
    if self.showTools then
      colorRadialMenu.render(self.clickedX, self.clickedY)
    end
  end,

  needs = {
    "pos"
  }
}

local function drawTile(x, y, tile)
  term.setCursorPos(x, y)
  term.setBackgroundColor(tile.bc)
  term.setTextColor(tile.tc)
  term.write(tile.char)
end

components.map = {
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
  update = function(self, event, var1, var2, var3)
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

components.controllable = {
  args = {
    up = "w",
    down = "s",
    left = "a",
    right = "d"
  },

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3)
    if event == "key" then
      local k = keys.getName(var1)
      if k == self.up then
        self.y = self.y - 1
      elseif k == self.down then
        self.y = self.y + 1
      end

      if k == self.left then
        self.x = self.x - 1
      elseif k == self.right then
        self.x = self.x + 1
      end
    end
  end,
  editor = function(self, event, var1, var2, var3)
  end,
  editorRender = function(self)
  end,

  needs = {
    "pos"
  }
}

for i, comFile in ipairs(fs.list("components")) do
  local comName = comFile:match("(.*).lua")
  components[comName] = require("components."..comName)
end

return components
