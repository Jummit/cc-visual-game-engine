local math = {}

function math.pointInBox(x, y, w, h, px, py)
  return px >= x and py >= y and px < x + w and py < y + h
end

return math
