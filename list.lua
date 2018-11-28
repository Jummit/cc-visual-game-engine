local utils = require "utils"

return function(x, y, w, h, items, getLabel, onItemSelected, shouldDelete)
  local this = {
    render = function(self)
      local x, y, w, h = self.x, self.y, self.w, self.h
      utils.renderBox(x, y, w, h, colors.gray)
      local next_y = y
      for i, item in ipairs(self.items) do
        if i == self.selected then
          term.setTextColor(colors.lightGray)
        end

        term.setCursorPos(x, next_y)
        term.write(self.getLabel(item))

        if i == self.selected then
          term.setTextColor(colors.white)
        end

        next_y = next_y + 1
      end
    end,
    update = function(self, event, var1, var2, var3)
      if event == "mouse_click" then
        if utils.pointInBox(
              self.x, self.y, self.w, self.h,
              var2, var3) and #self.items > var3 - self.y then
          self:select(var3 - self.y + 1)
        end
      end
    end,
    select = function(self, i)
      if #self.items == 0 then
        self.selected = nil
      else
        if i > 0 and i <= #self.items then
          self.selected = i
        else
          self.selected = 1
        end
        self.onItemSelected(self.items[self.selected])
      end
    end,
    removeSelected = function(self)
      if self.selected and ((not self.shouldDelete) or self:shouldDelete(self.items[self.selected])) then
        table.remove(self.items, self.selected)
        self:select(self.selected)
      end
    end,
    clear = function(self)
      utils.clearTable(self.items)
      self.selected = nil
    end,
    add = function(self, item)
      table.insert(self.items, item)
      self:select(#self.items)
    end
  }

  this.selected = false
  this.x = x
  this.y = y
  this.w = w
  this.h = h
  this.items = items
  this.getLabel = getLabel
  this.onItemSelected = onItemSelected
  this.shouldDelete = shouldDelete

  return this
end
