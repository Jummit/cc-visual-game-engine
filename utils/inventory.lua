local inventory = {}

inventory.insert = function(inventory, item)
	local slots = inventory.slots
	for _, slot in ipairs(slots) do
		if slot.name == item.name then
			slot.amount = slot.amount + item.amount
			return
		end
	end
	for slotNum, slot in ipairs(slots) do
		if not slot.amount then
			slots[slotNum] = item
			return
		end
	end
end

return inventory