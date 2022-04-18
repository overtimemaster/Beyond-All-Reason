--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    selector.lua
--  brief:   the widget selector, loads and unloads widgets
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- changes:
--   jK (April@2009) - updated to new font system
--   Bluestone (Jan 2015) - added to BA as a widget, added various stuff
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name = "Widget Selector",
		desc = "Widget selection widget",
		author = "trepan, jK, Bluestone",
		date = "Jan 8, 2007",
		license = "GNU GPL, v2 or later",
		layer = (-math.huge) + 1,
		handler = true,
		enabled = true
	}
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local showButtons = false

-- relies on a gadget to implement "luarules reloadluaui"
-- relies on custom stuff in widgetHandler to implement blankOutConfig and allowUserWidgets

include("keysym.h.lua")
include("fonts.lua")

local WhiteStr = "\255\255\255\255"
local RedStr = "\255\255\001\001"
local GreenStr = "\255\001\255\001"
local BlueStr = "\255\001\001\255"
local CyanStr = "\255\001\255\255"
local YellowStr = "\255\255\255\001"
local MagentaStr = "\255\255\001\255"

local customScale = 1
local sizeMultiplier = 1

local floor = math.floor

local widgetsList = {}
local fullWidgetsList = {}

local vsx, vsy = widgetHandler:GetViewSizes()

local minMaxEntries = 15
local curMaxEntries = 25

local startEntry = 1
local pageStep = floor(curMaxEntries / 2) - 1

local fontSize = 14.25
local fontSpace = 8.5
local yStep = fontSize + fontSpace

local fontfile = "fonts/" .. Spring.GetConfigString("bar_font", "Poppins-Regular.otf")
local vsx, vsy = Spring.GetViewGeometry()
local fontfileScale = (0.5 + (vsx * vsy / 5700000))
local fontfileSize = 36
local fontfileOutlineSize = 6
local fontfileOutlineStrength = 1.3
local font = gl.LoadFont(fontfile, fontfileSize * fontfileScale, fontfileOutlineSize * fontfileScale, fontfileOutlineStrength)
local fontfile2 = "fonts/" .. Spring.GetConfigString("bar_font2", "Exo2-SemiBold.otf")
local font2 = gl.LoadFont(fontfile2, fontfileSize * fontfileScale, fontfileOutlineSize * fontfileScale, fontfileOutlineStrength)

local bgPadding = 4.5

local maxWidth = 0.01
local borderx = yStep * 0.75
local bordery = yStep * 0.75

local activeGuishader = false
local scrollbarOffset = -15

local midx = vsx * 0.5
local minx = vsx * 0.4
local maxx = vsx * 0.6
local midy = vsy * 0.5
local miny = vsy * 0.4
local maxy = vsy * 0.6

local sbposx = 0.0
local sbposy = 0.0
local sbsizex = 0.0
local sbsizey = 0.0
local sby1 = 0.0
local sby2 = 0.0
local sbsize = 0.0
local sbheight = 0.0
local activescrollbar = false
local scrollbargrabpos = 0.0

local show = false
local pagestepped = false

local RectRound, UiElement, UiSelectHighlight

local dlistGuishader, lastStart

local widgetScale = (vsy / 1080)

local texts = {
	title = 'Widget Selector',
	button_reloadluaui = 'Reload LuaUI',
	button_unloadallwidgets = 'Unload All Widgets',
	button_disallowuserwidgets = 'Disallow User Widgets',
	button_allowuserwidgets = 'Allow User Widgets',
	button_resetluaui = 'Reset LuaUI',
	button_factoryresetluaui = 'Factory Reset LuaUI',
}

local buttons = { --see MouseRelease for which functions are called by which buttons
	[1] = texts.button_reloadluaui,
	[2] = texts.button_unloadallwidgets,
	[3] = texts.button_disallowuserwidgets,
	[4] = texts.button_resetluaui,
	[5] = texts.button_factoryresetluaui,
}

local allowuserwidgets = true
if not Spring.GetModOptions().allowuserwidgets then
	allowuserwidgets = false
	buttons[3] = ''
end

local titleFontSize = 20
local buttonFontSize = 15
local buttonHeight = 24
local buttonTop = 28 -- offset between top of buttons and bottom of widget

-------------------------------------------------------------------------------

function widget:Initialize()

	if not allowuserwidgets then
		buttons[3] = ''
	else
		if widgetHandler.allowUserWidgets then
			buttons[3] = texts.button_disallowuserwidgets
		else
			buttons[3] = texts.button_allowuserwidgets
		end
	end

	widgetHandler.knownChanged = true
	Spring.SendCommands('unbindkeyset f11')

	if Spring.GetGameFrame() <= 0 then
		Spring.SendLuaRulesMsg('xmas' .. ((os.date("%m") == "12" and os.date("%d") >= "12") and '1' or '0'))
	end
	WG['widgetselector'] = {}
	WG['widgetselector'].toggle = function(state)
		local newShow = state
		if newShow == nil then
			newShow = not show
		end
		if newShow and WG['topbar'] then
			WG['topbar'].hideWindows()
		end
		show = newShow
	end
	WG['widgetselector'].isvisible = function()
		return show
	end

	widget:ViewResize(Spring.GetViewGeometry())
end


-------------------------------------------------------------------------------


local function UpdateGeometry()
	midx = vsx * 0.5
	midy = vsy * 0.5

	local halfWidth = ((maxWidth + 2) * fontSize) * sizeMultiplier * 0.5
	minx = floor(midx - halfWidth - (borderx * sizeMultiplier))
	maxx = floor(midx + halfWidth + (borderx * sizeMultiplier))

	local ySize = (yStep * sizeMultiplier) * (#widgetsList)
	miny = floor(midy - (0.5 * ySize)) - ((fontSize + bgPadding + bgPadding) * sizeMultiplier)
	maxy = floor(midy + (0.5 * ySize))
end

local function UpdateListScroll()
	local wCount = #fullWidgetsList
	local lastStart = lastStart or wCount - curMaxEntries + 1
	if lastStart < 1 then
		lastStart = 1
	end
	if lastStart > wCount - curMaxEntries + 1 then
		lastStart = 1
	end
	if startEntry > lastStart then
		startEntry = lastStart
	end
	if startEntry < 1 then
		startEntry = 1
	end

	widgetsList = {}
	local se = startEntry
	local ee = se + curMaxEntries - 1
	local n = 1
	for i = se, ee do
		widgetsList[n], n = fullWidgetsList[i], n + 1
	end
end

local function ScrollUp(step)
	startEntry = startEntry - step
	UpdateListScroll()
end

local function ScrollDown(step)
	startEntry = startEntry + step
	UpdateListScroll()
end

function widget:MouseWheel(up, value)
	if not show then
		return false
	end

	local a, c, m, s = Spring.GetModKeyState()
	if a or m then
		return false  -- alt and meta allow normal control
	end
	local step = (s and 4) or (c and 1) or 2
	if up then
		ScrollUp(step)
	else
		ScrollDown(step)
	end
	return true
end

local function SortWidgetListFunc(nd1, nd2)
	--does nd1 come before nd2?
	-- widget profiler on top
	if nd1[1] == "Widget Profiler" then
		return true
	elseif nd2[1] == "Widget Profiler" then
		return false
	end

	-- mod widgets first, then user widgets
	if (nd1[2].fromZip ~= nd2[2].fromZip) then
		return nd1[2].fromZip
	end

	-- sort by name
	return (nd1[1] < nd2[1])
end

local function UpdateList()
	if not widgetHandler.knownChanged then
		return
	end
	widgetHandler.knownChanged = false

	local myName = widget:GetInfo().name
	maxWidth = 0
	widgetsList = {}
	local fullWidgetsListCount = #fullWidgetsList
	for name, data in pairs(widgetHandler.knownWidgets) do
		if name ~= myName and name ~= 'Write customparam.__def to files' then
			fullWidgetsListCount = fullWidgetsListCount + 1
			fullWidgetsList[fullWidgetsListCount] = { name, data }
			-- look for the maxWidth
			local width = fontSize * font:GetTextWidth(name)
			if width > maxWidth then
				maxWidth = width
			end
		end
	end

	maxWidth = (maxWidth / fontSize)

	--if widgetHandler.knownCount ~= (fullWidgetsListCount + 1) then
	--  error('knownCount mismatch')
	--end

	table.sort(fullWidgetsList, SortWidgetListFunc)	-- occurred: Error in IsAbove(): [string "LuaUI/Widgets/widget_selector.lua"]:300: invalid order function for sorting (migh have happened cause i renamed/added a custom widget after launch)

	UpdateListScroll()
	UpdateGeometry()
end

function widget:ViewResize(n_vsx, n_vsy)
	vsx, vsy = Spring.GetViewGeometry()
	widgetScale = (vsy / 1080)
	local fontfileScale = widgetScale
	font = gl.LoadFont(fontfile, fontfileSize * fontfileScale, fontfileOutlineSize * fontfileScale, fontfileOutlineStrength)
	font2 = gl.LoadFont(fontfile2, fontfileSize * fontfileScale, fontfileOutlineSize * fontfileScale, fontfileOutlineStrength)

	sizeMultiplier = widgetScale * 0.95

	RectRound = WG.FlowUI.Draw.RectRound
	UiElement = WG.FlowUI.Draw.Element
	UiSelectHighlight = WG.FlowUI.Draw.SelectHighlight

	UpdateGeometry()
end


-------------------------------------------------------------------------------

function widget:KeyPress(key, mods, isRepeat)
	if show and key == KEYSYMS.ESCAPE or
		(key == KEYSYMS.F11 and not isRepeat and
			not (mods.alt or mods.ctrl or mods.meta or mods.shift)) then

		local newShow = not show
		if newShow and WG['topbar'] then
			WG['topbar'].hideWindows()
		end
		show = newShow
		return true
	end
	if show and key == KEYSYMS.PAGEUP then
		ScrollUp(pageStep)
		return true
	end
	if show and key == KEYSYMS.PAGEDOWN then
		ScrollDown(pageStep)
		return true
	end
	return false
end

function widget:DrawScreen()
	if not show then
		if WG['guishader'] and activeGuishader then
			activeGuishader = false
			WG['guishader'].DeleteDlist('widgetselector')
		end
		return
	end

	UpdateList()
	if WG['guishader'] == nil then
		activeGuishader = false
	end
	if WG['guishader'] and not activeGuishader then
		activeGuishader = true
		dlistGuishader = gl.CreateList(function()
			RectRound(floor(minx - (bgPadding * sizeMultiplier)), floor(miny - (bgPadding * sizeMultiplier)), floor(maxx + (bgPadding * sizeMultiplier)), floor(maxy + (bgPadding * sizeMultiplier)), 6 * sizeMultiplier)
		end)
		WG['guishader'].InsertDlist(dlistGuishader, 'widgetselector')
	end
	borderx = (yStep * sizeMultiplier) * 0.75
	bordery = (yStep * sizeMultiplier) * 0.75

	-- draw the header
	font2:Begin()
	font2:Print(texts.title, midx, maxy + ((11 + bgPadding) * sizeMultiplier), titleFontSize * sizeMultiplier, "oc")
	font2:End()

	font:Begin()
	local mx, my, lmb, mmb, rmb = Spring.GetMouseState()
	local tcol = WhiteStr

	-- draw the -/+ buttons
	if maxx - 10 < mx and mx < maxx and maxy < my and my < maxy + ((buttonFontSize + 7) * sizeMultiplier) then
		tcol = '\255\031\031\031'
	end
	font:Print(tcol .. "+", maxx, maxy + ((7 + bgPadding) * sizeMultiplier), buttonFontSize * sizeMultiplier, "or")
	tcol = WhiteStr
	if minx < mx and mx < minx + 10 and maxy < my and my < maxy + ((buttonFontSize + 7) * sizeMultiplier) then
		tcol = '\255\031\031\031'
	end
	font:Print(tcol .. "-", minx, maxy + ((7 + bgPadding) * sizeMultiplier), buttonFontSize * sizeMultiplier, "ol")
	tcol = WhiteStr

	UiElement(floor(minx - (bgPadding * sizeMultiplier)), floor(miny - (bgPadding * sizeMultiplier)), floor(maxx + (bgPadding * sizeMultiplier)), floor(maxy + (bgPadding * sizeMultiplier)), 1, 1, 1, 1, 1,1,1,1, Spring.GetConfigFloat("ui_opacity", 0.6) + 0.2)

	-- draw the text buttons (at the bottom) & their outlines
	if showButtons then
		for i, name in ipairs(buttons) do
			tcol = WhiteStr
			if minx < mx and mx < maxx and miny - (buttonTop * sizeMultiplier) - i * (buttonHeight * sizeMultiplier) < my and my < miny - (buttonTop * sizeMultiplier) - (i - 1) * (buttonHeight * sizeMultiplier) then
				tcol = '\255\031\031\031'
			end
			font:Print(tcol .. buttons[i], (minx + maxx) / 2, miny - (buttonTop * sizeMultiplier) - (i * (buttonHeight * sizeMultiplier)), buttonFontSize * sizeMultiplier, "oc")
		end
	end


	-- draw the widgets
	local nd = self:AboveLabel(mx, my)
	local pointedY = nil
	local pointedEnabled = false
	local pointedName = (nd and nd[1]) or nil
	local posy = maxy - ((yStep + bgPadding) * sizeMultiplier)
	sby1 = posy + ((fontSize + fontSpace) * sizeMultiplier) * 0.5
	for _, namedata in ipairs(widgetsList) do
		local name = namedata[1]
		local data = namedata[2]
		local color = ''
		local pointed = (pointedName == name)
		local order = widgetHandler.orderList[name]
		local enabled = order and (order > 0)
		local active = data.active
		if pointed and not activescrollbar then
			pointedY = posy
			pointedEnabled = data.active
			if not pagestepped and (lmb or mmb or rmb) then
				color = WhiteStr
			else
				color = (active and '\255\128\255\128') or
					(enabled and '\255\255\255\128') or '\255\255\128\128'
			end
		else
			color = (active and '\255\064\224\064') or
				(enabled and '\255\200\200\064') or '\255\224\064\064'
		end

		local tmpName
		if data.fromZip then
			-- FIXME: extra chars not counted in text length
			tmpName = WhiteStr .. '*' .. color .. name .. WhiteStr .. '*'
		else
			tmpName = color .. name
		end

		font:Print(color .. tmpName, midx, posy + (fontSize * sizeMultiplier) * 0.5, fontSize * sizeMultiplier, "vc")
		posy = posy - (yStep * sizeMultiplier)
	end


	-- scrollbar
	if #widgetsList < #fullWidgetsList then
		sby2 = posy + (yStep * sizeMultiplier) - (fontSpace * sizeMultiplier) * 0.5
		sbheight = sby1 - sby2
		sbsize = sbheight * #widgetsList / #fullWidgetsList
		if activescrollbar then
			startEntry = math.max(0, math.min(
				floor(#fullWidgetsList *
					((sby1 - sbsize) -
						(my - math.min(scrollbargrabpos, sbsize)))
					/ sbheight + 0.5),
				#fullWidgetsList - curMaxEntries)) + 1
		end
		local sizex = maxx - minx
		sbposx = minx + sizex + 1.0 + (scrollbarOffset * widgetScale)
		sbposy = sby1 - sbsize - sbheight * (startEntry - 1) / #fullWidgetsList
		sbsizex = (yStep * sizeMultiplier)
		sbsizey = sbsize

		local trianglePadding = 4 * sizeMultiplier
		local scrollerPadding = 8 * sizeMultiplier

		-- background
		if (sbposx < mx and mx < sbposx + sbsizex and miny < my and my < maxy) or activescrollbar then
			RectRound(sbposx, miny, sbposx + (sbsizex * 0.61), maxy, 4.5 * sizeMultiplier, 1, 1, 1, 1, { 0.2, 0.2, 0.2, 0.2 }, { 0.5, 0.5, 0.5, 0.2 })
		end

		--[[gl.Color(1.0, 1.0, 1.0, 0.15)
		gl.Shape(GL.TRIANGLES, {
		  { v = { sbposx + sbsizex / 2, miny + trianglePadding } },
		  { v = { sbposx + trianglePadding, sby2 - 1 - trianglePadding} },
		  { v = { sbposx + sbsizex - trianglePadding, sby2 - 1 - trianglePadding} }
		})
		gl.Shape(GL.TRIANGLES, {
		  { v = { sbposx + sbsizex / 2, maxy - trianglePadding } },
		  { v = { sbposx - trianglePadding + sbsizex, sby2 + sbheight + 1 + trianglePadding} },
		  { v = { sbposx + trianglePadding, sby2 + sbheight + 1 + trianglePadding} }
		})]]--

		-- scroller
		if (sbposx < mx and mx < sbposx + sbsizex and sby2 < my and my < sby2 + sbheight) then
			gl.Color(1, 1, 1, 0.1)
			gl.Blending(GL.SRC_ALPHA, GL.ONE)
			RectRound(sbposx + scrollerPadding, sbposy, sbposx + sbsizex - scrollerPadding, sbposy + sbsizey, 1.75 * sizeMultiplier)
			gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
		end
		gl.Color(0.33, 0.33, 0.33, 0.8)
		RectRound(sbposx + scrollerPadding, sbposy, sbposx + sbsizex - scrollerPadding, sbposy + sbsizey, 1.75 * sizeMultiplier)
	else
		sbposx = 0.0
		sbposy = 0.0
		sbsizex = 0.0
		sbsizey = 0.0
	end


	-- highlight label
	if (sbposx < mx and mx < sbposx + sbsizex and miny < my and my < maxy) or activescrollbar then

	else
		if pointedY then
			local xn = minx + 0.5
			local xp = maxx - 0.5
			local yn = pointedY - ((fontSpace * 0.5 + 1) * sizeMultiplier)
			local yp = pointedY + ((fontSize + fontSpace * 0.5 + 1) * sizeMultiplier)
			if scrollbarOffset < 0 then
				xp = xp + scrollbarOffset
				--xn = xn - scrollbarOffset
			end
			yn = yn + 0.5
			yp = yp - 0.5
			gl.Blending(GL.SRC_ALPHA, GL.ONE)
			UiSelectHighlight(math.floor(xn), math.floor(yn), math.floor(xp), math.floor(yp), nil, lmb and 0.18 or 0.11)
			gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
		end
	end

	font:End()
end

function widget:MousePress(x, y, button)
	if Spring.IsGUIHidden() or not show then
		return false
	end

	UpdateList()

	if button == 1 then
		-- above a button
		if showButtons then
			if minx < x and x < maxx and miny - (buttonTop * sizeMultiplier) - #buttons * (buttonHeight * sizeMultiplier) < y and y < miny - (buttonTop * sizeMultiplier) then
				return true
			end
		end

		-- above the -/+
		if maxx - 10 < x and x < maxx and maxy + bgPadding < y and y < maxy + ((buttonFontSize + 7 + bgPadding) * sizeMultiplier) then
			return true
		end
		if minx < x and x < minx + 10 and maxy + bgPadding < y and y < maxy + ((buttonFontSize + 7 + bgPadding) * sizeMultiplier) then
			return true
		end

		-- above the scrollbar
		if x >= minx + scrollbarOffset and x <= maxx + scrollbarOffset + (yStep * sizeMultiplier) then
			if y >= (maxy - bordery) and y <= maxy then
				if x > maxx + scrollbarOffset then
					ScrollUp(1)
				else
					ScrollUp(pageStep)
				end
				return true
			elseif y >= miny and y <= miny + bordery then
				if x > maxx + scrollbarOffset then
					ScrollDown(1)
				else
					ScrollDown(pageStep)
				end
				return true
			end
		end

		-- above the list
		if sbposx < x and x < sbposx + sbsizex and sbposy < y and y < sbposy + sbsizey then
			activescrollbar = true
			scrollbargrabpos = y - sbposy
			return true
		elseif sbposx < x and x < sbposx + sbsizex and sby2 < y and y < sby2 + sbheight then
			if y > sbposy + sbsizey then
				startEntry = math.max(1, math.min(startEntry - curMaxEntries, #fullWidgetsList - curMaxEntries + 1))
			elseif y < sbposy then
				startEntry = math.max(1, math.min(startEntry + curMaxEntries, #fullWidgetsList - curMaxEntries + 1))
			end
			UpdateListScroll()
			pagestepped = true
			return true
		end
	end

	local namedata = self:AboveLabel(x, y)
	if not namedata then
		show = false
		return false
	end

	return true

end

function widget:MouseMove(x, y, dx, dy, button)
	if show and activescrollbar then
		startEntry = math.max(0, math.min(floor((#fullWidgetsList * ((sby1 - sbsize) - (y - math.min(scrollbargrabpos, sbsize))) / sbheight) + 0.5),
			#fullWidgetsList - curMaxEntries)) + 1
		UpdateListScroll()
		return true
	end
	return false
end

function widget:MouseRelease(x, y, mb)
	if Spring.IsGUIHidden() or not show then
		return -1
	end

	UpdateList()
	if pagestepped then
		pagestepped = false
		return true
	end

	if mb == 1 and activescrollbar then
		activescrollbar = false
		scrollbargrabpos = 0.0
		return -1
	end

	if mb == 1 then
		if maxx - 10 < x and x < maxx and maxy + bgPadding < y and y < maxy + buttonFontSize + 7 + bgPadding then
			-- + button
			curMaxEntries = curMaxEntries + 1
			UpdateListScroll()
			UpdateGeometry()
			Spring.WarpMouse(x, y + 0.5 * (fontSize + fontSpace))
			return -1
		end
		if minx < x and x < minx + 10 and maxy + bgPadding < y and y < maxy + buttonFontSize + 7 + bgPadding then
			-- - button
			if curMaxEntries > minMaxEntries then
				curMaxEntries = curMaxEntries - 1
				UpdateListScroll()
				UpdateGeometry()
				Spring.WarpMouse(x, y - 0.5 * (fontSize + fontSpace))
			end
			return -1
		end
	end

	if showButtons and mb == 1 then
		local buttonID = nil
		for i, _ in ipairs(buttons) do
			if minx < x and x < maxx and miny - (buttonTop * sizeMultiplier) - i * (buttonHeight * sizeMultiplier) < y and y < miny - (buttonTop * sizeMultiplier) - (i - 1) * (buttonHeight * sizeMultiplier) then
				buttonID = i
				break
			end
		end
		if buttonID == 1 then
			Spring.SendCommands("luarules reloadluaui")
			return -1
		end
		if buttonID == 2 then
			-- disable all widgets, but don't reload
			for _, namedata in ipairs(fullWidgetsList) do
				widgetHandler:DisableWidget(namedata[1])
			end
			widgetHandler:SaveConfigData()
			return -1
		end
		if buttonID == 3 and allowuserwidgets then
			-- tell the widget handler that we allow/disallow user widgets and reload
			if widgetHandler.allowUserWidgets then
				widgetHandler.__allowUserWidgets = false
				Spring.Echo("Disallowed user widgets, reloading...")
			else
				widgetHandler.__allowUserWidgets = true
				Spring.Echo("Allowed user widgets, reloading...")
			end
			Spring.SendCommands("luarules reloadluaui")
			return -1
		end
		if buttonID == 4 then
			Spring.SendCommands("luaui reset")
			return -1
		end
		if buttonID == 5 then
			Spring.SendCommands("luaui factoryreset")
			return -1
		end
	end

	local namedata = self:AboveLabel(x, y)
	if not namedata then
		return false
	end

	local name = namedata[1]
	local data = namedata[2]

	if mb == 1 then
		widgetHandler:ToggleWidget(name)
	elseif mb == 2 or mb == 3 then
		local w = widgetHandler:FindWidget(name)
		if not w then
			return -1
		end
		if mb == 2 then
			widgetHandler:LowerWidget(w)
		else
			widgetHandler:RaiseWidget(w)
		end
		widgetHandler:SaveConfigData()
	end
	return -1
end

function widget:AboveLabel(x, y)
	if x < minx or y < (miny + bordery) or
		x > maxx or y > (maxy - bordery) then
		return nil
	end
	local count = #widgetsList
	if count < 1 then
		return nil
	end

	local i = floor(1 + ((maxy - bordery) - y) / (yStep * sizeMultiplier))
	if i < 1 then
		i = 1
	elseif i > count then
		i = count
	end

	return widgetsList[i]
end

function widget:IsAbove(x, y)
	if not show then
		return false
	end
	UpdateList()
	if showButtons then
		if x < minx or x > maxx + (yStep * sizeMultiplier) or
			y < miny - #buttons * buttonHeight or y > maxy + bgPadding then
			return false
		end
	end
	return true
end

function widget:GetTooltip(x, y)
	if not show then
		return nil
	end

	UpdateList()
	local namedata = self:AboveLabel(x, y)
	if not namedata then
		return '\255\200\255\200' .. 'Widget Selector\n' ..
			'\255\255\255\200' .. 'LMB: toggle widget\n' ..
			'\255\255\200\200' .. 'MMB: lower  widget\n' ..
			'\255\200\200\255' .. 'RMB: raise  widget'
	end

	local n = namedata[1]
	local d = namedata[2]

	local order = widgetHandler.orderList[n]
	local enabled = order and (order > 0)

	local tt = (d.active and GreenStr) or (enabled and YellowStr) or RedStr
	tt = tt .. n .. '\n'
	tt = d.desc and tt .. WhiteStr .. d.desc .. '\n' or tt
	tt = d.author and tt .. BlueStr .. 'Author:  ' .. CyanStr .. d.author .. '\n' or tt
	tt = tt .. MagentaStr .. d.basename
	if d.fromZip then
		tt = tt .. RedStr .. ' (mod widget)'
	end
	return tt
end

function widget:GetConfigData()
	local data = { startEntry = startEntry, curMaxEntries = curMaxEntries, show = show }
	return data
end

function widget:SetConfigData(data)
	startEntry = data.startEntry or startEntry
	curMaxEntries = data.curMaxEntries or curMaxEntries
	show = data.show or show
end

function widget:TextCommand(s)
	-- process request to tell the widgetHandler to blank out the widget config when it shuts down
	local token = {}
	local n = 0
	for w in string.gmatch(s, "%S+") do
		n = n + 1
		token[n] = w
	end
	if n == 1 and token[1] == "reset" then
		-- tell the widget handler to reload with a blank config
		widgetHandler.blankOutConfig = true
		Spring.SendCommands("luarules reloadluaui")
	end
	if n == 1 and token[1] == "factoryreset" then
		-- tell the widget handler to disallow user widgets and reload with a blank config
		widgetHandler.__blankOutConfig = true
		widgetHandler.__allowUserWidgets = false
		Spring.SendCommands("luarules reloadluaui")
	end
end

function widget:Shutdown()
	Spring.SendCommands('bind f11 luaui selector') -- if this one is removed or crashes, then have the backup one take over.

	if WG['guishader'] then
		WG['guishader'].DeleteDlist('widgetselector')
	end
	gl.DeleteFont(font)
	gl.DeleteFont(font2)
end
