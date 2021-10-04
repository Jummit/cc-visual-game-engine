return function(t)
	return setmetatable(t, {__index = {
		draw = function(self)
		end,
		update = function(self)
		end
	}})
end
