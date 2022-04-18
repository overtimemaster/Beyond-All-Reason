function widget:GetInfo()
	return {
		name = "AllyCursors",
		desc = "Shows the mouse pos of allied players",
		author = "Floris,jK,TheFatController",
		date = "31 may 2015",
		license = "GNU GPL, v2 or later",
		layer = 5,
		enabled = true,
	}
end

-- TODO: hide (enemy) cursor light when not specfullview

local cursorSize = 11
local drawNamesCursorSize = 8.5

local dlistAmount = 5        -- number of dlists generated for each player (# available opacity levels)

local packetInterval = 0.33
local numMousePos = 2 --//num mouse pos in 1 packet

local showSpectatorName = true
local showPlayerName = true
local showCursorDot = true
local drawNamesScaling = true
local drawNamesFade = true

local fontSizePlayer = 18
local fontOpacityPlayer = 0.7
local fontSizeSpec = 13
local fontOpacitySpec = 0.5

local NameFadeStartDistance = 4000
local NameFadeEndDistance = 6500
local idleCursorTime = 25        -- fade time cursor (specs only)

local addLights = true
local lightRadiusMult = 0.5
local lightStrengthMult = 0.85

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local spGetGroundHeight = Spring.GetGroundHeight
local spGetPlayerInfo = Spring.GetPlayerInfo
local spGetTeamColor = Spring.GetTeamColor
local spIsSphereInView = Spring.IsSphereInView
local spGetCameraPosition = Spring.GetCameraPosition
local spGetCameraDirection = Spring.GetCameraDirection
local spIsGUIHidden = Spring.IsGUIHidden
local spAreTeamsAllied = Spring.AreTeamsAllied

local glCreateList = gl.CreateList
local glDeleteList = gl.DeleteList
local glCallList = gl.CallList

local abs = math.abs
local floor = math.floor
local min = math.min
local diag = math.diag
local GL_QUADS = GL.QUADS
local clock = os.clock
local alliedCursorsPos = {}
local prevCursorPos = {}
local alliedCursorsTime = {}        -- for API purpose
local usedCursorSize = cursorSize
local prevMouseX, prevMouseY = 0
local allycursorDrawList = {}
local myPlayerID = Spring.GetMyPlayerID()
local mySpec, fullview = Spring.GetSpectatingState()
local myTeamID = Spring.GetMyTeamID()

local allyCursor = ":n:LuaUI/Images/allycursor.dds"
local cursors = {}
local teamColors = {}
local specList = {}
local time, wx, wz, lastUpdateDiff, scale, iscale, fscale, wy --keep memory always allocated for these since they are referenced so frequently
local notIdle = {}
local playerPos = {}

local teamColorKeys = {}
local teams = Spring.GetTeamList()
for i = 1, #teams do
	local r, g, b, a = spGetTeamColor(teams[i])
	teamColorKeys[teams[i]] = r..'_'..g..'_'..b
end
teams = nil

local font, chobbyInterface, functionID, wx_old, wz_old

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function deleteDlists()
	for playerID, dlists in pairs(allycursorDrawList) do
		for _, dlist in pairs(dlists) do
			gl.DeleteList(dlist)
		end
	end
	allycursorDrawList = {}
end

local function GetLights(beamLights, beamLightCount, pointLights, pointLightCount)
	if not Spring.IsGUIHidden() and not chobbyInterface then
		for playerID, cursor in pairs(cursors) do
			if teamColors[playerID] and not cursor[8] and notIdle[playerID] then
				local params = { param = {} }
				params.px, params.py, params.pz = cursor[1], cursor[2], cursor[3]
				params.param.r, params.param.g, params.param.b = teamColors[playerID][1], teamColors[playerID][2], teamColors[playerID][3]
				params.colMult = 0.4 * lightStrengthMult
				params.param.radius = 1000 * lightRadiusMult
				params.py = params.py + 50
				pointLightCount = pointLightCount + 1
				pointLights[pointLightCount] = params
			end
		end
	end
	return beamLights, beamLightCount, pointLights, pointLightCount
end

local function updateSpecList(init)
	specList = {}
	local t = Spring.GetPlayerList()
	for _, playerID in ipairs(t) do
		specList[playerID] = select(3, spGetPlayerInfo(playerID, false))
	end

	-- update deferred lights function
	if not init and addLights and WG.DeferredLighting_RegisterFunction then
		if functionID and WG.DeferredLighting_UnRegisterFunction then
			WG.DeferredLighting_UnRegisterFunction(functionID)
		end
		functionID = WG.DeferredLighting_RegisterFunction(GetLights)
	end
end

local function CubicInterpolate2(x0, x1, mix)
	local mix2 = mix * mix
	local mix3 = mix2 * mix
	return x0 * (2 * mix3 - 3 * mix2 + 1) + x1 * (3 * mix2 - 2 * mix3)
end

local function MouseCursorEvent(playerID, x, z, click)	-- dont local it
	if myPlayerID == playerID then
		return true
	end
	local playerPosList = playerPos[playerID] or {}
	playerPosList[#playerPosList + 1] = { x = x, z = z, click = click }
	playerPos[playerID] = playerPosList
	if #playerPosList < numMousePos then
		return
	end
	playerPos[playerID] = {}

	if alliedCursorsPos[playerID] then
		local acp = alliedCursorsPos[playerID]

		acp[(numMousePos) * 2 + 1] = acp[1]
		acp[(numMousePos) * 2 + 2] = acp[2]

		for i = 0, numMousePos - 1 do
			acp[i * 2 + 1] = playerPosList[i + 1].x
			acp[i * 2 + 2] = playerPosList[i + 1].z
		end

		acp[(numMousePos + 1) * 2 + 1] = clock()
		acp[(numMousePos + 1) * 2 + 2] = playerPosList[#playerPosList].click
	else
		local acp = {}
		alliedCursorsPos[playerID] = acp

		for i = 0, numMousePos - 1 do
			acp[i * 2 + 1] = playerPosList[i + 1].x
			acp[i * 2 + 2] = playerPosList[i + 1].z
		end

		acp[(numMousePos) * 2 + 1] = playerPosList[(numMousePos - 2) * 2 + 1].x
		acp[(numMousePos) * 2 + 2] = playerPosList[(numMousePos - 2) * 2 + 1].z

		acp[(numMousePos + 1) * 2 + 1] = clock()
		acp[(numMousePos + 1) * 2 + 2] = playerPosList[#playerPosList].click
		acp[(numMousePos + 1) * 2 + 3] = select(4, spGetPlayerInfo(playerID, false))
	end

	-- check if there has been changes
	if prevCursorPos[playerID] == nil or alliedCursorsPos[playerID][1] ~= prevCursorPos[playerID][1] or alliedCursorsPos[playerID][2] ~= prevCursorPos[playerID][2] then
		alliedCursorsTime[playerID] = clock()
		if prevCursorPos[playerID] == nil then
			prevCursorPos[playerID] = {}
		end
		prevCursorPos[playerID][1] = alliedCursorsPos[playerID][1]
		prevCursorPos[playerID][2] = alliedCursorsPos[playerID][2]
	end
end

local function DrawGroundquad(wx, wy, wz, size)
	gl.TexCoord(0, 0)
	gl.Vertex(wx - size, wy + size, wz - size)
	gl.TexCoord(0, 1)
	gl.Vertex(wx - size, wy + size, wz + size)
	gl.TexCoord(1, 1)
	gl.Vertex(wx + size, wy + size, wz + size)
	gl.TexCoord(1, 0)
	gl.Vertex(wx + size, wy + size, wz - size)
end

local function SetTeamColor(teamID, playerID, a)
	local color = teamColors[playerID]
	if color then
		gl.Color(color[1], color[2], color[3], color[4] * a)
		return
	end

	--make color
	local r, g, b = spGetTeamColor(teamID)
	if specList[playerID] then
		color = { 1, 1, 1, 0.6 }
	elseif r and g and b then
		color = { r, g, b, 0.75 }
	end
	teamColors[playerID] = color
	gl.Color(color)
	return
end


function widget:ViewResize()
	font = WG['fonts'].getFont(nil, 1, 0.2, 1.3)
	deleteDlists()
end

function widget:Initialize()
	widget:ViewResize()
	widgetHandler:RegisterGlobal('MouseCursorEvent', MouseCursorEvent)

	if showPlayerName then
		usedCursorSize = drawNamesCursorSize
	end
	updateSpecList(true)

	WG['allycursors'] = {}
	WG['allycursors'].setLights = function(value)
		addLights = value
		if value then
			if WG.DeferredLighting_RegisterFunction then
				functionID = WG.DeferredLighting_RegisterFunction(GetLights)
			end
		else
			if functionID and WG.DeferredLighting_UnRegisterFunction then
				WG.DeferredLighting_UnRegisterFunction(functionID)
			end
		end
	end
	WG['allycursors'].getLights = function()
		return addLights
	end
	WG['allycursors'].setLightStrength = function(value)
		lightStrengthMult = value
		if functionID and WG.DeferredLighting_UnRegisterFunction then
			WG.DeferredLighting_UnRegisterFunction(functionID)
		end
		if WG.DeferredLighting_RegisterFunction then
			functionID = WG.DeferredLighting_RegisterFunction(GetLights)
		end
	end
	WG['allycursors'].getLightStrength = function()
		return lightStrengthMult
	end
	WG['allycursors'].setLightRadius = function(value)
		lightRadiusMult = value
		if functionID and WG.DeferredLighting_UnRegisterFunction then
			WG.DeferredLighting_UnRegisterFunction(functionID)
		end
		if WG.DeferredLighting_RegisterFunction then
			functionID = WG.DeferredLighting_RegisterFunction(GetLights)
		end
	end
	WG['allycursors'].getLightRadius = function()
		return lightRadiusMult
	end
	WG['allycursors'].setCursorDot = function(value)
		showCursorDot = value
		deleteDlists()
	end
	WG['allycursors'].getCursorDot = function()
		return showCursorDot
	end
	WG['allycursors'].setPlayerNames = function(value)
		showPlayerName = value
		deleteDlists()
	end
	WG['allycursors'].getPlayerNames = function()
		return showPlayerName
	end
	WG['allycursors'].setSpectatorNames = function(value)
		showSpectatorName = value
		deleteDlists()
	end
	WG['allycursors'].getSpectatorNames = function()
		return showSpectatorName
	end

	local now = clock() - (idleCursorTime * 0.95)
	local pList = Spring.GetPlayerList()
	for _, playerID in ipairs(pList) do
		alliedCursorsTime[playerID] = now
	end
	if addLights and WG.DeferredLighting_RegisterFunction then
		functionID = WG.DeferredLighting_RegisterFunction(GetLights)
	end
end

function widget:Shutdown()
	widgetHandler:DeregisterGlobal('MouseCursorEvent')
	deleteDlists()
	if functionID and WG.DeferredLighting_UnRegisterFunction then
		WG.DeferredLighting_UnRegisterFunction(functionID)
	end
end

function widget:PlayerChanged(playerID)
	myTeamID = Spring.GetMyTeamID()
	local _, _, isSpec, teamID = spGetPlayerInfo(playerID, false)
	specList[playerID] = isSpec
	local r, g, b = spGetTeamColor(teamID)
	if isSpec then
		teamColors[playerID] = { 1, 1, 1, 0.6 }
	elseif r and g and b then
		teamColors[playerID] = { r, g, b, 0.75 }
	end
	if allycursorDrawList[playerID] ~= nil then
		for _, dlist in pairs(allycursorDrawList[playerID]) do
			gl.DeleteList(dlist)
		end
		allycursorDrawList[playerID] = nil
	end

	-- update speclist when player becomes spectator
	--if isSpec and not specList[playerID] then
		updateSpecList()
	--end
end

function widget:PlayerAdded(playerID)
	widget:PlayerChanged(playerID)
end

function widget:PlayerRemoved(playerID, reason)
	specList[playerID] = nil
	notIdle[playerID] = nil
	cursors[playerID] = nil
	prevCursorPos[playerID] = nil
	alliedCursorsPos[playerID] = nil
	if allycursorDrawList[playerID] then
		for _, dlist in pairs(allycursorDrawList[playerID]) do
			gl.DeleteList(dlist)
		end
		allycursorDrawList[playerID] = nil
	end
	updateSpecList()
end

local function createCursorDrawList(playerID, opacityMultiplier)
	local name, _, spec, teamID = spGetPlayerInfo(playerID, false)
	local r, g, b = spGetTeamColor(teamID)
	local wx, wy, wz = 0, 0, 0
	local quadSize = usedCursorSize
	if spec then
		quadSize = usedCursorSize * 0.77
	end

	SetTeamColor(teamID, playerID, 1)

	-- draw player cursor
	if not spec and showCursorDot then
		gl.Texture(allyCursor)
		gl.BeginEnd(GL.QUADS, DrawGroundquad, wx, wy, wz, quadSize)
		gl.Texture(false)
	end

	if spec or showPlayerName then

		-- draw nickname
		if not spec or showSpectatorName then
			gl.PushMatrix()
			gl.Translate(wx, wy, wz)
			gl.Rotate(-90, 1, 0, 0)

			font:Begin()
			if spec then
				font:SetTextColor(1, 1, 1, fontOpacitySpec * opacityMultiplier)
				font:Print(name, 0, 0, fontSizeSpec, "cn")
			else
				local verticalOffset = usedCursorSize + 8
				local horizontalOffset = usedCursorSize + 1
				-- text shadow
				font:SetTextColor(0, 0, 0, fontOpacityPlayer * 0.62 * opacityMultiplier)
				font:Print(name, horizontalOffset - (fontSizePlayer / 50), verticalOffset - (fontSizePlayer / 42), fontSizePlayer, "n")
				font:Print(name, horizontalOffset + (fontSizePlayer / 50), verticalOffset - (fontSizePlayer / 42), fontSizePlayer, "n")
				-- text
				font:SetTextColor(r, g, b, fontOpacityPlayer * opacityMultiplier)
				font:Print(name, horizontalOffset, verticalOffset, fontSizePlayer, "n")
			end
			font:End()
			gl.PopMatrix()
		end
	end
end

local function DrawCursor(playerID, wx, wy, wz, camX, camY, camZ, opacity)
	if not spIsSphereInView(wx, wy, wz, usedCursorSize) then
		return
	end

	--calc scale
	local camDistance = diag(camX - wx, camY - wy, camZ - wz)
	local glScale = 0.83 + camDistance / 5000

	-- calc opacity
	local opacityMultiplier = 1
	if drawNamesFade and camDistance > NameFadeStartDistance then
		opacityMultiplier = (1 - (camDistance - NameFadeStartDistance) / (NameFadeEndDistance - NameFadeStartDistance))
		if opacityMultiplier > 1 then
			opacityMultiplier = 1
		end
	end

	if opacity >= 1 then
		opacityMultiplier = floor(opacityMultiplier * dlistAmount) / dlistAmount
	else
		-- if (spec and) fading out due to idling
		opacityMultiplier = floor(opacityMultiplier * (opacity * dlistAmount)) / dlistAmount
	end

	if opacityMultiplier > 0.11 then
		if allycursorDrawList[playerID] == nil then
			allycursorDrawList[playerID] = {}
		end
		if allycursorDrawList[playerID][opacityMultiplier] == nil then
			allycursorDrawList[playerID][opacityMultiplier] = glCreateList(createCursorDrawList, playerID, opacityMultiplier)
		end

		local rotValue = 0
		gl.PushMatrix()
		gl.Translate(wx, wy, wz)
		gl.Rotate(rotValue, 0, 1, 0)
		if drawNamesScaling then
			gl.Scale(glScale, 0, glScale)
		end
		glCallList(allycursorDrawList[playerID][opacityMultiplier])
		if drawNamesScaling then
			gl.Scale(-glScale, 0, -glScale)
		end
		gl.PopMatrix()
	end
end

function widget:RecvLuaMsg(msg, playerID)
	if msg:sub(1, 18) == 'LobbyOverlayActive' then
		chobbyInterface = (msg:sub(1, 19) == 'LobbyOverlayActive1')
	end
end

local function updateCursor(playerID, wx, wy, wz, camX, camY, camZ, opacity, sl)
  if cursors[playerID] == nil then
			cursors[playerID] = { wx, wy, wz, camX, camY, camZ, opacity, sl}
  else
    cursors[playerID][1] = wx
    cursors[playerID][2] = wy
    cursors[playerID][3] = wz
    cursors[playerID][4] = camX
    cursors[playerID][5] = camY
    cursors[playerID][6] = camZ
    cursors[playerID][7] = opacity
    cursors[playerID][8] = sl
  end
end



local sec = 0
function widget:Update(dt)
	if chobbyInterface then
		return
	end
	if spIsGUIHidden() then
		return
	end
	time = clock()

	sec = sec + dt
	if sec > 1.5 then
		sec = 0

		-- check if team colors have changed
		local teams = Spring.GetTeamList()
		for i = 1, #teams do
			local r, g, b, a = spGetTeamColor(teams[i])
			if teamColorKeys[teams[i]] ~= r..'_'..g..'_'..b then
				teamColorKeys[teams[i]] = r..'_'..g..'_'..b
				local players = Spring.GetPlayerList(teams[i])
				for _, playerID in ipairs(players) do
					widget:PlayerChanged(playerID)
				end
			end
		end
	end

	local camX, camY, camZ = spGetCameraPosition()
	--local camRotX, camRotY, camRotZ = spGetCameraDirection()		-- x is fucked when springstyle camera tries to stay/snap angularly
	--Spring.Echo(camRotX.."   "..camRotY.."   "..camRotZ)
	for playerID, data in pairs(alliedCursorsPos) do
		local wx, wz = data[1], data[2]
		local lastUpdatedDiff = time - data[#data - 2] + 0.025

		if lastUpdatedDiff < packetInterval then
			local scale = (1 - (lastUpdatedDiff / packetInterval)) * numMousePos
			local iscale = min(floor(scale), numMousePos - 1)
			local fscale = scale - iscale
			wx = CubicInterpolate2(data[iscale * 2 + 1], data[(iscale + 1) * 2 + 1], fscale)
			wz = CubicInterpolate2(data[iscale * 2 + 2], data[(iscale + 1) * 2 + 2], fscale)
		end

		if notIdle[playerID] then
			-- and alliedCursorsTime[playerID] > (time-idleCursorTime)
			local opacity = 1
			if specList[playerID] then
				opacity = 1 - ((time - alliedCursorsTime[playerID]) / idleCursorTime)
				if opacity > 1 then
					opacity = 1
				end
			end
			if opacity > 0.1 then
				local wy = spGetGroundHeight(wx, wz)
				updateCursor(playerID,wx, wy, wz, camX, camY, camZ, opacity, specList[playerID])
        -- for future reference, avoid recreating tables every frame, just update it with a function
				--cursors[playerID] = { wx, wy, wz, camX, camY, camZ, opacity, specList[playerID] }
			else
				notIdle[playerID] = nil
				cursors[playerID] = nil
			end
		else
			-- mark a player as notIdle as soon as they move (and keep them always set notIdle after this)
			if wx and wz and wz_old and wz_old and (abs(wx_old - wx) >= 1 or abs(wz_old - wz) >= 1) then
				--abs is needed because of floating point used in interpolation
				notIdle[playerID] = true
				wx_old = nil
				wz_old = nil
			else
				wx_old = wx
				wz_old = wz
			end
		end
	end
end

function widget:DrawWorldPreUnit()
	if chobbyInterface then
		return
	end
	if spIsGUIHidden() then
		return
	end

	fullview = select(2, Spring.GetSpectatingState())

	gl.DepthTest(GL.ALWAYS)
	gl.Blending(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA)
	gl.PolygonOffset(-7, -10)

	for playerID, cursor in pairs(cursors) do
		if notIdle[playerID] then
			if fullview or spAreTeamsAllied(myTeamID, spGetPlayerInfo(playerID) and select(4, spGetPlayerInfo(playerID))) then
				DrawCursor(playerID, cursor[1], cursor[2], cursor[3], cursor[4], cursor[5], cursor[6], cursor[7])
			end
		end
	end

	gl.PolygonOffset(false)
	gl.DepthTest(false)
end

function widget:GetConfigData(data)
	return {
		addLights = addLights,
		lightRadiusMult = lightRadiusMult,
		lightStrengthMult = lightStrengthMult,
		showCursorDot = showCursorDot,
		showSpectatorName = showSpectatorName,
		showPlayerName = showPlayerName
	}
end

function widget:SetConfigData(data)
	if data.showSpectatorName ~= nil then
		showSpectatorName = data.showSpectatorName
	end
	if data.showPlayerName ~= nil then
		showPlayerName = data.showPlayerName
	end
	if showPlayerName then
		usedCursorSize = drawNamesCursorSize
	end
	if data.addLights ~= nil then
		addLights = data.addLights
		lightRadiusMult = data.lightRadiusMult
		lightStrengthMult = data.lightStrengthMult
		if data.showCursorDot ~= nil then
			showCursorDot = data.showCursorDot
		end
	end
end
