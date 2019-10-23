return {
	args = {
	},
  init = function(self)
    local width, height = term.getSize()
    local h = height / 2
    for x = 1, width do
      self.tiles[x] = {}
      self.shape[x] = {}
      for y = 1, height do
        if y < h then
          self.tiles[x][y] = 1
        elseif y == h then
          self.shape[x][y] = true
          self.tiles[x][y] = 3
        elseif y - h > 5 then
          self.shape[x][y] = true
          self.tiles[x][y] = 4
        else
          self.shape[x][y] = true
          self.tiles[x][y] = 2
        end
      end
      if math.random(1, 5) == 1 then
        h = h + math.random(-2, 2)
      end
    end
	end,
  render = function(self)
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
	end,
	editor = function(self, event, var1, var2, var3)
	end,
	editorRender = function(self)
	end,

	needs = {
		"pos",
    "map",
    "collision"
	}
}
