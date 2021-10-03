local components = {}
--[[
local template = {
	args = {
		var1 = 1,
		var2 = "a",
		var3 = {}
	},
	needs = {
		"foo"
	},
	init = function(self)
	end,
	render = function(self)
	end,
	update = function(self, game, event, var1, var2, var3, delta)
	end,
	fixedUpdate = function(self, game)
	end,
	editorUpdate = function(self, editor, game, event, var1, var2, var3)
	end,
	editorRender = function(self, editor, game)
	end,
}
]]

for i, componentFile in ipairs(fs.list("components")) do
	if componentFile ~= "components.lua" then
		local componentName = componentFile:match("(.*).lua")
		components[componentName] = require("components."..componentName)
	end
end

return components
