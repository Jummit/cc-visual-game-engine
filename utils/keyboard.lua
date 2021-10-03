return function ()
	return {
		update = function(self, event, var1)
			if event == "key" then
				self[keys.getName(var1)] = true
			elseif event == "key_up" then
				self[keys.getName(var1)] = false
			end
		end
	}
end