local draw = {}

function draw.box(x, y, w, h, color)
  paintutils.drawFilledBox(x, y, w + x - 1, h + y - 1, color)
end

function draw.render(x, y, dx, dy, color)
  paintutils.drawLine(x, y, x + dx - 1, y + dy - 1, color)
end

function draw.line(x, y, dx, dy, color)
  paintutils.drawLine(x, y, x + dx - 1, y + dy - 1, color)
end

function draw.text(x, y, t, color, backgroundColor)
  term.setTextColor(color)
  term.setBackgroundColor(backgroundColor)
  term.setCursorPos(x, y)
  term.write(t)
end

function draw.center(x, y, w, h, text, textColor, backgroundColor)
  term.setTextColor(textColor)
  if backgroundColor then
    term.setBackgroundColor(backgroundColor)
  end
  term.setCursorPos(
      x + w / 2 - #text / 2,
      y + h / 2)
  term.write(text)
end

return draw
