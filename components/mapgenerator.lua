local mathUtils = require "utils.math"

local generateSlice = function(self, x, height, terrainHeight)
	local shape = {}
	self.tiles[x] = {}
	for y = -height, height do
		if y < terrainHeight then
			self.tiles[x][y] = 1
			if y == terrainHeight - 1 then
				if math.random(1, 3) == 1 then
					self.tiles[x][y] = 5
				end
			end
		elseif y == terrainHeight then
			shape[x][y] = true
			self.tiles[x][y] = 3
		elseif y - terrainHeight > 5 then
			shape[x][y] = true
			self.tiles[x][y] = 4
		else
			shape[x][y] = true
			self.tiles[x][y] = 2
		end
	end
	return shape
end

local function generateTree(self, tree)
	-- trunk
	for y = tree.y - tree.terrainHeight, tree.y do
		self.tiles[tree.x][y] = 6
	end
	-- leaves
	for x = -tree.s * 2, tree.s * 2 do
		for y = -tree.s * 2, tree.s * 2 do
			if mathUtils.distance(x, y, 0, 0) < tree.s then
				self.tiles[math.floor(x + tree.x)][math.floor(y + tree.y - tree.terrainHeight)] = 7
			end
		end
	end
end

local function shouldGenerateTree(x, height)
	return (x / 3 == math.floor(x / 3)) and x > 10 and x < height - 10 and math.random(1, 10) == 1
end

local function newTree(x, terrainHeight)
	return {
		x = x,
		y = terrainHeight - 1,
		terrainHeight = math.random(4, 8),
		s = math.random(25, 35) / 10
	}
end

return {
	args = {
	},
	init = function(self)
		if #self.tileset < 7 then
			return
		end
		
		local width, height = term.getSize()
		width = width * 10
		height = height * 10
		local terrainHeight = height / 2
		local shape = {}
		local trees = {}
		
		for x = -width, width do
			shape[x] = generateSlice(self, x, height, terrainHeight)
			
			if shouldGenerateTree(x, height) then
				table.insert(trees, newTree(x, terrainHeight))
			end
			
			if math.random(1, 5) == 1 then
				terrainHeight = terrainHeight + math.random(-2, 2)
			end
		end
		
		for _, tree in ipairs(trees) do
			generateTree(self, tree)
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
