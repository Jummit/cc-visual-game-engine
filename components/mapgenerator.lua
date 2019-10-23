return {
	args = {
	},
  init = function(self)
    local width, height = term.getSize()
    local h = height / 2
    local shape = {}
    for x = -width * 10, width * 10 do
      self.tiles[x] = {}
      shape[x] = {}
      for y = -height * 10, height * 10 do
        if y < h then
          tiles[x][y] = 1
        elseif y == h then
          self.shape[x][y] = true
          tiles[x][y] = 3
        elseif y - h > 5 then
          self.shape[x][y] = true
          tiles[x][y] = 4
        else
          self.shape[x][y] = true
          tiles[x][y] = 2
        end
      end
      if math.random(1, 5) == 1 then
        h = h + math.random(-2, 2)
      end
    end
    if self.shape then
      self.shape = shape
    end
	end,
  render = function(self)
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
	end,
	editor = function(self, event, var1, var2, var3, keyboard)
	end,
	editorRender = function(self)
	end,

	needs = {
		"pos",
    "map"
	}
}
