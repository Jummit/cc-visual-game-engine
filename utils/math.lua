local mathUtils = {}

function mathUtils.pointInBox(x, y, w, h, px, py)
	return px >= x and py >= y and px < x + w and py < y + h
end

function mathUtils.distance(x1, y1, x2, y2)
	return math.sqrt((x2-x1)^2+(y2-y1)^2)
end

return mathUtils
