local components = require "components.components"
local tableUtils = require "utils.table"
local entityUtils = require "game.entityUtils"
local gameSave = require "game.save"
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
			self.inspectorPanel.hidden = component == nil
			self.inspectorLabel.hidden = component == nil
			self.inspectorSeparator.hidden = component == nil
			self.inspector.hidden = component == nil
			if component then
				self.inspector.properties = component.args
			end
		end,
		init = function(self)
			self.runtime = require("game.runtime")(gameSave.load(self.saveFile) or {},
			window.create(term.current(), sideBarWidth + 1, 1, w - sideBarWidth, h))
			self.inspectorLabel = ui.centerText{
				x = sideBarWidth + 2,
				y = h - 1,
				w = sideBarWidth,
				h = 1,
				text = "Inspector",
				textColor = colors.white,
				backgroundColor = colors.lightGray,
			}
			self.inspectorPanel = ui.box{
				x = sideBarWidth + 2,
				y = 1,
				w = sideBarWidth,
				h = h,
				color = colors.lightGray,
			}
			self.inspectorSeparator = ui.box{
				x = sideBarWidth + 1,
				y = 1,
				w = 1,
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
					if self.inspector.hidden then
						self:setInspectingComponent(item)
					else
						self:setInspectingComponent()
					end
				end,
				onItemSelected = function(_, item)
					if not self.inspector.hidden then
						self:setInspectingComponent(item)
					end
				end,
				getLabel = function(item)
					return item.type
				end,
				shouldDelete = function(listSelf, toDelete)
					for _, component in ipairs(listSelf.items) do
						for _, neededComponent in ipairs(components[component].needs) do
							if toDelete == neededComponent then
								return false
							end
						end
					end
					return true
				end,
				addComponent = function(listSelf, componentType)
					local newComponent = components[componentType]

					for _, neededComponent in ipairs(newComponent.needs) do
						local neededExists = false
						for _, existingComponent in ipairs(listSelf.items) do
							if existingComponent.type == neededComponent then
								neededExists = true
							end
						end
						if not neededExists then
							listSelf:addComponent(neededComponent)
						end
					end

					listSelf:add{
						type = componentType,
						args = tableUtils.copy(components[componentType].args),
					}
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
				onDoubleClick = function(_, item)
					term.setCursorPos(self.entityList.x, self.entityList.y + self.entityList.selected - 1)
					term.setBackgroundColor(colors.gray)
					term.setTextColor(colors.white)
					local newName = io.read()
					if #newName > 0 then
						self.entityList:getSelected().name = newName
					end
				end
			}
			self.uiElements = {
				ui.box{
					x = 1,
					y = 1,
					w = sideBarWidth,
					h = h,
					color = colors.lightGray
				},
				ui.box{
					x = 1,
					y = h,
					w = w,
					h = 1,
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
					h = 1,
					text = "Entities",
					textColor = colors.white, backgroundColor = colors.lightGray
				},
				ui.centerText{
					x = 2,
					y = listHeight + listHeight + 4,
					w = sideBarWidth - 2,
					h = 1,
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
						self.entityList:add({
							name = "new",
							components = {}
						})
					end
				},
				ui.buttons.addAndDelete{
					x = 2,
					y = listHeight + listHeight + 3,
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
					list = self.entityList
				},
				ui.buttons.move{
					x = 6, y = listHeight + listHeight + 3,
					list = self.componentList
				},
				ui.button{
					x = w - 13,
					y = h,
					w = 4,
					h = 1,
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
					h = 1,
					label = "run",
					labelColor = colors.blue,
					color = colors.lightBlue,
					clickedColor = colors.white,
					onClick = function()
						require("utils.log").clear()
						self.runtime.window.reposition(self.runFullscreen and 1 or sideBarWidth + 1, 1,
						self.runFullscreen and w or w - sideBarWidth + 1, h)
						self.runtime:run()
					end
				},
				ui.button{
					x = w - 5,
					y = h,
					w = 1,
					h = 1,
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
					h = 1,
					label = "exit",
					labelColor = colors.red,
					color = colors.orange,
					clickedColor = colors.yellow,
					onClick = function()
						self.shouldQuit = true
					end
				},
			}
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
					if not element.hidden then
						element:update(event, var1, var2, var3)
					end
				end

				local visibleSideBar = sideBarWidth
				if not self.inspector.hidden then
					visibleSideBar = visibleSideBar + self.inspectorPanel.w + 1
				end
				if event == "mouse_click" and var1 == 3 then
					self.lastDragClickX = var2
					self.lastDragClickY = var3
				elseif event == "mouse_drag" and var1 == 3 then
					self.runtime.cameraX = self.runtime.cameraX - (self.lastDragClickX - var2)
					self.runtime.cameraY = self.runtime.cameraY - (self.lastDragClickY - var3)
					self.lastDragClickX = var2
					self.lastDragClickY = var3
				elseif not event:find("mouse") or (var2 > visibleSideBar and var3 < h) then
					local selected = self.componentList:getSelected()
					if selected then
						if event:sub(1, #"mouse") == "mouse" then
							var2 = var2 - sideBarWidth
						end
						components[selected.type].updateEditor(
						entityUtils.entityTable(self.entityList:getSelected()), self,
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
					components[selected.type].drawEditor(
					entityUtils.entityTable(self.entityList:getSelected()), self, self.runtime)
				end
				term.redirect(oldTerm)
				for _, element in ipairs(self.uiElements) do
					if not element.hidden then
						element:draw()
					end
				end
			end
		end
	}
end