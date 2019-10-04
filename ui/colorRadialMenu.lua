local gradient = {
  "gray", "lightGray", "red", "black", "brown", "orange", "yellow", "lime", "green", "cyan", "blue", "lightBlue", "purple", "magenta", "pink", "white", "transparent"
}
local radius = 3
local function getSegmentPos(x, y, segment)
  local r = (math.pi / #gradient * 2) * segment
  return
      math.floor(x + math.sin(r) * radius),
      math.floor(y + math.cos(r) * radius)
end

return {
  render = function(x, y)
    for segment = 1, #gradient do
      local x, y = getSegmentPos(x, y, segment)
      if gradient[segment] == "transparent" then
        term.setCursorPos(x, y)
        term.blit("x", "e", "0")
      else
        paintutils.drawPixel(x, y, colors[gradient[segment]])
      end
    end
  end,
  update = function(x, y, event, var1, var2, var3)
    if event == "mouse_click" and var1 == 1 then
      for segment = 1, #gradient do
        local x, y = getSegmentPos(x, y, segment)
        if var2 == x and var3 == y then
          if gradient[segment] == "transparent" then
            return -1
          end
          return colors[gradient[segment]]
        end
      end
      return
    end
  end
}
