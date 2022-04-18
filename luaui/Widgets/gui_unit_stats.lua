
function widget:GetInfo()
	return {
		name      = "Unit Stats",
		desc      = "Shows detailed unit stats",
		author    = "Niobium + Doo",
		date      = "Jan 11, 2009",
		version   = 1.7,
		license   = "GNU GPL, v2 or later",
		layer     = -9999999990,
		enabled   = true,  --  loaded by default?
	}
end

local texts = {        -- fallback (if you want to change this, also update: language/en.lua, or it will be overwritten)
	prog = 'Prog',
	metal = 'Metal',
	energy = 'Energy',
	cost = 'Cost',
	move = 'Move',
	speedaccelturn = 'Speed / Accel / Turn',
	build = 'Build',
	los = 'Los',
	airlos = 'AirLos',
	radar = 'Radar',
	sonar = 'Sonar',
	jammer = 'Jam',
	sonarjam = 'Sonar Jam',
	seis = 'Seis',
	other = 'Other',
	stealth = 'Stealth',
	armor = 'Armor',
	class = 'class',
	exp = 'Exp',
	open = 'Open',
	closed = 'Closed',
	maxhp = 'max HP',
	health = 'health',
	assist = 'Assist',
	repair = 'Repair',
	reclaim = 'Reclaim',
	resurrect = 'Resurrect',
	capture = 'Capture',
	cloak = 'Cloak',
	waterweapon = 'Waterweapon',
	manuelfire = 'Manuelfire',
	stockpile = 'Stockpile',
	paralyzer = 'Paralyzer',
	kamikaze = 'Kamikaze',
	abilities = 'Abilities',
	deathexplosion = 'Death Explosion',
	selfdestruct = 'Self Destruct',
	weap = 'Weap',
	accuracy = 'accuracy',
	aim = 'aim',
	firerate = 'firerate',
	range = 'range',
	aoe = 'aoe',
	edge = 'edge',
	s = 's', -- seconds abbr
	reload = 'reload',
	paralyze = 'paralyze',
	impulse = 'impulse',
	crater = 'crater',
	info = 'Info',
	dmg = 'Dmg',
	infinite = 'infinite',
	burst = 'Burst',
	modifiers = 'Modifiers',
	each = 'each',
	dps = 'DPS',
	persecond = 'per second',
	totaldmg = 'Total Dmg',
}

local damageStats = (VFS.FileExists("LuaUI/Config/BAR_damageStats.lua")) and VFS.Include("LuaUI/Config/BAR_damageStats.lua")
local gameName = Game.gameName

if damageStats and damageStats[gameName] and damageStats[gameName].team then
	local rate = 0
	for k, v in pairs (damageStats[gameName].team) do
		if not v == damageStats[gameName].team.games and v.cost and v.killed_cost then
			local compRate = v.killed_cost/v.cost
			if compRate > rate then
				highestUnitDef = k
				rate = compRate
			end
		end
	end
	local scndRate = 0
	for k, v in pairs (damageStats[gameName].team) do
		if not v == damageStats[gameName].team.games and v.cost and v.killed_cost then
			local compRate = v.killed_cost/v.cost
			if compRate > scndRate and k ~= highestUnitDef then
				scndhighestUnitDef = k
				scndRate = compRate
			end
		end
	end
	local thirdRate = 0
	--local thirdhighestUnitDef
	for k, v in pairs (damageStats[gameName].team) do
		if not v == damageStats[gameName].team.games and v.cost and v.killed_cost then
			local compRate = v.killed_cost/v.cost
			if compRate > thirdRate and k ~= highestUnitDef and k ~= scndhighestUnitDef then
				--thirdhighestUnitDef = k
				thirdRate = compRate
			end
		end
	end
	--Spring.Echo("1st = "..  highestUnitDef .. ", ".. rate)
	--Spring.Echo("2nd = "..  scndhighestUnitDef .. ", ".. scndRate)
	--Spring.Echo("3rd = "..  thirdhighestUnitDef .. ", ".. thirdRate)
end

include("keysym.h.lua")
----v1.7 by Doo changes
-- Reverted "Added beamtime to oRld value to properly count dps of BeamLaser weapons" because reload starts at the beginning of the beamtime
-- Reduced the "minimal" reloadTime to properly calculate dps for low reloadtime weapons
-- Hid range from gui for explosion (death/selfd) as it is irrelevant.

----v1.6 by Doo changes
-- Fixed crashing when hovering some enemy units

----v1.5 by Doo changes
-- Fixed some issues with the add of BeamTime values
-- Added a 1/30 factor to stockpiling weapons (seems like the lua wDef.stockpileTime is in frames while the weaponDefs uses seconds) Probably the 1/30 value in older versions wasnt a "min reloadtime" but the 1/30 factor for stockpile weapons with a typo

----v1.4 by Doo changes
-- Added beamtime to oRld value to properly count dps of BeamLaser weapons

---- v1.3 changes
-- Fix for 87.0
-- Added display of experience effect (when experience >25%)

---- v1.2 changes
-- Fixed drains for burst weapons (Removed 0.125 minimum)
-- Show remaining costs for units under construction

---- v1.1 changes
-- Added extra text to help explain numbers
-- Added grouping of duplicate weapons
-- Added sonar radius
-- Fixed radar/jammer detection
-- Fixed stockpiling unit drains
-- Fixed turnrate/acceleration scale
-- Fixed very low reload times

------------------------------------------------------------------------------------
-- Globals
------------------------------------------------------------------------------------
local useSelection = true

local fontfile = "fonts/" .. Spring.GetConfigString("bar_font", "Poppins-Regular.otf")

local customFontSize = 14
local fontSize = customFontSize

local cX, cY, cYstart

local vsx, vsy = gl.GetViewSizes()
local widgetScale = 1
local xOffset = (32 + (fontSize*0.9))*widgetScale
local yOffset = -((32 - (fontSize*0.9))*widgetScale)
local ui_scale = tonumber(Spring.GetConfigFloat("ui_scale",1) or 1)

------------------------------------------------------------------------------------
-- Speedups
------------------------------------------------------------------------------------

local white = '\255\255\255\255'
local grey = '\255\190\190\190'
local green = '\255\1\255\1'
local yellow = '\255\255\255\1'
local orange = '\255\255\128\1'
local blue = '\255\128\128\255'

local metalColor = '\255\196\196\255' -- Light blue
local energyColor = '\255\255\255\128' -- Light yellow
local buildColor = '\255\128\255\128' -- Light green

local simSpeed = Game.gameSpeed

local max = math.max
local floor = math.floor
local ceil = math.ceil
local format = string.format
local char = string.char

local glColor = gl.Color

local spGetMyTeamID = Spring.GetMyTeamID
local spGetTeamResources = Spring.GetTeamResources
local spGetTeamInfo = Spring.GetTeamInfo
local spGetPlayerInfo = Spring.GetPlayerInfo
local spGetTeamColor = Spring.GetTeamColor
local spIsUserWriting = Spring.IsUserWriting
local spGetModKeyState = Spring.GetModKeyState
local spGetMouseState = Spring.GetMouseState
local spTraceScreenRay = Spring.TraceScreenRay

local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitHealth = Spring.GetUnitHealth
local spGetUnitTeam = Spring.GetUnitTeam
local spGetUnitExperience = Spring.GetUnitExperience
local spGetUnitSensorRadius = Spring.GetUnitSensorRadius
local spGetUnitWeaponState = Spring.GetUnitWeaponState

local uDefs = UnitDefs
local wDefs = WeaponDefs

local font, chobbyInterface, showUnitID
local RectRound, UiElement, UiUnit, bgpadding, elementCorner

local maxWidth = 0
local textBuffer = {}
local textBufferCount = 0

local spec = Spring.GetSpectatingState()

local anonymousMode = Spring.GetModOptions().teamcolors_anonymous_mode

local showStats = false

local isCommander = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	if unitDef.customParams.iscommander then
		isCommander[unitDefID] = true
	end
end

------------------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------------------

local function DrawText(t1, t2)
	textBufferCount = textBufferCount + 1
	textBuffer[textBufferCount] = {t1,t2,cX+(bgpadding*6),cY}
	cY = cY - fontSize
	maxWidth = max(maxWidth, (font:GetTextWidth(t1)*fontSize) + (bgpadding*10), (font:GetTextWidth(t2)*fontSize)+(fontSize*6.5) + (bgpadding*10))
end

local function DrawTextBuffer()
	local num = #textBuffer
	font:Begin()
	for i=1, num do
		font:Print(textBuffer[i][1], textBuffer[i][3], textBuffer[i][4], fontSize, "o")
		font:Print(textBuffer[i][2], textBuffer[i][3] + (fontSize*6.5), textBuffer[i][4], fontSize, "o")
	end
	font:End()
end

local function GetTeamColorCode(teamID)
	if not teamID then return "\255\255\255\255" end

	local R, G, B = spGetTeamColor(teamID)
	if not R then return "\255\255\255\255" end

	R = floor(R * 255)
	G = floor(G * 255)
	B = floor(B * 255)

	if (R < 11) then R = 11	end -- Note: char(10) terminates string
	if (G < 11) then G = 11	end
	if (B < 11) then B = 11	end

	return "\255" .. char(R) .. char(G) .. char(B)
end

local function GetTeamName(teamID)
	if not teamID then return 'Error:NoTeamID' end

	local _, teamLeader = spGetTeamInfo(teamID,false)
	if not teamLeader then return 'Error:NoLeader' end

	local leaderName = spGetPlayerInfo(teamLeader,false)
    if Spring.GetGameRulesParam('ainame_'..teamID) then
        leaderName = Spring.GetGameRulesParam('ainame_'..teamID)
    end
	return leaderName or 'Error:NoName'
end

local guishaderEnabled = false	-- not a config var
function RemoveGuishader()
	if guishaderEnabled and WG['guishader'] then
		WG['guishader'].DeleteScreenDlist('unit_stats_title')
		WG['guishader'].DeleteScreenDlist('unit_stats_data')
		guishaderEnabled = false
	end
end

------------------------------------------------------------------------------------
-- Code
------------------------------------------------------------------------------------

local function enableStats()
	showStats = true
end

local function disableStats()
	showStats = false
end

function widget:Initialize()
	if WG['lang'] then
		texts = WG['lang'].getText('unitstats')
	end

	widget:ViewResize(vsx,vsy)

	WG['unitstats'] = {}
	WG['unitstats'].showUnit = function(unitID)
		showUnitID = unitID
	end

	widgetHandler:AddAction("unit_stats", enableStats, nil, "p")
	widgetHandler:AddAction("unit_stats", disableStats, nil, "r")
end

function widget:Shutdown()
	WG['unitstats'] = nil
	RemoveGuishader()
end

function widget:PlayerChanged()
	spec = Spring.GetSpectatingState()
end

function init()
	vsx, vsy = gl.GetViewSizes()
	widgetScale = (1+((vsy-850)/900)) * (0.95+(ui_scale-1)/2.5)
	fontSize = customFontSize * widgetScale

	xOffset = (32 + bgpadding)*widgetScale
	yOffset = -((32 + bgpadding)*widgetScale)
end

local uiSec = 0
function widget:Update(dt)
	uiSec = uiSec + dt
	if uiSec > 0.5 then
		uiSec = 0
		if ui_scale ~= Spring.GetConfigFloat("ui_scale",1) then
			ui_scale = Spring.GetConfigFloat("ui_scale",1)
			widget:ViewResize(vsx,vsy)
		end
	end
end

function widget:ViewResize(n_vsx,n_vsy)
	vsx,vsy = Spring.GetViewGeometry()
	widgetScale = (1+((vsy-850)/1800)) * (0.95+(ui_scale-1)/2.5)

	bgpadding = WG.FlowUI.elementPadding
	elementCorner = WG.FlowUI.elementCorner

	RectRound = WG.FlowUI.Draw.RectRound
	UiElement = WG.FlowUI.Draw.Element
	UiUnit = WG.FlowUI.Draw.Unit

	font = WG['fonts'].getFont(fontfile)

	init()
end

local selectedUnits = Spring.GetSelectedUnits()
local selectedUnitsCount = Spring.GetSelectedUnitsCount()
if useSelection then
	function widget:SelectionChanged(sel)
		selectedUnits = sel
		selectedUnitsCount = Spring.GetSelectedUnitsCount()
	end
end

function widget:RecvLuaMsg(msg, playerID)
	if msg:sub(1,18) == 'LobbyOverlayActive' then
		chobbyInterface = (msg:sub(1,19) == 'LobbyOverlayActive1')
	end
end


local function drawStats(uDefID, uID)
	local mx, my = spGetMouseState()
	local alt, ctrl, meta, shift = spGetModKeyState()
	if WG['chat'] and WG['chat'].isInputActive then
		if WG['chat'].isInputActive() then
			showStats = false
		end
	end

	local uDef = uDefs[uDefID]
	local maxHP = uDef.health
	local uTeam = Spring.GetMyTeamID()
	local losRadius = uDef.losRadius
	local airLosRadius = uDef.airLosRadius
	local radarRadius = uDef.radarRadius
	local sonarRadius = uDef.sonarRadius
	local jammingRadius = uDef.jammerRadius
	local sonarJammingRadius = uDef.sonarJamRadius
	local seismicRadius = uDef.seismicRadius
	local armoredMultiple = uDef.armoredMultiple
	local buildProg, uExp
	if uID then
		_, _, _, _, buildProg = spGetUnitHealth(uID)
		maxHP = select(2,Spring.GetUnitHealth(uID))
		uTeam = spGetUnitTeam(uID)
		losRadius = spGetUnitSensorRadius(uID, 'los') or 0
		airLosRadius = spGetUnitSensorRadius(uID, 'airLos') or 0
		radarRadius = spGetUnitSensorRadius(uID, 'radar') or 0
		sonarRadius = spGetUnitSensorRadius(uID, 'sonar') or 0
		jammingRadius = spGetUnitSensorRadius(uID, 'radarJammer') or 0
		sonarJammingRadius = spGetUnitSensorRadius(uID, 'sonarJammer') or 0
		seismicRadius = spGetUnitSensorRadius(uID, 'seismic') or 0
		uExp = spGetUnitExperience(uID)
		armoredMultiple = select(2,Spring.GetUnitArmored(uID))
	end

	maxWidth = 0

	cX = mx + xOffset
	cY = my + yOffset
	cYstart = cY

	cY = cY - (bgpadding/2)

	local titleFontSize = fontSize*1.07
	local cornersize = ceil(bgpadding*0.2)
	cY = cY - 2 * titleFontSize
	textBuffer = {}
	textBufferCount = 0

	------------------------------------------------------------------------------------
	-- Units under construction
	------------------------------------------------------------------------------------
	if buildProg and buildProg < 1 then

		local myTeamID = spGetMyTeamID()
		local mCur, mStor, mPull, mInc, mExp, mShare, mSent, mRec = spGetTeamResources(myTeamID, 'metal')
		local eCur, eStor, ePull, eInc, eExp, eShare, eSent, eRec = spGetTeamResources(myTeamID, 'energy')

		local mTotal = uDef.metalCost
		local eTotal = uDef.energyCost
		local buildRem = 1 - buildProg
		local mRem = mTotal * buildRem
		local eRem = eTotal * buildRem
		local mEta = (mRem - mCur) / (mInc + mRec)
		local eEta = (eRem - eCur) / (eInc + eRec)

		DrawText(texts.prog..":", format("%d%%", 100 * buildProg))
		DrawText(texts.metal..":", format("%d / %d (" .. yellow .. "%d" .. white .. ", %ds)", mTotal * buildProg, mTotal, mRem, mEta))
		DrawText(texts.energy..":", format("%d / %d (" .. yellow .. "%d" .. white .. ", %ds)", eTotal * buildProg, eTotal, eRem, eEta))
		--DrawText("MaxBP:", format(white .. '%d', buildRem * uDef.buildTime / math.max(mEta, eEta)))
		cY = cY - fontSize
	end

	------------------------------------------------------------------------------------
	-- Generic information, cost, move, class
	------------------------------------------------------------------------------------

	--DrawText('Height:', uDefs[spGetUnitDefID(uID)].height)

	DrawText(texts.cost..":", format(metalColor .. '%d' .. white .. ' / ' ..
		energyColor .. '%d' .. white .. ' / ' ..
		buildColor .. '%d', uDef.metalCost, uDef.energyCost, uDef.buildTime)
	)

	if not (uDef.isBuilding or uDef.isFactory) then
		if not uID or not Spring.GetUnitMoveTypeData(uID) then
			DrawText(texts.move..":", format("%.1f / %.1f / %.0f ("..texts.speedaccelturn..")", uDef.speed, 900 * uDef.maxAcc, simSpeed * uDef.turnRate * (180 / 32767)))
		else
			local mData = Spring.GetUnitMoveTypeData(uID)
			local mSpeed = mData.maxSpeed or uDef.speed
			local mAccel = mData.accRate or uDef.maxAcc
			local mTurnRate = mData.baseTurnRate or uDef.turnRate
			DrawText(texts.move..":", format("%.1f / %.1f / %.0f ("..texts.speedaccelturn..")", mSpeed, 900 * mAccel, simSpeed * mTurnRate * (180 / 32767)))
		end
	end

	if uDef.buildSpeed > 0 then
		DrawText(texts.build..':', yellow .. uDef.buildSpeed)
	end


	cY = cY - fontSize

	------------------------------------------------------------------------------------
	-- Sensors and Jamming
	------------------------------------------------------------------------------------

	DrawText(texts.los..':', losRadius .. (airLosRadius > losRadius and format(' ('..texts.airlos..': %d)', airLosRadius) or ''))

	if radarRadius   > 0 then DrawText(texts.radar..':', '\255\77\255\77' .. radarRadius) end
	if sonarRadius   > 0 then DrawText(texts.sonar..':', '\255\128\128\255' .. sonarRadius) end
	if jammingRadius > 0 then DrawText(texts.jammer..':'  , '\255\255\77\77' .. jammingRadius) end
	if sonarJammingRadius > 0 then DrawText(texts.sonarjam..':', '\255\255\77\77' .. sonarJammingRadius) end
	if seismicRadius > 0 then DrawText(texts.seis..':' , '\255\255\26\255' .. seismicRadius) end

	if uDef.stealth then DrawText(texts.other..":", texts.stealth) end

	cY = cY - fontSize

	------------------------------------------------------------------------------------
	-- Armor
	------------------------------------------------------------------------------------

	DrawText(texts.armor..":", texts.class .. Game.armorTypes[uDef.armorType or 0] or '???')

	if uID and uExp ~= 0 then
		if maxHP then
			DrawText(texts.exp..":", format("+%d%% "..texts.health, (maxHP/uDef.health-1)*100))
		else
			--DrawText("Exp:                 unknown",'\255\255\77\77')
		end
	end
	if maxHP then
		DrawText(texts.open..":", format(texts.maxhp..": %d", maxHP) )

		if armoredMultiple and armoredMultiple ~= 1 then
			DrawText(texts.closed..":", format(" +%d%%, "..texts.maxhp..": %d", (1/armoredMultiple-1) *100,maxHP/armoredMultiple))
		end
	end

	cY = cY - fontSize


	------------------------------------------------------------------------------------
	-- SPECIAL ABILITIES
	------------------------------------------------------------------------------------
	---- Build Related
	local specabs = ''
	specabs = specabs..((uDef.canBuild and texts.build..", ") or "")
	specabs = specabs..((uDef.canAssist and texts.assist..", ") or "")
	specabs = specabs..((uDef.canRepair and texts.repair..", ") or "")
	specabs = specabs..((uDef.canReclaim and texts.reclaim..", ") or "")
	specabs = specabs..((uDef.canResurrect and texts.resurrect..", ") or "")
	specabs = specabs..((uDef.canCapture and texts.capture..", ") or "")
	---- Radar/Sonar states
	specabs = specabs..((uDef.canCloak and texts.cloak..", ") or "")
	specabs = specabs..((uDef.stealth and texts.stealth..",  ") or "")

	---- Attack Related
	specabs = specabs..((uDef.canAttackWater and texts.waterweapon..", ") or "")
	specabs = specabs..((uDef.canManualFire and texts.manuelfire..", ") or "")
	specabs = specabs..((uDef.canStockpile and texts.stockpile..", ") or "")
	specabs = specabs..((uDef.canParalyze  and texts.paralyzer..", ") or "")
	specabs = specabs..((uDef.canKamikaze  and texts.kamikaze..", ") or "")
	if (string.len(specabs) > 11) then
		DrawText(texts.abilities..":", string.sub(specabs, 1, string.len(specabs)-2))
		cY = cY - fontSize
	end

	------------------------------------------------------------------------------------
	-- Weapons
	------------------------------------------------------------------------------------
	local wepCounts = {} -- wepCounts[wepDefID] = #
	local wepsCompact = {} -- uWepsCompact[1..n] = wepDefID
	local uWeps = uDef.weapons
	local weaponNums = {}
	for i = 1, #uWeps do
		local wDefID = uWeps[i].weaponDef
		local wCount = wepCounts[wDefID]
		if wCount then
			wepCounts[wDefID] = wCount + 1
		else
			wepCounts[wDefID] = 1
			wepsCompact[#wepsCompact + 1] = wDefID
			weaponNums[#wepsCompact] = i
		end
	end

	local selfDWeaponID = WeaponDefNames[uDef.selfDExplosion].id
	local deathWeaponID = WeaponDefNames[uDef.deathExplosion].id
	local selfDWeaponIndex
	local deathWeaponIndex

	if shift then
		wepCounts = {}
		wepsCompact = {}
		wepCounts[selfDWeaponID] = 1
		wepCounts[deathWeaponID] = 1
		deathWeaponIndex = #wepsCompact+1
		wepsCompact[deathWeaponIndex] = deathWeaponID
		selfDWeaponIndex = #wepsCompact+1
		wepsCompact[selfDWeaponIndex] = selfDWeaponID
	end

	local totaldps = 0
	local totaldpsAoE = 0
	local totalbDamages = 0
	local totalbDamagesAoE = 0
	local useExp = true
	for i = 1, #wepsCompact do

		local wDefId = wepsCompact[i]
		local uWep = wDefs[wDefId]
		if uWep.customParams and uWep.customParams.def then
			uWep = wDefs[WeaponDefNames[uWep.customParams.def].id]
		end
		if uWep.range > 0 then
			local oBurst = uWep.salvoSize * uWep.projectiles
			local oRld = max(0.00000000001,uWep.stockpile == true and uWep.stockpileTime/30 or uWep.reload)
			if uID and useExp and not ((uWep.stockpile and uWep.stockpileTime)) then
				oRld = spGetUnitWeaponState(uID,weaponNums[i] or -1,"reloadTimeXP") or spGetUnitWeaponState(uID,weaponNums[i] or -1,"reloadTime") or oRld
			end
			local wepCount = wepCounts[wDefId]

			local typeName =  uWep.type
			local wpnName = uWep.description
			if i == deathWeaponIndex then
				wpnName = texts.deathexplosion
				oRld = 1
			elseif i == selfDWeaponIndex then
				wpnName = texts.selfdestruct
				oRld = uDef.selfDCountdown
			end
			if wepCount > 1 then
				DrawText(texts.weap..":", format(yellow .. "%dx" .. white .. " %s", wepCount, wpnName))
			else
				DrawText(texts.weap..":", wpnName)
			end
			local reload = uWep.reload
			local accuracy = uWep.accuracy
			local moveError = uWep.targetMoveError
			local range = uWep.range
			--local reload = spGetUnitWeaponState(uID,weaponNums[i] or -1,"reloadTimeXP") or spGetUnitWeaponState(uID,weaponNums[i] or -1,"reloadTime") or uWep.reload
			--local accuracy = spGetUnitWeaponState(uID,weaponNums[i] or -1,"accuracy") or uWep.accuracy
			--local moveError = spGetUnitWeaponState(uID,weaponNums[i] or -1,"targetMoveError") or uWep.targetMoveError
			local reloadBonus = reload ~= 0 and (uWep.reload/reload-1) or 0
			local accuracyBonus = accuracy ~= 0 and (uWep.accuracy/accuracy-1) or 0
			local moveErrorBonus = moveError ~= 0 and (uWep.targetMoveError/moveError-1) or 0
			--local range = spGetUnitWeaponState(uID,weaponNums[i] or -1,"range") or uWep.range
			local ee = uWep.edgeEffectiveness
			local AoE = math.max(1,(math.pi * uWep.damageAreaOfEffect^2)/256)

			local rangeBonus = range ~= 0 and (range/uWep.range-1) or 0
			if uExp ~= 0 then
				DrawText(texts.exp..":", format("+%d%% "..texts.accuracy..", +%d%% "..texts.aim..", +%d%% "..texts.firerate..", +%d%% "..texts.range, accuracyBonus*100, moveErrorBonus*100, reloadBonus*100, rangeBonus*100 ))
			end
			local infoText = ""
			if wpnName == texts.deathexplosion or wpnName == texts.selfdestruct then
				infoText = format("%d "..texts.aoe..", %d%% "..texts.edge, uWep.damageAreaOfEffect, 100 * uWep.edgeEffectiveness)
			else
				infoText =  format("%.2f", (useExp and reload or uWep.reload))..texts.s.." "..texts.reload..", "..format("%d "..texts.range..", %d "..texts.aoe..", %d%% "..texts.edge, useExp and range or uWep.range, uWep.damageAreaOfEffect, 100 * uWep.edgeEffectiveness)
			end
			if uWep.damages.paralyzeDamageTime > 0 then
				infoText = format("%s, %ds "..texts.paralyze, infoText, uWep.damages.paralyzeDamageTime)
			end
			if uWep.damages.impulseBoost > 0 then
				infoText = format("%s, %d "..texts.impulse, infoText, uWep.damages.impulseBoost*100)
			end
			if uWep.damages.craterBoost > 0 then
				infoText = format("%s, %d "..texts.crater, infoText, uWep.damages.craterBoost*100)
			end
			if string.find(uWep.name, "disintegrator") then
				infoText = format("%.2f", (useExp and reload or uWep.reload)).."s "..texts.reload..", "..format("%d "..texts.range, useExp and range or uWep.range)
			end
			DrawText(texts.info..":", infoText)
			local defaultDamage = uWep.damages[0]
			local cat = 0
			local oDmg = uWep.damages[cat]
			local catName = Game.armorTypes[cat]
			local burst = uWep.salvoSize
			local EEFactor = (ee - (-1 + ee)*math.log(1 - ee))/ee^2
			if string.find(uWep.name, "disintegrator") then
				DrawText(texts.dmg..":", yellow..texts.infinite)
			elseif wpnName == texts.deathexplosion or wpnName == texts.selfdestruct then
				if catName and oDmg and (oDmg ~= defaultDamage or cat == 0) then
					local dmgString
					local dps = defaultDamage * burst / (useExp and reload or uWep.reload)
					local dpsAoE = dps * AoE * EEFactor
					local bDamages = defaultDamage * burst
					local bDamagesAoE = bDamages * AoE * EEFactor
					dmgString = texts.burst.." = "..(format(yellow .. "%d", bDamages))..white.."."
					dmgString = texts.burst.." = "..(format(yellow .. "%d", bDamages))..white.." ( "..(format(yellow .. "%d", bDamagesAoE))..white.." )."
					DrawText(texts.dmg..":", dmgString)
				end
				local dmgString	= white
				for cat=1, #uWep.damages do
					local oDmg = uWep.damages[cat]
					local catName = Game.armorTypes[cat]
					if catName and oDmg and (oDmg ~= defaultDamage or cat == 0) then
						dmgString = dmgString..white..catName.." = "..(format(yellow .. "%d", (oDmg*100/defaultDamage)))..yellow.."%"..white.."; "
					end
				end
				DrawText(texts.modifiers..":", dmgString)
			else
				if catName and oDmg and (oDmg ~= defaultDamage or cat == 0) then
					local dmgString
					local dps = defaultDamage * burst / (useExp and reload or uWep.reload)
					local dpsAoE = dps * AoE * EEFactor
					local bDamages = defaultDamage * burst
					local bDamagesAoE = bDamages * AoE * EEFactor
					totaldps = totaldps + wepCount*dps
					totaldpsAoE = totaldpsAoE + wepCount*dpsAoE
					totalbDamages = totalbDamages + wepCount* bDamages
					totalbDamagesAoE = totalbDamagesAoE +  wepCount*bDamagesAoE
					dmgString = texts.dps.." = "..(format(yellow .. "%d", dps))..white.."; "..texts.burst.." = "..(format(yellow .. "%d", bDamages))..white.."."
					dmgString = texts.dps.." = "..(format(yellow .. "%d", dps))..white.." ( "..(format(yellow .. "%d", dpsAoE))..white.." ) "..texts.burst.." = "..(format(yellow .. "%d", bDamages))..white.." ( "..(format(yellow .. "%d", bDamagesAoE))..white.." )."
					if wepCount > 1 then
						dmgString = dmgString .. white .. " ("..texts.each..")"
					end
					DrawText(texts.dmg..":", dmgString)
				end
				local dmgString	= white
				for cat=1, #uWep.damages do
					local oDmg = uWep.damages[cat]
					local catName = Game.armorTypes[cat]
					if catName and oDmg and (oDmg ~= defaultDamage or cat == 0) then
						dmgString = dmgString..white..catName.." = "..(format(yellow .. "%d", (oDmg*100/defaultDamage)))..yellow.."%"..white.."; "
					end
				end
				DrawText(texts.modifiers..":", dmgString)
			end


			if uWep.metalCost > 0 or uWep.energyCost > 0 then

				-- Stockpiling weapons are weird
				-- They take the correct amount of resources overall
				-- They take the correct amount of time
				-- They drain ((simSpeed+2)/simSpeed) times more resources than they should (And the listed drain is real, having lower income than listed drain WILL stall you)
				local drainAdjust = uWep.stockpile and (simSpeed+2)/simSpeed or 1

				DrawText(texts.cost..':', format(metalColor .. '%d' .. white .. ', ' ..
					energyColor .. '%d' .. white .. ' = ' ..
					metalColor .. '-%d' .. white .. ', ' ..
					energyColor .. '-%d' .. white .. ' '..texts.persecond,
					uWep.metalCost,
					uWep.energyCost,
					drainAdjust * uWep.metalCost / oRld,
					drainAdjust * uWep.energyCost / oRld))
			end


			cY = cY - fontSize
		end
	end

	if totaldps > 0 then
		DrawText(texts.totaldmg..':', texts.dps.." = "..(format(yellow .. "%d", totaldps))..white.." ( "..(format(yellow .. "%d", totaldpsAoE))..white.." ) "..texts.burst.." = "..(format(yellow .. "%d", totalbDamages))..white.." ( "..(format(yellow .. "%d", totalbDamagesAoE))..white.." ).")
		cY = cY - fontSize
	end

	-- background
	if WG['buildmenu'] and WG['buildmenu'].hoverID ~= nil then
		glColor(0.11,0.11,0.11,0.9)
	else
		glColor(0,0,0,0.66)
	end

	-- correct position when it goes below screen
	if cY < 0 then
		cYstart = cYstart - cY
		local num = #textBuffer
		for i=1, num do
			textBuffer[i][4] = textBuffer[i][4] - (cY/2)
			textBuffer[i][4] = textBuffer[i][4] - (cY/2)
		end
		cY = 0
	end
	-- correct position when it goes off screen
	if cX + maxWidth+bgpadding+bgpadding > vsx then
		local cXnew = vsx-maxWidth-bgpadding-bgpadding
		local num = #textBuffer
		for i=1, num do
			textBuffer[i][3] = textBuffer[i][3] - ((cX-cXnew)/2)
			textBuffer[i][3] = textBuffer[i][3] - ((cX-cXnew)/2)
		end
		cX = cXnew
	end

	local effectivenessRate = ''
	if damageStats and damageStats[gameName] and damageStats[gameName]["team"] and damageStats[gameName]["team"][uDef.name] and damageStats[gameName]["team"][uDef.name].cost and damageStats[gameName]["team"][uDef.name].killed_cost then
		effectivenessRate = "   "..damageStats[gameName]["team"][uDef.name].killed_cost / damageStats[gameName]["team"][uDef.name].cost
	end

	-- title
	local text = "\255\190\255\190" .. UnitDefs[uDefID].translatedHumanName
	if uID then
		local playername = ''
		if not anonymousMode or spec then
			playername = GetTeamColorCode(uTeam) .. GetTeamName(uTeam)
		end
		text = text .. "   " ..  grey ..  uDef.name .. "   #" .. uID .. "   ".. playername .. grey .. effectivenessRate
	end
	local backgroundRect = {floor(cX-bgpadding), ceil(cYstart-bgpadding), floor(cX+(font:GetTextWidth(text)*titleFontSize)+(titleFontSize*3.5)), floor(cYstart+(titleFontSize*1.8)+bgpadding)}
	UiElement(backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4], 1,1,1,0, 1,1,0,1, Spring.GetConfigFloat("ui_opacity", 0.6) + 0.2)
	if WG['guishader'] then
		guishaderEnabled = true
		WG['guishader'].InsertScreenDlist( gl.CreateList( function()
			RectRound(backgroundRect[1], backgroundRect[2], backgroundRect[3], backgroundRect[4], elementCorner, 1,1,1,0)
		end), 'unit_stats_title')
	end

	-- icon
	if uID then
		local iconPadding = math.max(1, math.floor(bgpadding*0.8))
		glColor(1,1,1,1)
		UiUnit(
			backgroundRect[1]+bgpadding+iconPadding, backgroundRect[2]+iconPadding, backgroundRect[1]+(backgroundRect[4]-backgroundRect[2])-iconPadding, backgroundRect[4]-bgpadding-iconPadding,
			nil,
			1,1,1,1,
			0.13,
			nil, nil,
			'#'..uDefID
		)
	end

	-- title text
	glColor(1,1,1,1)
	font:Begin()
	font:Print(text, backgroundRect[1]+((backgroundRect[4]-backgroundRect[2])*1.3), backgroundRect[2]+titleFontSize*0.7, titleFontSize, "o")
	font:End()

	-- stats
	UiElement(floor(cX-bgpadding), ceil(cY+(fontSize/3)+(bgpadding*0.3)), ceil(cX+maxWidth+bgpadding), ceil(cYstart-bgpadding), 0,1,1,1, 1,1,1,1, Spring.GetConfigFloat("ui_opacity", 0.6) + 0.2)

	if WG['guishader'] then
		guishaderEnabled = true
		WG['guishader'].InsertScreenDlist( gl.CreateList( function()
			RectRound(floor(cX-bgpadding), ceil(cY+(fontSize/3)+(bgpadding*0.3)), ceil(cX+maxWidth+bgpadding), floor(cYstart-bgpadding), elementCorner, 0,1,1,1)
		end), 'unit_stats_data')
	end
	DrawTextBuffer()
end

function widget:DrawScreen()
	if chobbyInterface then return end
	if WG['topbar'] and WG['topbar'].showingQuit() then
		return
	end

	if WG['chat'] and WG['chat'].isInputActive then
		if WG['chat'].isInputActive() then
			showStats = false
		end
	end
	if (not showStats and not showUnitID) or spIsUserWriting() then
		RemoveGuishader()
		return
	end
	local mx, my = spGetMouseState()
	local uID
	local rType, unitID = spTraceScreenRay(mx, my)
	if rType == 'unit' then
		uID = unitID
	end
	if useSelection then
		if selectedUnitsCount >= 1 then
			uID = selectedUnits[1]
		end
	end
	if showUnitID then
		uID = showUnitID
		showUnitID = nil
	end
	local useHoverID = false
	local _, activeID = Spring.GetActiveCommand()
	if not activeID then activeID = 0 end
	if not uID and (WG['buildmenu'] and not WG['buildmenu'].hoverID) and not (activeID < 0) then
		RemoveGuishader() return
	elseif WG['buildmenu'] and WG['buildmenu'].hoverID and not (activeID < 0) then
		uID = nil
		useHoverID = true
	elseif activeID < 0 then
		uID = nil
		useHoverID = false
	end
	if uID and not Spring.ValidUnitID(uID) then
		RemoveGuishader()
		return
	end
	local uDefID = (uID and spGetUnitDefID(uID)) or (useHoverID and WG['buildmenu'] and WG['buildmenu'].hoverID) or (UnitDefs[-activeID] and -activeID)

	if not uDefID then
		RemoveGuishader()
		return
	end

	drawStats(uDefID, uID)
end
