local components = {}

for _, componentFile in ipairs(fs.list("components")) do
	if componentFile ~= "components.lua" then
		local componentName = componentFile:match("(.*).lua")
		components[componentName] = setmetatable(require(
					"components."..componentName), {__index = {
			args = {},
			editorArgs = {},
			needs = {},
			init = function(self)
			end,
			draw = function(self, game)
			end,
			update = function(self, game, event, var1, var2, var3, delta)
			end,
			fixedUpdate = function(self, game)
			end,
			updateEditor = function(self, editor, game, event, var1, var2, var3)
			end,
			drawEditor = function(self, editor, game)
			end,
			updateInspector = function(self, editor, game, event, var1, var2, var3)
			end,
			drawInspector = function(self, editor, game)
			end,
		}})
	end
end

return components