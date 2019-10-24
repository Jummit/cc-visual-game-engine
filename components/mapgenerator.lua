local mathUtils = require "utils.math"

return {
	args = {
	},
  init = function(self)
    if #self.tileset < 7 then
      return
    end
    local width, height = term.getSize()
    local h = height / 2
    local shape = {}
    local trees = {}
    for x = -width * 10, width * 10 do
      self.tiles[x] = {}
      shape[x] = {}
      for y = -height * 10, height * 10 do
        if y < h then
          self.tiles[x][y] = 1
          if y == h - 1 then
            if math.random(1, 3) == 1 then
              self.tiles[x][y] = 5
            end
            
            if (x/3.0 == math.floor(x/3)) and x > 10 and x < height * 10 -10 and math.random(1, 10) == 1 then
              table.insert(trees, {
                x = x,
                y = y,
                h = math.random(4, 8),
                s = math.random(25, 35) / 10
              })
            end
          end
        elseif y == h then
          shape[x][y] = true
          self.tiles[x][y] = 3
        elseif y - h > 5 then
          shape[x][y] = true
          self.tiles[x][y] = 4
        else
          shape[x][y] = true
          self.tiles[x][y] = 2
        end
      end
      if math.random(1, 5) == 1 then
        h = h + math.random(-2, 2)
      end
    end

    for _, tree in ipairs(trees) do
      for y = tree.y - tree.h, tree.y do
        self.tiles[tree.x][y] = 6
      end
      for x = -tree.s * 2, tree.s * 2 do
        for y = -tree.s * 2, tree.s * 2 do
          if mathUtils.distance(x, y, 0, 0) < tree.s then
            self.tiles[math.floor(x + tree.x)][math.floor(y + tree.y - tree.h)] = 7
          end
        end
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
