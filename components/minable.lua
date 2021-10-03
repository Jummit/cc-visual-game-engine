local entityUtils = require "game.entityUtils"
local inventoryUtils = require "game.inventory"

return {
	needs = {
		"map"
	},
	update = function(self, game, event, var1, var2, var3)
		if event == "mouse_click" or event == "mouse_drag" then
			local tx, ty = math.floor(var2 - game.cameraX - self.x + 2), math.floor(var3 - game.cameraY - self.y + 2)
			local tile
			if self.tiles[tx] and self.tiles[tx][ty] then
				tile = self.tiles[tx][ty]
			end
			local inventory = entityUtils.findEntityWithComponent(game.entities, "inventory")

			if inventory and inventory.holding.amount and tile == nil then
				if self.shape then
					if not self.tiles[tx] then
						self.tiles[tx] = {}
					end
					if not self.shape[tx] then
						self.shape[tx] = {}
					end
					self.tiles[tx][ty] = tonumber(inventory.holding.name)
					self.shape[tx][ty] = true
				end
				inventory.holding.amount = inventory.holding.amount - 1
				if inventory.holding.amount == 0 then
					inventory.holding = {}
				end
			elseif tile ~= nil then
				local item = {
						name = tostring(tile),
						amount = 1,
						texture = self.tileset[tile]}
				
				if inventory then
					inventoryUtils.insert(inventory, item)
				end
				
				self.tiles[tx][ty] = nil
				if self.shape then
					self.shape[tx][ty] = false
				end
			end
		end
	end,
}