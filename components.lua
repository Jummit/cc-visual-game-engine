local components = {}
local template = {
  args = {
    var1 = 1,
    var2 = "a",
    var3 = {}
  },

  render = function(self)
  end,
  update = function(self, event, var1, var2, var3, entities, keyboard, delta)
  end,
  editor = function(self, event, var1, var2, var3)
  end,
  editorRender = function(self)
  end,

  needs = {
    "foo"
  }
}

for i, comFile in ipairs(fs.list("components")) do
  local comName = comFile:match("(.*).lua")
  components[comName] = require("components."..comName)
end

return components
