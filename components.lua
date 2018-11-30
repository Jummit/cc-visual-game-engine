local components = {}

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

  needs = {}
}

components.sprite = {
  args = {
    texture = {
        " 3333 ",
        "3b33b3",
        "333333",
        "3bbbb3",
        " 3333 "},
  },

  render = function(self)
    for y = 1, #self.texture do
      local line = self.texture[y]
      for x = 1, #line do
        local char = string.sub(line, x, x)
        if type(char) == "string" and char ~= " " then
          term.setCursorPos(self.x + x, self.y + y)
          term.blit(char, char, char)
        end
      end
    end
  end,
  update = function(self, event, var1, var2, var3)
  end,
  editor = function(self, event, var1, var2, var3)
  end,

  needs = {
    "pos"
  }
}

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
        term.setCursorPos(self.x + x - 1, self.y + y - 1)
        local tile = self.tileset[self.tiles[x][y]]
        term.setBackgroundColor(tile.bc)
        term.setTextColor(tile.tc)
        term.write(tile.char)
      end
    end
  end,
  update = function(self, event, var1, var2, var3)
  end,
  editor = function(self, event, var1, var2, var3)
    if #self.tiles == 0 then
      for x = 1, 10 do
        self.tiles[x] = {}
        for y = 1, 10 do
          self.tiles[x][y] = 1
        end
      end
    end
    if event == "mouse_click" or event == "mouse_drag" then
      local x = var2 - self.x + 1
      local y = var3 - self.y + 1
      if x > 0 and y > 0 and x <= #self.tiles and y <= #self.tiles[1] then
        if not self.tiles[x] then
          self.tiles[x] = {}
        end
        self.tiles[x][y] = 2
      end
    end
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
  end,
  editor = function(self, event, var1, var2, var3)
  end,

  needs = {
    "pos"
  }
}

return components
