local draw = {}

function draw.box(x, y, w, h, color)
	paintutils.drawFilledBox(
			x, y,
			w + x - 1, h + y - 1,
			color)
end

function draw.line(x, y, dx, dy, color)
	paintutils.drawLine(
			x, y,
			x + dx - 1, y + dy - 1,
			color)
end

function draw.setColors(textColor, backgroundColor)
	term.setTextColor(textColor)
	term.setBackgroundColor(backgroundColor)
end

function draw.text(x, y, text, textColor, backgroundColor)
	draw.setColors(textColor, backgroundColor)
	term.setCursorPos(x, y)
	term.write(text)
end

function draw.centerText(x, y, w, h, text, textColor, backgroundColor)
	draw.setColors(textColor, backgroundColor)
	term.setCursorPos(
			x + w / 2 - #text / 2,
			y + h / 2)
	term.write(text)
end

return draw
