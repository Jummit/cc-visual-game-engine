local components = {}

local template = {
  var1 = 1,
  var2 = "a",
  var3 = {},

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3)
  end,

  needs = {
    "foo"
  }
}

components.pos = {
  x = 1,
  y = 1,

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3)
  end
}

components.sprite = {
  texture = {
      "aaa",
      "bbb",
      "ccc"},

  render = function(self)
    for y = 1, #self.texture do
      local line = self.texture[y]
      for x = 1, #line do
        local char = line[x]
        if type(char) == "string" and #char == 1 then
          term.setCursorPos(x, y)
          term.blit(char, char, char)
        end
      end
    end
  end,
  update = function(self, event, var1, var2, var3)
  end,

  needs = {
    "pos"
  }
}

components.map = {
  render = function(self)
  end,
  update = function(self, event, var1, var2, var3)
  end,

  needs = {
    "pos"
  }
}

return components
