local components = {}
local template = {
	args = {
		var1 = 1,
		var2 = "a",
		var3 = {}
	},

	init = function(self)
	end,
	render = function(self)
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
	end,
	editor = function(self, event, var1, var2, var3, keyboard)
	end,
	editorRender = function(self)
	end,

	needs = {
		"foo"
	}
}

for i, componentFile in ipairs(fs.list("components")) do
	local componentName = componentFile:match("(.*).lua")
	components[componentName] = require("components."..componentName)
end

return components
