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
  if not (entity1.shape and entity2.shape) or (entity1.id == entity2.id) then
    return
  end
  for x, row in pairs(entity1.shape) do
    for y, on in pairs(row) do
      if on then
        local x = math.floor(x + entity1.x - entity2.x)
        local y = math.floor(y + entity1.y - entity2.y)
        if entity2.shape[x] and entity2.shape[x][y] then
          log(string.format("%s (id %s) collided with %s (id %s) at %s, %s", entity1.name, entity1.id, entity1.name, entity2.id, x, y))
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
  log("entity moved by "..x..", "..y.." with dt "..delta)
  return false
end

function entityUtils.testMove(entity, entities, x, y)
  return entityUtils.moveAndCollide({x = entity.x, y = entity.y, shape = entity.shape, id = entity.id}, entities, x, y, 1, 1)
end

return entityUtils