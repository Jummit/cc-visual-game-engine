local utils = {}

function utils.renderBox(x, y, w, h, color)
  paintutils.drawFilledBox(x, y, w + x - 1, h + y - 1, color)
end

function utils.renderLine(x, y, dx, dy, color)
  paintutils.drawLine(x, y, x + dx - 1, y + dy - 1, color)
end

function utils.renderText(x, y, t, color, backgroundColor)
  term.setTextColor(color)
  term.setBackgroundColor(backgroundColor)
  term.setCursorPos(x, y)
  term.write(t)
end

function utils.pointInBox(x, y, w, h, px, py)
  return px >= x and py >= y and px < x + w and py < y + h
end

function utils.clearTable(t)
  for k, v in pairs(t) do
    t[k] = nil
  end
end

function utils.printCenter(x, y, w, h, text, backgroundColor)
  if backgroundColor then
    term.setBackgroundColor(backgroundColor)
  end
  term.setCursorPos(
      x + w / 2 - #text / 2,
      y + h / 2)
  term.write(text)
end

local copyTable
function copyTable(t)
  local n = {}
  for k, v in pairs(t) do
    if type(v) == "table" then
      n[k] = copyTable(v)
    else
      n[k] = v
    end
  end
  return n
end

utils.copyTable = copyTable

return utils
