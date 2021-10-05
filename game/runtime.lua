local newKeyboard = require "utils.keyboard"

return function(entities, window)
	return {
		shouldQuit = false,
		window = window,
		delta = 0,
		cameraX = 0, cameraY = 0,
		entities = entities,
		keyboard = newKeyboard(),
		draw = function(self)
			local oldTerm = term.redirect(window)
			window.setVisible(false)
			term.setBackgroundColor(colors.white)
			term.clear()
			for _, entity in ipairs(entities) do
				for _, component in ipairs(entity.components) do
					component.draw(entity, self)
				end
			end
			window.setVisible(true)
			term.redirect(oldTerm)
		end,
		update = function(self)
			local delta = os.clock() - (self.lastUpdate or os.clock())
			self.lastUpdate = os.clock()
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
				os.startTimer(0.05)
			end

			for _, entity in ipairs(self.entities) do
				for _, component in ipairs(entity.components) do
					if event == "timer" then
						component.fixedUpdate(entity, self)
					end
					component.update(entity, self, event, var1, var2, var3, delta)
				end
			end
		end,
		run = function(self)
			self.keyboard = newKeyboard()
			for _, entity in ipairs(self.entities) do
				for _, component in ipairs(entity.components) do
					component.init(entity)
				end
			end
			os.startTimer(1)
			while true do
				self:draw()
				self:update()
				if self.shouldQuit then
					self.window.setVisible(false)
					self.shouldQuit = false
					break
				end
			end
		end
	}
end
