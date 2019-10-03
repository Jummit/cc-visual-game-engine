local oldMath = math
local math = {}

function math.pointInBox(x, y, w, h, px, py)
  return px >= x and py >= y and px < x + w and py < y + h
end

function math.distance(x1, y1, x2, y2)
  return oldMath.sqrt((x2-x1)^2+(y2-y1)^2)
end

return math
