return {
  args = {
    shape = {}
  },

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3, entities, keyboard, delta)
  end,
  editor = function(self, event, var1, var2, var3)
    if event == "mouse_click" or event == "mouse_drag" then
      local x = var2 - self.x + 1
      local y = var3 - self.y + 1

      if not self.shape[x] then
        self.shape[x] = {}
      end
      self.shape[x][y] = (var1 == 1)
    end
  end,
  editorRender = function(self)
    for x, row in pairs(self.shape) do
      for y, on in pairs(row) do
        if on then
          paintutils.drawPixel(self.x + x - 1, self.y + y - 1, colors.lightBlue)
        end
      end
    end
  end,

  needs = {
    "pos"
  }
}
