local utils = require "utils"
local newButton = require "button"

local function moveListItems(t, f)
  local items = utils.copyTable(t.list.items)
  local selected = t.list.selected
  local selectedItem = items[selected]
  if selectedItem then
    table.remove(items, selected)
    utils.clearTable(t.list.items)

    for n, item in ipairs(items) do
      f(n, item, selected, selectedItem)
    end
  end
end

return function(t)
  local up = newButton{
    x = t.x, y = t.y,
    w = 3, h = 1,
    label = "^",
    color = colors.gray, clickedColor = colors.cyan,
    labelColor = colors.white,
    onClick = function()
      if t.list.selected > 1 then
        moveListItems(t, function(n, item, selected, selectedItem)
              if n == selected - 1 then
                table.insert(t.list.items, selectedItem)
              end
              table.insert(t.list.items, item)
            end)
        t.list:select(t.list.selected - 1)
      end
    end
  }
  local down = newButton{
    x = t.x + 4, y = t.y,
    w = 3, h = 1,
    label = "v",
    color = colors.gray, clickedColor = colors.cyan,
    labelColor = colors.white,
    onClick = function()
      if t.list.selected < #t.list.items then
        moveListItems(t, function(n, item, selected, selectedItem)
              table.insert(t.list.items, item)
              if n == selected then
                table.insert(t.list.items, selectedItem)
              end
            end)
        t.list:select(t.list.selected + 1)
      end
    end
  }

  return {
    render = function(self)
      up:render()
      down:render()
    end,
    update = function(self, event, var1, var2, var3)
      up:update(event, var1, var2, var3)
      down:update(event, var1, var2, var3)
    end
  }
end
