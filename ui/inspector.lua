local checkbox = require "ui.checkbox"
local lineEdit = require "ui.lineEdit"

local function getEditorForProperty(self, propertyValue,
			propertyNum)
	local element
	if type(propertyValue) == "boolean" then
		element = checkbox{
			ticked = propertyValue
		}
	elseif type(propertyValue) == "string" or
			type(propertyValue) == "number" then
		element = lineEdit{
			text = tostring(propertyValue)
		}
	elseif type(propertyValue) == "table" then
		return
	end
	element.x = self.x + 7
	element.y = self.y + propertyNum * 2
	element.propertyType = type(propertyValue)
	return element
end

local function getPropertFromElement(element)
	if element.propertyType == "boolean" then
		return element.ticked
	elseif element.propertyType == "string" then
		return element.text
	elseif element.propertyType == "number" then
		local number = tonumber(element.text)
		if not number then
			return 0
		else
			return number
		end
	end
end

return function(t)
	return setmetatable(t, {__index = {
		draw = function(self)
			local propertyNum = 0
			for propertyName, propertyValue in pairs(self.properties) do
				local element = getEditorForProperty(self, propertyValue,
						propertyNum)
				if element then
					term.setBackgroundColor(colors.lightGray)
					term.setTextColor(colors.gray)
					term.setCursorPos(self.position.x,
							self.position.y + propertyNum * 2)
					term.write(string.sub(propertyName:sub(1, 1):upper()
							.. propertyName:sub(2, -1), 1, 6))
					element:draw()
					propertyNum = propertyNum + 1
				end
			end
		end,
		update = function(self, event, var1, var2, var3)
			local propertyNum = 0
			for propertyName, propertyValue in pairs(self.properties) do
				local element = getEditorForProperty(self, propertyValue,
						propertyNum)
				if element then
					element:update(event, var1, var2, var3)
					self.properties[propertyName] = getPropertFromElement(element)
					propertyNum = propertyNum + 1
				end
			end
		end,
		properties = {},
	}})
end
