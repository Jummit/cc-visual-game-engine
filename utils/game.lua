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
  Keyboard:update(event, var1, var2, var3)
  if event == "timer" then
    os.startTimer(0)
  end
  for _, entity in ipairs(entities) do
    local entityVars = entityUtils.getVars(entity)
    for _, component in ipairs(entity.components) do
      components[component.type].update(setmetatable(component.args, {__index = entityVars}), event, var1, var2, var3)
    end
  end
end

function game.run(gameEntities)
  Entities = tableUtils.copy(gameEntities)
  local gameTerm = window.create(term.current(), 1, 1, term.getSize())
  local oldTerm = term.redirect(gameTerm)

  os.startTimer(0)
  while true do
    gameTerm.setVisible(false)
    game.render(Entities)
    gameTerm.setVisible(true)
    game.update(Entities)
  end

  Entities = nil
  term.redirect(oldTerm)
end

return game
