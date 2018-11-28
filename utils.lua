local utils = {}

function utils.renderBox(x, y, w, h, color)
  paintutils.drawFilledBox(x, y, w + x - 1, h + y - 1, color)
end

function utils.pointInBox(x, y, w, h, px, py)
  return px >= x and py >= y and px < x + w and py < y + h
end

return utils
