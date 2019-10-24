local components = require "components"
local tableUtils = require "utils.table"
local entityUtils = require "utils.entity"
local keyboard = require "keyboard"
local game = {}

function game.render(entities, entityList, componentList, inEditor)
	term.setBackgroundColor(colors.white)
	term.clear()
	for n, entity in ipairs(entities) do
		for i, component in ipairs(entity.components) do
			components[component.type].render(entityUtils.entityTable(entity))
			if inEditor and n == entityList.selected and i == componentList.selected then
				components[component.type].editorRender(entityUtils.entityTable(entity))
			end
		end
	end
end

function game.update(entities, lastUpdate)
	local event, var1, var2, var3 = os.pullEvent()
	
	keyboard:update(event, var1, var2, var3)
	
	if event:sub(1, #"mouse") == "mouse" then
		var2 = var2 - sideBarWidth
	end
	
	if keyboard.q then
		return true
	end
	
	if event == "timer" then
		os.startTimer(.1)
	end
	
	for _, entity in ipairs(entities) do
		for _, component in ipairs(entity.components) do
			components[component.type].update(entityUtils.entityTable(entity), event, var1, var2, var3, entities, keyboard, os.clock() - lastUpdate)
		end
	end
end

function game.initEntities(entities)
	for _, entity in ipairs(entities) do
		for _, component in ipairs(entity.components) do
			components[component.type].init(entityUtils.entityTable(entity))
		end
	end
end

function game.run(entities, runningGameWindow)
	for id, entity in ipairs(entities) do
		for _, component in ipairs(entity.components) do
			component.args.id = id
		end
	end
	
	local oldTerm = term.redirect(runningGameWindow)
	
	game.initEntities(entities)
	local lastUpdate = os.clock()
	os.startTimer(1)
	while true do
		runningGameWindow.setVisible(false)
		game.render(entities)
		runningGameWindow.setVisible(true)
		
		if game.update(entities, lastUpdate) then
			runningGameWindow.setVisible(false)
			break
		end
		lastUpdate = os.clock()
	end
	
	cameraX, cameraY = 0, 0
	term.redirect(oldTerm)
end

return game
