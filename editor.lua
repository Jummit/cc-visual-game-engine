local tableUtils = require "utils.table"
local gameSave = require "game.save"
local loadComponent = require "game.component"
local newEntity        = require "game.entity"
local ui = tableUtils.fromFiles("ui")
local w, h = term.getSize()
local sideBarWidth = math.min(math.floor(w / 4), 17)
local listHeight = math.floor(h / 2 - 2)

return function(save)
	return {
		runFullscreen = false,
		shouldQuit = false,
		lastDragClickX = nil,
		lastDragClickY = nil,
		saveFile = "saves/"..(save or "helloworld")..".game",
		window = nil,
		runtime = nil,
		keyboard = require("utils.keyboard")(),
		setInspectingComponent = function(self, component)
			self.inspectorPanel.visible = component ~= nil
			self.inspectorLabel.visible = component ~= nil
			self.inspectorSeparator.visible = component ~= nil
			self.inspector.visible = component ~= nil
			if component then
				self.inspector.properties = component.args
			end
		end,
		init = function(self)
			self.runtime = require("game.runtime")(gameSave.load(self.saveFile)
					or {},
			window.create(term.current(), sideBarWidth + 1, 1, w - sideBarWidth,
					h))
			self.inspectorLabel = ui.centerText{
				x = sideBarWidth + 2,
				y = h - 1,
				w = sideBarWidth,
				text = "Inspector",
				textColor = colors.white,
				backgroundColor = colors.lightGray,
			}
			self.inspectorPanel = ui.box{
				x = sideBarWidth + 2,
				w = sideBarWidth,
				h = h,
				color = colors.lightGray,
			}
			self.inspectorSeparator = ui.box{
				x = sideBarWidth + 1,
				h = h,
				color = colors.gray,
			}
			self.inspector = ui.inspector{
				x = sideBarWidth + 3,
				y = 2,
				w = sideBarWidth - 2,
				h = h,
			}
			self.componentList = ui.list{
				x = 2,
				y = listHeight + 4,
				w = sideBarWidth - 2,
				h = listHeight,
				items = {},
				onDoubleClick = function(_, item)
					if self.inspector.visible then
						self:setInspectingComponent()
					else
						self:setInspectingComponent(item)
					end
				end,
				onItemSelected = function(_, item)
					if self.inspector.visible then
						self:setInspectingComponent(item)
					end
				end,
				getLabel = function(item)
					return item.type
				end,
				shouldDelete = function(listSelf, item)
					for _, component in ipairs(listSelf.items) do
						for _, needed in ipairs(component.needs) do
							if item == needed then
								return false
							end
						end
					end
					return true
				end,
				addComponent = function(listSelf, componentType)
					local new = loadComponent.fromType(
							self.entityList:getSelected(), componentType)
					for _, needed in ipairs(new.needs) do
						local exists = false
						for _, existing in ipairs(listSelf.items) do
							if existing.type == needed then
								exists = true
							end
						end
						if not exists then
							listSelf:addComponent(needed)
						end
					end
					listSelf:add(new)
				end
			}
			self.entityList = ui.list{
				x = 2,
				y = 2,
				w = sideBarWidth - 2,
				h = listHeight,
				items = self.runtime.entities,
				getLabel = function(item)
					return item.name
				end,
				onItemSelected = function(_, item)
					self.componentList.items = item.components
					self.componentList:select(1)
				end,
				onDoubleClick = function(listSelf, item)
					term.setCursorPos(listSelf.x, listSelf.y +
							listSelf.selected - 1)
					term.setBackgroundColor(colors.gray)
					term.setTextColor(colors.white)
					local newName = io.read()
					if #newName > 0 then
						item.name = newName
					end
				end
			}
			self.uiElements = {
				ui.box{
					w = sideBarWidth,
					h = h,
					color = colors.lightGray
				},
				ui.box{
					y = h,
					w = w,
					color = colors.lightGray
				},
				self.entityList,
				self.componentList,
				self.inspectorPanel,
				self.inspectorLabel,
				self.inspectorSeparator,
				self.inspector,
				ui.centerText{
					x = 2,
					y = listHeight + 2,
					w = sideBarWidth - 2,
					text = "Entities",
					textColor = colors.white, backgroundColor = colors.lightGray
				},
				ui.centerText{
					x = 2,
					y = listHeight + listHeight + 4,
					w = sideBarWidth - 2,
					text = "Components",
					textColor = colors.white, backgroundColor = colors.lightGray
				},
				ui.buttons.addAndDelete{
					x = 2,
					y = listHeight + 1,
					del = function()
						self.componentList.items = {}
						self.entityList:removeSelected()
					end,
					add = function()
						self.entityList:add(newEntity{
							name = "new",
						})
					end
				},
				ui.buttons.addAndDelete{
					x = 2,
					y = listHeight * 2 + 3,
					del = function()
						self.componentList:removeSelected()
					end,
					add = function()
						self.window = ui.newComponentWindow(self.componentList)
					end
				},
				ui.buttons.move{
					x = 6,
					y = listHeight + 1,
					list = self.entityList,
				},
				ui.buttons.move{
					x = 6,
					y = listHeight * 2 + 3,
					list = self.componentList,
				},
				ui.button{
					x = w - 13,
					y = h,
					w = 4,
					label = "save",
					labelColor = colors.green,
					color = colors.lime,
					clickedColor = colors.yellow,
					onClick = function()
						gameSave.save(self.saveFile, self.runtime.entities)
					end
				},
				ui.button{
					x = w - 8,
					y = h,
					w = 3,
					label = "run",
					labelColor = colors.blue,
					color = colors.lightBlue,
					clickedColor = colors.white,
					onClick = function()
						require("utils.log").clear()
						self.runtime.window.reposition(
								self.runFullscreen and 1 or sideBarWidth + 1, 1,
								self.runFullscreen and w or w - sideBarWidth + 1,
								h)
						self.runtime:run()
					end
				},
				ui.button{
					x = w - 5,
					y = h,
					label = "-",
					labelColor = colors.white,
					color = colors.gray,
					clickedColor = colors.lightGray,
					onClick = function(buttonSelf)
						self.runFullscreen = not self.runFullscreen
						buttonSelf.label = self.runFullscreen and "+" or "-"
					end
				},
				ui.button{
					x = w - 3,
					y = h,
					w = 4,
					label = "exit",
					labelColor = colors.red,
					color = colors.orange,
					clickedColor = colors.yellow,
					onClick = function()
						self.shouldQuit = true
					end
				},
			}
			for _, element in ipairs(self.uiElements) do
				element:init()
			end
			self:setInspectingComponent()
		end,
		update = function(self, event, var1, var2, var3)
			self.keyboard:update(event, var1)

			if self.window then
				if self.window:update(event, var1, var2, var3) then
					self.window = nil
				end
			else
				for _, element in ipairs(self.uiElements) do
					if element.visible then
						element:update(event, var1, var2, var3)
					end
				end

				local visibleSideBar = sideBarWidth
				if self.inspector.visible then
					visibleSideBar = visibleSideBar + self.inspectorPanel.w + 1
				end
				if event == "mouse_click" and var1 == 3 then
					self.lastDragClickX = var2
					self.lastDragClickY = var3
				elseif event == "mouse_drag" and var1 == 3 then
					self.runtime.cameraX = self.runtime.cameraX -
							(self.lastDragClickX - var2)
					self.runtime.cameraY = self.runtime.cameraY -
							(self.lastDragClickY - var3)
					self.lastDragClickX = var2
					self.lastDragClickY = var3
				elseif not event:find("mouse") or (var2 > visibleSideBar and
						var3 < h) then
					local selected = self.componentList:getSelected()
					if selected then
						if event:sub(1, #"mouse") == "mouse" then
							var2 = var2 - sideBarWidth
						end
						selected.updateEditor(selected.parent, self,
								self.runtime, event, var1, var2, var3)
					end
				end
			end
		end,
		draw = function(self)
			if self.window then
				self.window:draw()
			else
				self.runtime:draw()
				local oldTerm = term.redirect(self.runtime.window)
				local selected = self.componentList:getSelected()
				if selected then
					selected.drawEditor(selected.parent, self, self.runtime)
				end
				term.redirect(oldTerm)
				for _, element in ipairs(self.uiElements) do
					if element.visible then
						element:draw()
					end
				end
			end
		end
	}
end