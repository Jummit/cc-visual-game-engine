local components = require "components"
local tableUtils = require "utils.table"
local entityUtils = require "utils.entity"
local keyboard = require "keyboard"
local log = require "utils.log"
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

function game.update(entities, lastUpdate)
  local event, var1, var2, var3 = os.pullEvent()
  
  keyboard.update(event, var1, var2, var3)

  if event == "key" and keys.getName(var1) == "q" then
    return true
  end

  if event == "timer" then
    os.startTimer(.1)
  end

  for _, entity in ipairs(entities) do
    local entityVars = entityUtils.getVars(entity)
    for _, component in ipairs(entity.components) do
      components[component.type].update(setmetatable(component.args, {__index = entityVars}), event, var1, var2, var3, entities, keyboard, os.clock() - lastUpdate)
    end
  end
end

function game.run(entities, runningGameWindow)
  log.clear()
  local oldTerm = term.redirect(runningGameWindow)
  os.startTimer(1)
  local lastUpdate = os.clock()
  while true do
    runningGameWindow.setVisible(false)
    game.render(entities)
    runningGameWindow.setVisible(true)

    if game.update(entities, lastUpdate) then
      runningGameWindow.setVisible(false)
      break
    end
    lastUpdate = os.clock()
  end
  term.redirect(oldTerm)
end

return game
