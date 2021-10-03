local camera = {}

camera.centerOn = function(x, y)
	local w, h = term.getSize()
	return -x + w / 2, -y + h / 2
end

return camera