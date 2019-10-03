local entityUtils = {}

function entityUtils.getVars(entity)
  local entityVars = {}
  for _, component in ipairs(entity.components) do
    for k, v in pairs(component.args) do
      entityVars[k] = v
    end
  end
  return entityVars
end

function entityUtils.areColliding(entity1, entity2)
  if not (entity1.shape and entity2.shape) or (entity1.id == entity2.id) then
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
      if entityUtils.areColliding(entity, entityUtils.getVars(e)) then
        entity.x = oldX
        entity.y = oldY
        return false
      end
    end
  end
  return true
end

return entityUtils