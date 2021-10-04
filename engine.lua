local args = {...}
require("utils.runSave")(function()
local editor = require("editor")(args[0])
local keyboard = require("utils.keyboard")()
editor:init()
os.startTimer(0)
while true do
	editor:draw()
	local event, var1, var2, var3 = os.pullEvent()
	keyboard:update(event, var1)
	if keyboard.q and keyboard.leftCtrl or editor.shouldQuit then
		break
	end
	editor:update(event, var1, var2, var3)
end
end)
