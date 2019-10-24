local entityUtils = require "utils.entity"
local inventoryUtils = require "utils.inventory"

return {
	args = {},
	
	init = function(self)
	end,
	render = function(self)
	end,
	update = function(self, event, var1, var2, var3, entities, keyboard, delta)
		if event == "mouse_click" or event == "mouse_drag" then
			local tx, ty = math.floor(var2 - cameraX), math.floor(var3 - cameraY)
			local tile = self.tiles[tx][ty]
			local inventory = entityUtils.findEntityWithComponent(entities, "inventory")
			
			if inventory.holding.amount and tile == 1 then
				self.tiles[tx][ty] = tonumber(inventory.holding.name)
				self.shape[tx][ty] = true
				inventory.holding.amount = inventory.holding.amount - 1
				if inventory.holding.amount == 0 then
					inventory.holding = {}
				end
			elseif tile ~= 1 then
				local item = {
						name = tostring(tile),
						amount = 1,
						texture = self.tileset[tile]}
				inventoryUtils.insert(inventory, item)
				
				self.tiles[tx][ty] = 1
				self.shape[tx][ty] = false
			end
		end
	end,
	editor = function(self, event, var1, var2, var3, keyboard)
	end,
	editorRender = function(self)
	end,
	
	needs = {
		"map"
	}
}