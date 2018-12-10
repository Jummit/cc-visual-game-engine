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

return entityUtils
