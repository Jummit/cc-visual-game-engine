local tableUtils = require "utils.table"
local entityUtils = {}

function entityUtils.entityTable(entity)
	local entityTable = {}
	setmetatable(entityTable, {
		__index = function(self, key)
			for _, component in ipairs(entity.components) do
				if component.args[key] ~= nil then
					return component.args[key]
				end
			end
		end,
		__newindex = function(self, key, value)
			for _, component in ipairs(entity.components) do
				if component.args[key] ~= nil then
					component.args[key] = value
				end
			end
		end
	})
	return entityTable
end

function entityUtils.areColliding(entity1, entity2)
	if not (entity1.shape and entity2.shape) or (entity1 == entity2) then
		return
	end
	for x, row in pairs(entity1.shape) do
		for y, on in pairs(row) do
			if on then
				local x = math.floor(x + entity1.x - entity2.x)
				local y = math.floor(y + entity1.y - entity2.y)
				if entity2.shape[x] and entity2.shape[x][y] then
					return true
				end
			end
		end
	end
end

function entityUtils.moveAndCollide(entity, entities, x, y, delta, speed)
	local oldX, oldY = entity.x, entity.y
	entity.x = entity.x + x * delta * speed
	entity.y = entity.y + y * delta * speed
	
	if entity.shape then
		for _, e in ipairs(entities) do
			if entityUtils.areColliding(entity, entityUtils.entityTable(e)) then
				entity.x = oldX
				entity.y = oldY
				return true
			end
		end
	end
	return false
end

function entityUtils.testMove(entity, entities, x, y)
	local startX, startY = entity.x, entity.y
	local collision = entityUtils.moveAndCollide(entity, entities, x, y, 1, 1)
	entity.x, entity.y = startX, startY
	return collision
end

function entityUtils.findEntityWithComponent(entities, componentType)
	for _, entity in ipairs(entities) do
		for _, component in ipairs(entity.components) do
			if component.type == componentType then
				return entityUtils.entityTable(entity)
			end
		end
	end
end

return entityUtils