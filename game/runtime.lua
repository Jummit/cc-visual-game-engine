local components = require "components.components"
local tableUtils = require "utils.table"
local entityUtils = require "utils.entity"
local newKeyboard = require "utils.keyboard"

return function(entities, window)
	return {
		shouldQuit = false,
		window = window,
		delta = 0,
		cameraX = 0, cameraY = 0,
		entities = entities,
		keyboard = newKeyboard(),
		render = function(self)
			local oldTerm = term.redirect(window)
			term.setVisible(false)
			term.setBackgroundColor(colors.white)
			term.clear()
			for _, entity in ipairs(entities) do
				for _, component in ipairs(entity.components) do
					components[component.type].render(entityUtils.entityTable(entity), self)
				end
			end
			term.setVisible(true)
			term.redirect(oldTerm)
		end,
		update = function(self)
			local event, var1, var2, var3 = os.pullEvent()
			
			self.keyboard:update(event, var1, var2, var3)
			
			if event:sub(1, #"mouse") == "mouse" then
				local x, y = term.current().getPosition()
				var2 = var2 - x
				var3 = var3 - y
			end
			
			if self.keyboard.leftCtrl and self.keyboard.q then
				self.shouldQuit = true
				return
			end
			
			if event == "timer" then
				os.startTimer(.1)
			end
			
			for _, entity in ipairs(self.entities) do
				for _, component in ipairs(entity.components) do
					if event == "timer" then
						components[component.type].fixedUpdate(entityUtils.entityTable(entity),
								self, event, var1, var2, var3)
					end
					components[component.type].update(entityUtils.entityTable(entity),
							self, event, var1, var2, var3)
				end
			end
		end,
		run = function(self)
			for id, entity in ipairs(self.entities) do
				for _, component in ipairs(entity.components) do
					component.args.id = id
				end
			end
			
			for _, entity in ipairs(self.entities) do
				for _, component in ipairs(entity.components) do
					components[component.type].init(entityUtils.entityTable(entity))
				end
			end
			local lastUpdate = os.clock()
			os.startTimer(1)
			while true do
				self:render()
				self.delta = os.clock() - lastUpdate
				lastUpdate = os.clock()
				self:update()
				if self.shouldQuit then
					self.window.setVisible(false)
					break
				end
			end
		end
	}
end
