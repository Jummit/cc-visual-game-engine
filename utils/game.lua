local components = require "components"
local tableUtils = require "utils.table"
local entityUtils = require "utils.entity"
local game = {}

function game.render(entities, entityList, componentList, inEditor)
  term.setBackgroundColor(colors.white)
  term.clear()
  for n, entity in ipairs(entities) do
    local entityVars = entityUtils.getVars(entity)
    for i, component in ipairs(entity.components) do
      setmetatable(component.args, {__index = entityVars})
      components[component.type].render(component.args)
      if inEditor and n == entityList.selected and i == componentList.selected then
        components[component.type].editorRender(component.args)
      end
    end
  end
end

function game.update(entities)
  local event, var1, var2, var3 = os.pullEvent()
  for _, entity in ipairs(entities) do
    local entityVars = entityUtils.getVars(entity)
    for _, component in ipairs(entity.components) do
      components[component.type].update(setmetatable(component.args, {__index = entityVars}), event, var1, var2, var3)
    end
  end
end

function game.run(gameEntities)
  local e = tableUtils.copy(gameEntities)
  local gameTerm = window.create(term.current(), 1, 1, term.getSize())
  local oldTerm = term.redirect(gameTerm)
  entities = gameEntities
  while true do
    gameTerm.setVisible(false)
    game.render(e)
    gameTerm.setVisible(true)
    game.update(e)
  end
  term.redirect(oldTerm)
end

return game
