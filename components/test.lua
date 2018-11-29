return {
  args = {
    test = "test"
  },

  render = function(self)
    term.setCursorPos(self.x, self.y)
    term.write(self.test)
  end,
  update = function(self, event, var1, var2, var3)
    if event == "char" then
      self.test = self.test..var1
    end
  end,
  editor = function(self, event, var1, var2, var3)
    update(self, event, var1, var2, var3)
  end,

  needs = {
    "pos"
  }
}
