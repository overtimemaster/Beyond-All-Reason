function widget:GetInfo()
	return {
		name = "Minimap",
		desc = "",
		author = "Floris",
		date = "April 2020",
		license = "GNU GPL, v2 or later",
		layer = 0,
		enabled = true,
	}
end

local maxAllowedWidth = 0.29
local maxAllowedHeight = 0.32
local leftClickMove = true

local vsx, vsy = Spring.GetViewGeometry()

local maxHeight = maxAllowedHeight
local maxWidth = math.min(maxHeight * (Game.mapX / Game.mapY), maxAllowedWidth * (vsx / vsy))
local usedWidth = math.floor(maxWidth * vsy)
local usedHeight = math.floor(maxHeight * vsy)

local ui_opacity = tonumber(Spring.GetConfigFloat("ui_opacity", 0.6) or 0.66)
local ui_scale = tonumber(Spring.GetConfigFloat("ui_scale", 1) or 1)

local backgroundRect = { 0, 0, 0, 0 }

local delayedSetup = false
local sec = 0
local uiOpacitySec = 0

local spGetCameraState = Spring.GetCameraState
local math_isInRect = math.isInRect

local wasOverview = false
local leftclicked = false

local RectRound, UiElement, elementCorner, elementPadding, elementMargin
local dlistGuishader, dlistMinimap, oldMinimapGeometry, chobbyInterface

local function checkGuishader(force)
	if WG['guishader'] then
		if force and dlistGuishader then
			dlistGuishader = gl.DeleteList(dlistGuishader)
		end
		if not dlistGuishader then
			dlistGuishader = gl.CreateList(function()
				RectRound(backgroundRect[1], backgroundRect[2] - elementPadding, backgroundRect[3] + elementPadding, backgroundRect[4], elementCorner)
			end)
			WG['guishader'].InsertDlist(dlistGuishader, 'minimap')
		end
	elseif dlistGuishader then
		dlistGuishader = gl.DeleteList(dlistGuishader)
	end
end

function widget:ViewResize()
	vsx, vsy = Spring.GetViewGeometry()

	elementPadding = WG.FlowUI.elementPadding
	elementCorner = WG.FlowUI.elementCorner
	RectRound = WG.FlowUI.Draw.RectRound
	UiElement = WG.FlowUI.Draw.Element
	elementMargin = WG.FlowUI.elementMargin

	if WG['topbar'] ~= nil then
		local topbarArea = WG['topbar'].GetPosition()
		maxAllowedWidth = (topbarArea[1] - elementMargin - elementPadding) / vsx
	end

	maxWidth = math.min(maxAllowedHeight * (Game.mapX / Game.mapY), maxAllowedWidth * (vsx / vsy))
	if maxWidth >= maxAllowedWidth * (vsx / vsy) then
		maxHeight = maxWidth / (Game.mapX / Game.mapY)
	else
		maxHeight = maxAllowedHeight
	end

	usedWidth = math.floor(maxWidth * vsy)
	usedHeight = math.floor(maxHeight * vsy)

	Spring.SendCommands(string.format("minimap geometry %i %i %i %i", 0, 0, usedWidth, usedHeight))

	backgroundRect = { 0, vsy - (usedHeight), usedWidth, vsy }
	checkGuishader(true)
	dlistMinimap = gl.DeleteList(dlistMinimap)
end

function widget:Initialize()
	oldMinimapGeometry = Spring.GetMiniMapGeometry()
	gl.SlaveMiniMap(true)

	widget:ViewResize()

	WG['minimap'] = {}
	WG['minimap'].getHeight = function()
		return usedHeight + elementPadding
	end
	WG['minimap'].getMaxHeight = function()
		return math.floor(maxAllowedHeight * vsy), maxAllowedHeight
	end
	WG['minimap'].setMaxHeight = function(value)
		maxAllowedHeight = value
		widget:ViewResize()
	end
	WG['minimap'].getLeftClickMove = function()
		return leftClickMove
	end
	WG['minimap'].setLeftClickMove = function(value)
		leftClickMove = value
	end
end

function widget:GameStart()
	widget:ViewResize()
end

function widget:Shutdown()
	dlistMinimap = gl.DeleteList(dlistMinimap)
	if WG['guishader'] and dlistGuishader then
		WG['guishader'].DeleteDlist('minimap')
		dlistGuishader = nil
	end

	gl.SlaveMiniMap(false)
	Spring.SendCommands("minimap geometry " .. oldMinimapGeometry)
end

function widget:Update(dt)
	if not delayedSetup then
		sec = sec + dt
		if sec > 2 then
			delayedSetup = true
			widget:ViewResize()
		end
	end

	uiOpacitySec = uiOpacitySec + dt
	if uiOpacitySec > 0.5 then
		Spring.SendCommands(string.format("minimap geometry %i %i %i %i", 0, 0, usedWidth, usedHeight))
		uiOpacitySec = 0
		checkGuishader()
		if ui_scale ~= Spring.GetConfigFloat("ui_scale", 1) then
			ui_scale = Spring.GetConfigFloat("ui_scale", 1)
			widget:ViewResize()
		end
		if ui_opacity ~= Spring.GetConfigFloat("ui_opacity", 0.6) then
			ui_opacity = Spring.GetConfigFloat("ui_opacity", 0.6)
			dlistMinimap = gl.DeleteList(dlistMinimap)
		end
	end
end

function widget:RecvLuaMsg(msg, playerID)
	if msg:sub(1, 18) == 'LobbyOverlayActive' then
		chobbyInterface = (msg:sub(1, 19) == 'LobbyOverlayActive1')
	end
end

local st = spGetCameraState()
local stframe = 0
function widget:DrawScreen()
	if chobbyInterface then
		return
	end
	local x, y, b = Spring.GetMouseState()
	if math_isInRect(x, y, backgroundRect[1], backgroundRect[2] - elementPadding, backgroundRect[3] + elementPadding, backgroundRect[4]) then
		if not math_isInRect(x, y, backgroundRect[1], backgroundRect[2] + 1, backgroundRect[3] - 1, backgroundRect[4]) then
			Spring.SetMouseCursor('cursornormal')
		end
	end
	stframe = stframe + 1
	if stframe % 10 == 0 then
		st = spGetCameraState()
	end
	if st.name == "ov" then
		-- overview camera
		if dlistGuishader and WG['guishader'] then
			WG['guishader'].RemoveDlist('minimap')
			wasOverview = true
		end
	else
		if wasOverview then
			gl.SlaveMiniMap(true)
			wasOverview = false
		end

		if dlistGuishader and WG['guishader'] then
			WG['guishader'].InsertDlist(dlistGuishader, 'minimap')
		end
		if not dlistMinimap then
			dlistMinimap = gl.CreateList(function()
				UiElement(backgroundRect[1], backgroundRect[2] - elementPadding, backgroundRect[3] + elementPadding, backgroundRect[4], 0, 0, 1, 0)
			end)
		end
		gl.CallList(dlistMinimap)
	end

	gl.DrawMiniMap()
end

function widget:GetConfigData()
	return {
		maxHeight = maxAllowedHeight,
		leftClickMove = leftClickMove
	}
end

function widget:SetConfigData(data)
	if data.maxHeight ~= nil then
		maxAllowedHeight = data.maxHeight
	end
	if data.leftClickMove ~= nil then
		leftClickMove = data.leftClickMove
	end
end


local function minimapToWorld(x, y)
	local px = (x/usedWidth) * (Game.mapX * 512)
	local pz = ((vsy-y)/usedHeight) * (Game.mapY * 512)
	return px, Spring.GetGroundHeight(px,pz), pz
end

function widget:MouseMove(x, y)
	if leftclicked and leftClickMove then
		local px, py, pz = minimapToWorld(x, y)
		if py then
			Spring.SetCameraTarget(px, py, pz, 0.04)
		end
	end
end

function widget:MousePress(x, y, button)
	if Spring.IsGUIHidden() then
		return
	end
	leftclicked = false
	if math_isInRect(x, y, backgroundRect[1], backgroundRect[2] - elementPadding, backgroundRect[3] + elementPadding, backgroundRect[4]) then
		if not math_isInRect(x, y, backgroundRect[1], backgroundRect[2] + 1, backgroundRect[3] - 1, backgroundRect[4]) then
			return true
		elseif button == 1 and leftClickMove then
			leftclicked = true
			local px, py, pz = minimapToWorld(x, y)
			if py then
				Spring.SetCameraTarget(px, py, pz, 0.2)
				return true
			end
		end
	end
end

function widget:MouseRelease(x, y, button)
	leftclicked = false
end
