local physics = {}

function physics.areColliding(entity1, entity2)
	if not (entity1.shape and entity2.shape) or (entity1 == entity2) then
		return
	end
	for x, row in pairs(entity1.shape) do
		for y, on in pairs(row) do
			if on then
				local shapeX = math.floor(x + entity1.x - entity2.x)
				local shapeY = math.floor(y + entity1.y - entity2.y)
				if entity2.shape[shapeX] and entity2.shape[shapeX][shapeY] then
					return true
				end
			end
		end
	end
end

function physics.moveAndCollide(entity, entities, x, y, delta, speed)
	local oldX, oldY = entity.x, entity.y
	entity.x = entity.x + x * delta * speed
	entity.y = entity.y + y * delta * speed
	
	if entity.shape then
		for _, e in ipairs(entities) do
			if physics.areColliding(entity, physics.entityTable(e)) then
				entity.x = oldX
				entity.y = oldY
				return true
			end
		end
	end
	return false
end

function physics.testMove(entity, entities, x, y)
	local startX, startY = entity.x, entity.y
	local collision = physics.moveAndCollide(entity, entities, x, y, 1, 1)
	entity.x, entity.y = startX, startY
	return collision
end

return physics