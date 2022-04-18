function gadget:GetInfo()
	return {
		name      = "Reclaim effect",
		desc      = "Unit/feature reclaim effect",
		author    = "Floris",
		date      = "December 2016",
		license   = "PD",
		layer     = 0,
		enabled   = true,
	}
end

if not gadgetHandler:IsSyncedCode() then
	return
end

local random = math.random

local ignoreUnits = {}
for udefID,def in ipairs(UnitDefs) do
	if def.modCategories['object'] or def.customParams.objectify then
		ignoreUnits[udefID] = true
	end
end


local featureList = {}
for featureDefID, fdef in pairs(FeatureDefs) do
	if fdef.model and fdef.model.minx and fdef.model.maxx then
		featureList[featureDefID] = {minx=fdef.model.minx, maxx=fdef.model.maxx+1, miny=fdef.model.miny, maxy=fdef.model.maxy+1, minz=fdef.model.minz, maxz=fdef.model.maxz+1}
	end
end

local unitNumFx = {}
local unitMinX = {}
local unitMaxX = {}
local unitMinZ = {}
local unitMaxZ = {}
local unitMaxY = {}
for unitDefID, unitDef in pairs(UnitDefs) do
	if not ignoreUnits[unitDef.name] then
		unitNumFx[unitDefID] = math.min(1 + math.ceil(unitDef.metalCost/250), 30)
		unitMinX[unitDefID] = unitDef.model.minx
		unitMaxX[unitDefID] = unitDef.model.maxx
		unitMinZ[unitDefID] = unitDef.model.minz
		unitMaxZ[unitDefID] = unitDef.model.maxz
		unitMaxY[unitDefID] = unitDef.model.maxy
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
	if attackerID == nil and not ignoreUnits[unitDefID] then -- if reclaimed
		local ux,uy,uz = Spring.GetUnitPosition(unitID)
		if ux ~= nil then
			local x,y,z = ux,uy,uz
			Spring.SpawnCEG("metalshards1", x, y, z)

			-- add more effects depending on unit cost
			local posMultiplier = 0.5
			for i=1, unitNumFx[unitDefID], 1 do
				x = ux + (random(unitMinX[unitDefID], unitMaxX[unitDefID])*posMultiplier)
				z = uz + (random(unitMinZ[unitDefID], unitMaxX[unitDefID])*posMultiplier)
				y = uy + (random() * unitMaxY[unitDefID]*posMultiplier)
				Spring.SpawnCEG("metalshards"..(((i+1)%3)+1), x, y, z)
			end
		end
	end
end

local damagedFeatures = {}
function gadget:FeatureDamaged(featureID, featureDefID, featureTeam, damage, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if damage > 4 and (damagedFeatures[featureID] == nil or Spring.GetGameFrame() - damagedFeatures[featureID] > 15) and select(1,Spring.GetFeatureHealth(featureID)) > 0 then		-- not sure if "select(1,Spring.GetFeatureHealth(featureID)) > 0" is needed because if featuredestroyed, featuredamaged wont be called probably
		local fx,fy,fz = Spring.GetFeaturePosition(featureID)
		if fx ~= nil then
			local fdef = featureList[featureDefID]
			if fdef and fdef.minx and fdef.maxx then
				local x,y,z = fx,fy,fz
				local _, mm, _, me, _ = Spring.GetFeatureResources(featureID)
				if me ~= nil and me > 0 then
					local numFx = math.floor(me/250)
					local posMultiplier = 0.5
					Spring.SpawnCEG("energyshards1", x, y, z)
					for i=1, numFx, 1 do
						x = fx + (random(fdef.minx, fdef.maxx)*posMultiplier)
						z = fz + (random(fdef.minz, fdef.maxz)*posMultiplier)
						y = fy + (random() * fdef.maxy*posMultiplier)
						Spring.SpawnCEG("energyshards"..(((i+1)%3)+1), x, y, z)
					end
				end
				if mm ~= nil and mm > 0 then
					local numFx = math.floor(mm/90)
					local posMultiplier = 0.5
					Spring.SpawnCEG("metalshards1", x, y, z)
					for i=1, numFx, 1 do
						x = fx + (random(fdef.minx, fdef.maxx)*posMultiplier)
						z = fz + (random(fdef.minz, fdef.maxz)*posMultiplier)
						y = fy + (random() * fdef.maxy*posMultiplier)
						Spring.SpawnCEG("metalshards"..(((i+1)%3)+1), x, y, z)
					end
				end
			end
		end
		damagedFeatures[featureID] = Spring.GetGameFrame()
	end
end

function gadget:FeatureDestroyed(featureID, allyteam)
	if damagedFeatures[featureID] ~= nil then
		damagedFeatures[featureID] = nil
	end
	local fx,fy,fz = Spring.GetFeaturePosition(featureID)
	if fy ~= nil and fy+15 > Spring.GetGroundHeight(fx, fz) then
		local fdef = featureList[Spring.GetFeatureDefID(featureID)]
		if fdef and fdef.minx then
			local x,y,z = fx,fy,fz
			local rm, mm, re, me, rl = Spring.GetFeatureResources(featureID)
			if me ~= nil and me > 0 then
				local numFx = math.max(math.floor(me/250), 15)
				local posMultiplier = 0.5
				Spring.SpawnCEG("energyshards1", x, y, z)
				for i=1, numFx, 1 do
					x = fx + (random(fdef.minx, fdef.maxx)*posMultiplier)
					z = fz + (random(fdef.minz, fdef.maxz)*posMultiplier)
					y = fy + (random(fdef.miny, fdef.maxy)*posMultiplier)
					Spring.SpawnCEG("energyshards"..(((i+1)%3)+1), x, y, z)
				end
			end
			if mm ~= nil and mm > 0 then
				local numFx = math.max(math.floor(mm/90), 15)
				local posMultiplier = 0.5
				Spring.SpawnCEG("metalshards1", x, y, z)
				for i=1, numFx, 1 do
					x = fx + (random(fdef.minx, fdef.maxx)*posMultiplier)
					z = fz + (random(fdef.minz, fdef.maxz)*posMultiplier)
					y = fy + (random(fdef.miny, fdef.maxy)*posMultiplier)
					Spring.SpawnCEG("metalshards"..(((i+1)%3)+1), x, y, z)
				end
			end
			if rm ~= nil and mm==0 and re==0 then
				Spring.SpawnCEG("sparklegreen", fx, fy, fz)
				Spring.PlaySoundFile("reclaimate", 1, fx, fy, fz, 'sfx')
			end
		end
	end
end
