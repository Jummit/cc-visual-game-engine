local draw = {}

function draw.box(x, y, w, h, color)
	paintutils.drawFilledBox(
			x, y,
			x + w - 1, y + h - 1,
			color)
end

function draw.line(x, y, dx, dy, color)
	paintutils.drawLine(
			x, y,
			x + dx, y + dy,
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

function draw.pixelTexture(x, y, tile)
	term.setCursorPos(x, y)
	term.setBackgroundColor(tile.bc)
	term.setTextColor(tile.tc)
	term.write(tile.char)
end

function draw.newPixelTexture(bc, tc, char)
	return {
		bc = bc,
		tc = tc,
		char = char
	}
end

return draw
