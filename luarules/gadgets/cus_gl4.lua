function gadget:GetInfo()
	return {
		name	= "CUS GL4",
		desc	= "Implements CustomUnitShaders for GL4 rendering pipeline",
		version = "0.5",
		author	= "ivand, Beherith",
		date 	= "20220310",
		license = "Private while in testing mode",
		layer	= 0,
		enabled	= true,
	}
end

if gadgetHandler:IsSyncedCode() then
	return false
end

-- Beheriths notes

-- Bins / separate VAO and IBO :
	-- Flags (drawpass):
		-- forward opaque + reflections
		-- deferred opaque, all units
		-- shadows. Now all units need their vertex displacement for efficient shadows, so better to bind a separate shader for this
	-- Shaders / shaderconfig via bitoptions uniform:
		-- Features
			-- simplefeatures: metallic nonwrecks
			-- treepbr: Real Trees with proper tex2
			-- tree: Shitty Trees
			-- wrecks: BAR wrecks
		-- Units
			-- tanks : -- these are units actually
			-- barunits :
			-- chickens
			-- scavengers
			--

		-- Cloakedunits for alpha
		-- Underconstructionunits


	-- Textures:
		-- arm/cor
		-- 10x chickensets
		-- 5x featuresets
		-- scavengers?
	-- Objects (the VAO)
		-- 8x 8x 16x -> 8192 different VAOs? damn thats horrible
	-- Note that Units and Features cant share a VAO!

	-- Can we assume that all BAR units wont have transparency?
		-- if yes then we can say that forward and deferred can share!
	-- https://stackoverflow.com/questions/8923174/opengl-vao-best-practices
	-- Some shader optimization info: https://community.khronos.org/t/profiling-optimizing-a-fragment-shader-in-linux/105144/3



-- TODO:
	-- Under construction shader via uniform
		-- (READ THE ONE FROM HEALTHBARS!)
	-- DONE treadoffset unitUniform
	-- DONE: BITOPTIONS UNIFOOOOORM!
	-- normalmapping
	-- chickens
	-- tanktracks
	-- Reflection camera
	-- refraction camera
	-- texture LOD bias of -0.5, maybe adaptive for others
	-- still extremely perf heavy
		-- 1440p, Red Comet, fullscreen zoomed onto a corvp, SSAO on, Bloom On
			-- 110 FPS on corvp with oldcus
			-- 180 FPS without disablecus
		-- 1440p, Red Comet, fullscreen zoomed onto a corvp, SSAO off, Bloom off
			-- 130 fps oldcus
			-- 256 fps disablecus

	-- separate VAO and IBO for each 'bin' for less heavy updates
	-- Do alpha units also get drawn into deferred pass? Seems like no, because only flag == 1 is draw into that
	-- TODO: dynamically size IBOS instead of using the max of 8192!
	-- TODO: new engine callins needed:
		-- get the number of drawflaggable units (this is kind of gettable already from the API anyway)
		-- get the number of changed drawFlags
		-- if the number of changed drawflags > log(numdrawflags) then do a full rebuild instead of push-popping
		-- e.g if there are 100 units of a bin in view, then a change of ~ 8 units will trigger a full rebuild?
			-- cant know ahead of time how many per-bin changes this will trigger though

	-- TODO: write an engine callin that, instead of the full list of unitdrawflags, only returns the list of units whos drawflags have changed!
		-- reset this 'hashmap' when reading it
		-- also a problem is handling units that died, what 'drawflag' should they get?
			-- probably 0
	-- TODO: handle fast rebuilds of the IBO's when large-magnitude changes happen


	-- TODO: faster bitops maybe?
	-- DONE: we dont handle shaderOptions yet for batches, where we are to keep the same shader, but only change its relevant options uniform

	-- NOTE: It seems that we are generally, and heavily fragment shader limited in most synthetic tests with large numbers of units spreading into full view
		-- in this case, the perf of oldcus and gl4cus is actually similar, (similar FS), but vanilla still outperforms

	-- DONE: Too many varyings are passed from VS to FS.
		-- Specify some as flat, to avoid interpolation (e.g. teamcolor and selfillummod and maybe even fogfactor
		-- reduce total number of these varyings
		-- we can save a varying here and there, but mostly done

	-- Done: GetTextures() is not the best implementation at the moment

	-- NOTE: in general, a function call is about 10x faster than a table lookup....

	-- DONE: how to handle units under construction? They cant be their own completely separate shit, cause of textures...
		-- might still make sense to do so
		-- they are handled by completely ignoring them

	-- DONE: fully blank normal map for non-normal mapped units (or else risk having to write a shader for that bin, which wont even get used

	-- DONE: alpha cloaked unitses :/
		-- also handled by completely leaving them out

	-- Done: feature drawing bits too

	-- TODO: rewrite treewave

	-- DONE: feature override metalness/roughness via uniforms

	-- TODO: fix flashlights to be piece-unique

	-- DONE: AVOID DISCARD in FS AT ALL COST!
		-- 500 armcom fullview is 82 vs 108 fps with nodiscard!
		-- Even if discard is in a never-called dynamically uniform!
		-- only transparent features need discard

	-- TODO: investigate why/how refraction pass doesnt ever seem to get called
		-- kill the entire pass with fire (by ignoring its existence)

	-- TODO: reduce the amount of deferred buffers being used from 6 to 4

	-- TODO: check if LuaShader UniformLocations are cached

	-- DONE: add a wreck texture to chickens! It uses lavadistortion texture, its fine

	-- TODO: separate out damaged units for better perf, damage shading is not free! (as damage is not dynamically uniform across all shader invocations)
		-- very difficult, unsure if worth anything in the long run

	-- TODO: Also add alpha units to deferred pass somehow?

	-- TODO: engine side: optimize shadow camera as it massively overdraws

	-- TODO: reflection camera is also totally fucked up
		-- It seems that aircraft get removed from reflection pass if water depth is < -70
		-- hovers randomly do and dont get reflections based on water depth
	-- TODO: increase bumpwaterreflectcubetex size
	-- TODO: make lava disable drawing reflections!
	-- TODO: shared bins for deferred and forward and maybe even reflection?
		-- The sharing could be done on the uniformbin level, and this is quite elegant in general too, as tables are shared by reference....
		-- DONE: shared deferred and forward via ultimate cleverness!

	-- DONE: Specular highlights should also bloom, not just emissive!

	-- DONE: Cleaner Shutdown and reloadcusgl4 and disablecusgl4



	-- TODO: WE ARE DRAWING ALL IN THE UNITS PASS INSTEAD OF BOTH FEATURE AND UNITS PASS! (can that bite us in the ass?)


	-- TODO: Reimplement featureFade, as it can kill perf on heavily forested maps and potatos

	-- DONE: GetTexturesKey is probably slow too!

	-- TODO: Shadows are 1 drawframe late, maybe update lists in DrawGenesis instead of DrawWorldPreUnit
	-- TODO: we need to update things earlier, to get the shadow stuff in on time

	-- Done: GetTextures :
		-- should return array table instead of hash table
			-- fill in unused stuff with 'false' for contiguous array table
			-- index -1
			-- oddly enough, accessing array tables instead of hash tables is only 25% faster, so the overhead of -1 might not even result in any perf gains

		-- Should also get the normalmaps for each unit!
		-- PBR textures:
			-- uniform sampler2D brdfLUT;			//9
			-- uniform sampler2D envLUT;			//10
			-- uniform samplerCube reflectTex; 		// 7

			-- uniform sampler2D losMapTex;	//8 for features out of los maybe?

		-- We also need the skybox cubemap for PBR (samplerCube reflectTex)
		-- We also need wrecktex for damaged units!

	-- Create a default 'wrecktex' for features too?



-- DONE:
	-- unit uniforms
-- KNOWN BUGS:
	-- Unitdestroyed doesnt trigger removal?

--inputs

---------------------------- SHADERUNITUNIFORMS / BITSHADEROPTIONS ---------------------------------------------

-- We can use the SUniformsBuffer vec4 uni[instData.y].userDefined[5] to pass data persistent unit-info
-- floats 0-5 are already in use by HealthBars

local objectDefToBitShaderOptions = {} -- This is a table containing positive UnitIDs, negative featureDefIDs to bitShaderOptions mapping

local objectDefToUniformBin = {} -- maps unitDefID/featuredefID to a uniform bin
-- IMPORTANT: OBJECTID AND OBJECTDEFID ARE ALWAYS POS FOR UNITS, NEG FOR FEATURES!
-- this will still use the same shader, but we gotta switch uniforms in between for efficiency
-- a uniform bin contains
-- objectDefs are negative for features
-- objectIDs are negative for features too

local function GetUniformBinID(objectDefID)
	if objectDefID and objectDefToUniformBin[objectDefID] then
		return objectDefToUniformBin[objectDefID]
	else
		Spring.Echo("Failed to find a uniform bin id for objectDefID", objectDefID)
		--Spring.Debug.TraceFullEcho()
		return 'otherunit'
	end
end

local uniformBins = {}

do --save a ton of locals
	local OPTION_SHADOWMAPPING    = 1
	local OPTION_NORMALMAPPING    = 2
	local OPTION_NORMALMAP_FLIP   = 4
	local OPTION_VERTEX_AO        = 8
	local OPTION_FLASHLIGHTS      = 16
	local OPTION_THREADS_ARM      = 32
	local OPTION_THREADS_CORE     = 64
	local OPTION_HEALTH_TEXTURING = 128
	local OPTION_HEALTH_DISPLACE  = 256
	local OPTION_HEALTH_TEXCHICKS = 512
	local OPTION_MODELSFOG        = 1024
	local OPTION_TREEWIND         = 2048
	local OPTION_PBROVERRIDE      = 4096

	local defaultBitShaderOptions = OPTION_SHADOWMAPPING + OPTION_NORMALMAPPING  + OPTION_MODELSFOG

	uniformBins = {
		armunit = {
			bitOptions = defaultBitShaderOptions + OPTION_VERTEX_AO + OPTION_FLASHLIGHTS + OPTION_THREADS_ARM + OPTION_HEALTH_TEXTURING + OPTION_HEALTH_DISPLACE,
			baseVertexDisplacement = 0.0,
		},
		corunit = {
			bitOptions = defaultBitShaderOptions + OPTION_VERTEX_AO + OPTION_FLASHLIGHTS + OPTION_THREADS_CORE + OPTION_HEALTH_TEXTURING + OPTION_HEALTH_DISPLACE,
			baseVertexDisplacement = 0.0,
		},
		armscavenger = {
			bitOptions = defaultBitShaderOptions + OPTION_VERTEX_AO + OPTION_FLASHLIGHTS + OPTION_THREADS_ARM + OPTION_HEALTH_TEXTURING + OPTION_HEALTH_DISPLACE,
			baseVertexDisplacement = 0.4,
		},
		corscavenger = {
			bitOptions = defaultBitShaderOptions + OPTION_VERTEX_AO + OPTION_FLASHLIGHTS + OPTION_THREADS_CORE + OPTION_HEALTH_TEXTURING + OPTION_HEALTH_DISPLACE,
			baseVertexDisplacement = 0.4,
		},
		chicken = {
			bitOptions = defaultBitShaderOptions + OPTION_VERTEX_AO + OPTION_FLASHLIGHTS  + OPTION_HEALTH_DISPLACE + OPTION_HEALTH_TEXCHICKS + OPTION_TREEWIND,
			baseVertexDisplacement = 0.0,
		},
		otherunit = {
			bitOptions = defaultBitShaderOptions,
			baseVertexDisplacement = 0.0,
		},
		feature = {
			bitOptions = defaultBitShaderOptions + OPTION_PBROVERRIDE,
			baseVertexDisplacement = 0.0,
		},
		treepbr = {
			bitOptions = defaultBitShaderOptions + OPTION_TREEWIND + OPTION_PBROVERRIDE,
			baseVertexDisplacement = 0.0,
			hasAlphaShadows = 1.0,
		},
		tree = {
			bitOptions = defaultBitShaderOptions + OPTION_TREEWIND + OPTION_PBROVERRIDE,
			baseVertexDisplacement = 0.0,
			hasAlphaShadows = 1.0,
		},
		wreck = {
			bitOptions = defaultBitShaderOptions,
			baseVertexDisplacement = 0.0,
		},
	} -- maps uniformbins to a table of uniform names/values
end

local debugmode = false
local FASTRELOADMODE = true -- enable this is so that /luarules reload returns with cusgl4 default ON

local alphaMult = 0.35
local alphaThresholdOpaque = 0.5
local alphaThresholdAlpha  = 0.1
local overrideDrawFlags = {
	[0]  = true , --SO_OPAQUE_FLAG = 1, deferred hack
	[1]  = true , --SO_OPAQUE_FLAG = 1,
	[2]  = true , --SO_ALPHAF_FLAG = 2,
	[4]  = true , --SO_REFLEC_FLAG = 4,
	[8]  = true , --SO_REFRAC_FLAG = 8,
	[16] = true , --SO_SHADOW_FLAG = 16,
}


--implementation
local overrideDrawFlag = 0
for f, e in pairs(overrideDrawFlags) do
	overrideDrawFlag = overrideDrawFlag + f * (e and 1 or 0)
end
--      deferred    fw  fwrfl  fwrfr  op oprfl  oprfr  shadow
--         0         1    5     9     2    6     10     16
local drawBinKeys = {1, 1 + 4, 1 + 8, 2, 2 + 4, 2 + 8, 16} --deferred is handled ad-hoc
local overrideDrawFlagsCombined = {
	[0    ] = overrideDrawFlags[0],
	[1    ] = overrideDrawFlags[1],
	[1 + 4] = overrideDrawFlags[1] and overrideDrawFlags[4],
	[1 + 8] = overrideDrawFlags[1] and overrideDrawFlags[8],
	[2    ] = overrideDrawFlags[2],
	[2 + 4] = overrideDrawFlags[2] and overrideDrawFlags[4],
	[2 + 8] = overrideDrawFlags[2] and overrideDrawFlags[8],
	[16   ] = overrideDrawFlags[16],
}

local overriddenUnits = {} -- these remain positive, as they are traversed separately
local processedUnits = {}

local overriddenFeatures = {} -- this remains positive
local processedFeatures = {}

-- This is the main table of all the unit drawbins:
-- It is organized like so:
-- unitDrawBins[drawFlag][shaderID][textureKey] = {
	-- textures = {
	   -- 0 = %586:1 -- in this example, its just texture 1
	-- },
	-- objects = {
	   -- 31357 = true
	   -- 20174 = true
	   -- 29714 = true
	   -- 3024 = true
	   -- 24268 = true
	   -- 5584 = true
	   -- 5374 = true
	   -- 26687 = true
	-- },
	-- VAO = vao,
	-- IBO = ibo,
	-- objectsArray = {}, -- {index: objectID}
	-- objectsIndex = {}, -- {objectID : index} (this is needed for efficient removal of items, as RemoveFromSubmission takes an index as arg)
	-- numobjects = 0,  -- a 'pointer to the end'
-- }


local unitDrawBins = nil -- this also controls wether cusgl4 is on at all!

local objectIDtoDefID = {}

local processedCounter = 0 -- This is incremented on every update, and is used to identify which objects are no longer drawn

local shaders = {} -- double nested table of {drawflag : {"units":shaderID}}

local modelsVertexVBO = nil
local modelsIndexVBO = nil

local MAX_DRAWN_UNITS = 8192 -- this is per bin, but its not that bad, since its truly only a and uint4 of 32 bytes per element, clocking in at 256KB/uniformbin, but, seeing as we can have a good 50-100 uniform bins, this is far from ideal
local objectTypeAttribID = 6 -- this is the attribute index for instancedata in our VBO

local function Bit(p)
	return 2 ^ (p - 1)  -- 1-based indexing
end

-- Typical call:  if hasbit(x, bit(3)) then ...
local function HasBit(x, p)
	return x % (p + p) >= p
end

local math_bit_and = math.bit_and
local function HasAllBits(x, p)
	return math_bit_and(x, p) == p
end

local function SetBit(x, p)
	return HasBit(x, p) and x or x + p
end

local function ClearBit(x, p)
	return HasBit(x, p) and x - p or x
end



local featuresDefsWithAlpha = {}
-----------------

local function GetShader(drawPass, objectDefID)
	if objectDefID == nil then
		--Spring.Debug.TraceFullEcho(nil,nil,nil, "No shader found for", objectDefID)
		return false
	end
	if objectDefID >= 0 then
		-- gotta check if the unit is under construction or cloaked!

		return shaders[drawPass]['unit']
	else
		if featuresDefsWithAlpha[objectDefID] then
			return shaders[drawPass]['tree']
		else
			return shaders[drawPass]['feature']
		end
	end
end


local function GetShaderName(drawPass, objectDefID)
	if objectDefID == nil then
		--Spring.Debug.TraceFullEcho(nil,nil,nil, "No shader found for", objectDefID)
		return false
	end
	if objectDefID >= 0 then
		-- gotta check if the unit is under construction or cloaked!

		return 'unit'
	else
		if featuresDefsWithAlpha[objectDefID] then
			return 'tree'
		else
			return 'feature'
		end
	end
end


local function SetFixedStatePre(drawPass, shaderID)
	if HasBit(drawPass, 4) then
		gl.ClipDistance(2, true)
	elseif HasBit(drawPass, 8) then
		gl.ClipDistance(2, true)
	end
end

local function SetFixedStatePost(drawPass, shaderID)
	if HasBit(drawPass, 4) then
		gl.ClipDistance(2, false)
	elseif HasBit(drawPass, 8) then
		gl.ClipDistance(2, false)
	end
end


local function SetShaderUniforms(drawPass, shaderID, uniformBinID)
	--if true then return end
	gl.UniformInt(gl.GetUniformLocation(shaderID, "drawPass"), drawPass)
	if drawPass <= 2 then
		gl.Uniform(gl.GetUniformLocation(shaderID, "clipPlane2"), 0.0, 0.0, 0.0, 1.0)
	elseif drawPass == 16 then
		--gl.Uniform(gl.GetUniformLocation(shaderID, "alphaCtrl"), alphaThresholdOpaque, 1.0, 0.0, 0.0)
		-- set properly by default
	end

	for uniformLocationName, uniformValue in pairs(uniformBins[uniformBinID]) do
		--Spring.Echo("Setting uniform",uniformLocationName, uniformValue)
		if uniformLocationName == 'bitOptions' then
			gl.UniformInt(gl.GetUniformLocation(shaderID, uniformLocationName), uniformValue)
		else
			gl.Uniform(gl.GetUniformLocation(shaderID, uniformLocationName), uniformValue)
		end
	end

	if HasBit(drawPass, 4) then
		gl.Uniform(gl.GetUniformLocation(shaderID, "clipPlane2"), 0.0, 1.0, 0.0, 0.0)
	elseif HasBit(drawPass, 8) then
		gl.Uniform(gl.GetUniformLocation(shaderID, "clipPlane2"), 0.0, -1.0, 0.0, 0.0)
	end

end

------------------------- SHADERS                   ----------------------
------------------------- LOADING OLD CUS MATERIALS ----------------------
local luaShaderDir = "LuaUI/Widgets/Include/"
local LuaShader = VFS.Include(luaShaderDir.."LuaShader.lua")
local engineUniformBufferDefs = LuaShader.GetEngineUniformBufferDefs()

local MATERIALS_DIR = "modelmaterials_gl4/"

local defaultMaterialTemplate

--Spring.Debug.TableEcho(defaultMaterialTemplate["shadowDefinitions"])

local unitsNormalMapTemplate
local featuresNormalMapTemplate
local treesNormalMapTemplate

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function appendShaderDefinitionsToTemplate(template, alldefinitions)
	local copytemplate = deepcopy(template)
	for i, singleShaderDefs in ipairs({"shaderDefinitions", "deferredDefinitions", "shadowDefinitions", "reflectionDefinitions"}) do
		if alldefinitions[singleShaderDefs] then
			if copytemplate[singleShaderDefs] == nil then
				copytemplate[singleShaderDefs] = {}
			end
			for j, defline in ipairs(alldefinitions[singleShaderDefs]) do
				copytemplate[singleShaderDefs][ #copytemplate[singleShaderDefs] + 1 ] = defline
			end
		end
	end
	return copytemplate
end

local function initMaterials()
	defaultMaterialTemplate = VFS.Include("modelmaterials_gl4/templates/defaultMaterialTemplate.lua")

	unitsNormalMapTemplate = appendShaderDefinitionsToTemplate(defaultMaterialTemplate, {
		shaderDefinitions = {
			"#define ENABLE_OPTION_HEALTH_TEXTURING 1",
			"#define ENABLE_OPTION_THREADS 1",
			"#define ENABLE_OPTION_HEALTH_DISPLACE 1",
		},
		deferredDefinitions = {
			"#define ENABLE_OPTION_HEALTH_TEXTURING 1",
			"#define ENABLE_OPTION_THREADS 1",
			"#define ENABLE_OPTION_HEALTH_DISPLACE 1",
		},
		shadowDefinitions = {
		},
		reflectionDefinitions = {
		},
	})


	featuresNormalMapTemplate = appendShaderDefinitionsToTemplate(defaultMaterialTemplate, {
		shaderDefinitions = {
			"#define USE_LOSMAP",
		},
		deferredDefinitions = {
			"#define USE_LOSMAP",
		},
		shadowDefinitions = {
			--"#define HASALPHASHADOWS",
		},
		reflectionDefinitions = {
		},
	})

	treesNormalMapTemplate = appendShaderDefinitionsToTemplate(defaultMaterialTemplate, {
		shaderDefinitions = {
			"#define USE_LOSMAP",
			"#define HASALPHASHADOWS",
		},
		deferredDefinitions = {
			"#define USE_LOSMAP",
			"#define HASALPHASHADOWS",
		},
		shadowDefinitions = {
			"#define HASALPHASHADOWS",
		},
		reflectionDefinitions = {
		},
	})

end

local DEFAULT_VERSION = [[#version 430 core
	#extension GL_ARB_uniform_buffer_object : require
	#extension GL_ARB_shader_storage_buffer_object : require
	#extension GL_ARB_shading_language_420pack: require
	]]

local function dumpShaderCodeToFile(defs, src, filename) -- no IO in unsynced gadgets :/
	local vsfile = io.open('cus_' .. filename .. ".glsl","w+")
	vsfile:write(defs .. src)
	vsfile:close()
end


local function dumpShaderCodeToInfolog(defs, src, filename) -- no IO in unsynced gadgets :/
	Spring.Echo(filename)
	Spring.Echo(defs)
	Spring.Echo(src)
end

local function CompileLuaShader(shader, definitions, plugIns, addName)
	--Spring.Echo(" CompileLuaShader",shader, definitions, plugIns, addName)
	if definitions == nil or definitions == {} then
		Spring.Echo(addName, "nul definitions", definitions)
	end
	definitions = definitions or {}

	local hasVersion = false
	if definitions[1] then -- #version must be 1st statement or else AMD throws a fit
		hasVersion = string.find(definitions[1], "#version") == 1
	end

	if not hasVersion then
		table.insert(definitions, 1, DEFAULT_VERSION)
	end

	-- First the default default defs
	shader.definitions = table.concat(definitions, "\n") .. "\n"

	-- Then the engineUniformBufferDefs (see LuaShader.lua)
	shader.definitions = shader.definitions .. engineUniformBufferDefs

	--// insert small pieces of code named `plugins`
	--// this way we can use a basic shader and add some simple vertex animations etc.
	do
		local function InsertPlugin(str)
			return (plugIns and plugIns[str]) or ""
		end

		if shader.vertex then
			shader.vertex   = shader.vertex:gsub("%%%%([%a_]+)%%%%", InsertPlugin)
		end
		if shader.fragment then
			shader.fragment = shader.fragment:gsub("%%%%([%a_]+)%%%%", InsertPlugin)
		end
		if shader.geometry then
			shader.geometry = shader.geometry:gsub("%%%%([%a_]+)%%%%", InsertPlugin)
		end
	end

	local luaShader = LuaShader(shader, "CUS_" .. addName)
	local compilationResult = luaShader:Initialize()
	if compilationResult ~= true then
		Spring.Echo("Custom Unit Shaders. " .. addName .. " shader compilation failed")
		--dumpShaderCodeToFile(shader.definitions, shader.vertex, "vs" .. addName)
		--dumpShaderCodeToFile(shader.definitions, shader.fragment, "fs" .. addName)
		dumpShaderCodeToInfolog(shader.definitions, shader.vertex, "vs" .. addName)
		dumpShaderCodeToInfolog(shader.definitions, shader.fragment, "fs" .. addName)
		gadgetHandler:RemoveGadget()

		return nil
	end

	return (compilationResult and luaShader) or nil
end

local function compileMaterialShader(template, name)
	--Spring.Echo("Compiling", template, name)
	local forwardShader = CompileLuaShader(template.shader, template.shaderDefinitions, template.shaderPlugins, name .."_forward" )
	local shadowShader = CompileLuaShader(template.shadow, template.shadowDefinitions, template.shaderPlugins, name .."_shadow" )
	local deferredShader = CompileLuaShader(template.deferred, template.deferredDefinitions, template.shaderPlugins, name .."_deferred" )
	local reflectionShader = CompileLuaShader(template.reflection, template.reflectionDefinitions, template.shaderPlugins, name .."_reflection" )



	for k = 1, #drawBinKeys do
		local flag = drawBinKeys[k]
		shaders[flag][name] = forwardShader
	end
	shaders[0 ][name] = deferredShader
	shaders[5 ][name] = reflectionShader
	shaders[16][name] = shadowShader
end


local gettexturescalls = 0

-- Order of textures in shader:
	-- uniform sampler2D texture1;			//0
	-- uniform sampler2D texture2;			//1
	-- uniform sampler2D normalTex;		//2

	-- uniform sampler2D texture1w;		//3
	-- uniform sampler2D texture2w;		//4
	-- uniform sampler2D normalTexw;		//5

	-- uniform sampler2DShadow shadowTex;	//6
	-- uniform samplerCube reflectTex;		//7

	-- uniform sampler2D losMapTex;	//8

	-- uniform sampler2D brdfLUT;			//9
	-- uniform sampler2D envLUT;			//10

local textureKeytoSet = {} -- table of {TextureKey : {textureTable}}

local unitDefShaderBin = {} -- A table of {"armpw".id:"unit", "armpw_scav".id:"scavenger", "chickenx1".id:"chicken", "randomjunk":"vanilla"}

local wreckTextureNames = {} -- A table of regular texture names to wreck texture names {"Arm_color.dds": "Arm_color_wreck.dds"}
local blankNormalMap = "unittextures/blank_normal.dds"

local fastObjectDefIDtoTextureKey = {} -- table of  {unitDefID : TextureKey, -featureDefID : TextureKey }
local fastTextureKeyToSet = {}
local fastTextureKeyCache = {} -- a table of concatenated texture names to increasing integers
local numfastTextureKeyCache = 0

--- Hashes a table of textures to a unique integer
-- @param textures a table of {bindposition:texture}
-- @return a unique hash for binning
local function GenFastTextureKey(objectDefID, objectDef, normaltexpath, texturetable) -- return integer
	if objectDef.model == nil or objectDef.model.textures == nil then
		return 0
	end

	local tex1 = string.lower(objectDef.model.textures.tex1 or "")
	local tex2 = string.lower(objectDef.model.textures.tex2 or "")
	normaltexpath = string.lower(normaltexpath or "")
	local strkey = tex1 .. tex2 .. normaltexpath
	for i=3, 20 do -- from 3 since 0-1-2 are tex12 and normals, and this guarantees order of the table
		if texturetable[i] then
			strkey = strkey .. texturetable[i]
		end
	end

	if fastTextureKeyCache[strkey] then  -- already exists
		fastObjectDefIDtoTextureKey[objectDefID] = fastTextureKeyCache[strkey]
	else
		numfastTextureKeyCache = numfastTextureKeyCache + 1
		fastTextureKeyCache[strkey] = numfastTextureKeyCache
		fastObjectDefIDtoTextureKey[objectDefID] = numfastTextureKeyCache
		--Spring.Echo("GenFastTextureKey", strkey, fastTextureKeyCache[strkey])
	end
	return fastTextureKeyCache[strkey]
end

local wreckAtlases = {
	["arm"] = {
		"unittextures/Arm_wreck_color.dds",
		"unittextures/Arm_wreck_other.dds",
		"unittextures/Arm_wreck_color_normal.dds",
	},
	["cor"] = {
		"unittextures/cor_color_wreck.dds",
		"unittextures/cor_other_wreck.dds",
		"unittextures/cor_color_wreck_normal.dds",
	},
	["chicken"] = {
		"luaui/images/lavadistortion.png",
	}
}

local brdfLUT = "modelmaterials_gl4/brdf_0.png"
local envLUT = "modelmaterials_gl4/envlut_0.png"

local existingfilecache = {} -- this speeds up the VFS calls

local function GetNormal(unitDef, featureDef)
	local normalMap = blankNormalMap

	if unitDef and unitDef.customParams and unitDef.customParams.normaltex and
		(existingfilecache[unitDef.customParams.normaltex] or VFS.FileExists(unitDef.customParams.normaltex)) then

		existingfilecache[unitDef.customParams.normaltex] = true
		return unitDef.customParams.normaltex
	end

	if featureDef then
		local tex1 = featureDef.model.textures.tex1 or "DOESNTEXIST.PNG"
		local tex2 = featureDef.model.textures.tex2 or "DOESNTEXIST.PNG"

		if featureDef.customParams and featureDef.customParams.normaltex and
			(existingfilecache[featureDef.customParams.normaltex] or VFS.FileExists(featureDef.customParams.normaltex)) then

			existingfilecache[featureDef.customParams.normaltex] = true
			return featureDef.customParams.normaltex
		end

		local unittexttures = "unittextures/"
		if  (existingfilecache[unittexttures .. tex1] or VFS.FileExists(unittexttures .. tex1)) and
			(existingfilecache[unittexttures .. tex2] or VFS.FileExists(unittexttures .. tex2)) then

			existingfilecache[unittexttures .. tex1] = true
			existingfilecache[unittexttures .. tex2] = true
			normalMap = unittexttures .. tex1:gsub("%.","_normals.")
			-- Spring.Echo(normalMap)
			if (existingfilecache[normalMap] or VFS.FileExists(normalMap)) then
				existingfilecache[normalMap] = true
				return normalMap
			end
			normalMap = unittexttures .. tex1:gsub("%.","_normal.")
			-- Spring.Echo(normalMap)
			if (existingfilecache[normalMap] or VFS.FileExists(normalMap)) then
				existingfilecache[normalMap] = true
				return normalMap
			end
		end
	end

	return blankNormalMap
end

local knowntrees = VFS.Include("modelmaterials_gl4/known_feature_trees.lua")
local function initBinsAndTextures()
	--if true then return end
	Spring.Echo("[CUS GL4] Init Unit bins")
	for unitDefID, unitDef in pairs(UnitDefs) do
		if unitDef.model then
			unitDefShaderBin[unitDefID] = 'unit'
			objectDefToUniformBin[unitDefID] = "otherunit"
			if unitDef.name:sub(1,3) == 'arm' then
				objectDefToUniformBin[unitDefID] = 'armunit'
			elseif 	unitDef.name:sub(1,3) == 'cor' then
				objectDefToUniformBin[unitDefID] = 'corunit'
			end
			local normalTex = GetNormal(unitDef, nil)
			local textureTable = {
				--%-102:0 = featureDef 102 s3o tex1
				[0] = string.format("%%%s:%i", unitDefID, 0),
				[1] = string.format("%%%s:%i", unitDefID, 1),
				[2] = normalTex,
				[3] = normalTex,
				[4] = normalTex,
				[5] = normalTex,
				[6] = "$shadow",
				[7] = "$reflection",
				[8] = "$info:los",
				[9] = brdfLUT,
				--[10] = envLUT,
			}
			-- is this a proper unitdef with a real

			local lowercasetex1 = string.lower(unitDef.model.textures.tex1 or "")
			local lowercasetex2 = string.lower(unitDef.model.textures.tex2 or "")
			local lowercasenormaltex = string.lower(normalTex or "")

			local wreckTex1 = (lowercasetex1:find("arm_color", nil, true) and "unittextures/Arm_wreck_color.dds") or
								(lowercasetex1:find("cor_color", nil, true) and "unittextures/Cor_color_wreck.dds")  or false
			local wreckTex2 = (lowercasetex2:find("arm_other", nil, true) and "unittextures/Arm_wreck_other.dds") or
								(lowercasetex2:find("cor_other", nil, true) and "unittextures/Cor_other_wreck.dds")  or false
			local wreckNormalTex = (lowercasenormaltex:find("arm_normal") and "unittextures/Arm_wreck_color_normal.dds") or
					(lowercasenormaltex:find("cor_normal") and "unittextures/Cor_color_wreck_normal.dds") or false

			if unitDef.name:find("_scav", nil, true) then -- it better be a scavenger unit, or ill kill you
				textureTable[3] = wreckTex1
				textureTable[4] = wreckTex2
				textureTable[5] = wreckNormalTex
				if unitDef.name:sub(1,3) == 'arm' then
					objectDefToUniformBin[unitDefID] = 'armscavenger'
				elseif 	unitDef.name:sub(1,3) == 'cor' then
					objectDefToUniformBin[unitDefID] = 'corscavenger'
				end
			elseif unitDef.name:find("chicken", nil, true) then
				textureTable[5] = wreckAtlases['chicken'][1]
				objectDefToUniformBin[unitDefID] = 'chicken'
				--Spring.Echo("Chickenwreck", textureTable[5])
			elseif wreckTex1 and wreckTex2 then -- just a true unit:
				textureTable[3] = wreckTex1
				textureTable[4] = wreckTex2
				textureTable[5] = wreckNormalTex
			end

			local texKeyFast = GenFastTextureKey(unitDefID, unitDef, normalTex, textureTable)
			if textureKeytoSet[texKeyFast] == nil then
				textureKeytoSet[texKeyFast] = textureTable
			end


		end
	end

	Spring.Echo("[CUS GL4] Init Feature bins")
	for featureDefID, featureDef in pairs(FeatureDefs) do
		if featureDef.model then -- this is kind of a hack to work around specific modelless features metalspots found on Otago 1.4
			local normalTex = GetNormal(nil, featureDef)
			local textureTable = {
				[0] = string.format("%%-%s:%i", featureDefID, 0),
				[1] = string.format("%%-%s:%i", featureDefID, 1),
				[2] = normalTex,
				[3] = false,
				[4] = false,
				[5] = false,
				[6] = "$shadow",
				[7] = "$reflection",
				[8] = "$info",
				[9] = brdfLUT,
				--[10] = envLUT,
			}

			objectDefToUniformBin[-1 * featureDefID] = 'feature'


			if (featureDef.customParams and featureDef.customParams.treeshader == 'yes')
				or knowntrees[featureDef.name] then
				objectDefToUniformBin[-1 * featureDefID] = 'tree'
				featuresDefsWithAlpha[-1 * featureDefID] = "yes"
			elseif featureDef.name:find("_dead", nil, true) or featureDef.name:find("_heap", nil, true) then
				objectDefToUniformBin[-1 * featureDefID] = 'wreck'
			end
			--Spring.Echo("Assigned normal map to", featureDef.name, normalTex)

			local texKeyFast = GenFastTextureKey(-1 * featureDefID, featureDef, normalTex, textureTable)
			if textureKeytoSet[texKeyFast] == nil then
				textureKeytoSet[texKeyFast] = textureTable
			end
		end
	end
end

local function GetObjectDefName(objectID)
	if objectID == nil then
		return "Failed to GetObjectDefName(objectID): " .. tostring(objectID)
	elseif objectID >= 0 then
		if Spring.ValidUnitID(objectID) then
			local udid = Spring.GetUnitDefID(objectID)
			return UnitDefs[udid].name
		else
			return "Invalid UnitID:"..tostring(objectID)
		end
	else
		if Spring.ValidFeatureID(-1 * objectID) then
			local fdid = Spring.GetFeatureDefID(-1 * objectID)
			return FeatureDefs[fdid].name
		else
			return 'Invalid featuredefid:' .. tostring(objectID)
		end
	end
end

local badassigns = {} -- a table of unitDefs so that we only warn once

local asssigncalls = 0
--- Assigns a unit to a material bin
-- This function gets called from AddUnit every time a unit enters drawrange (or gets its flags changed)
-- @param objectID The unitID of the unit, or negative for featureID's
-- @param objectDefID Which unitdef it belongs to, negative for featureDefIDs
-- @param flag which drawflags it has
-- @param shader which shader should be assigned to it
-- @param textures A table of {bindPosition:texturename} for this unit
-- @param texKey A unique key hashed from the textures names, bindpositions
local function AsssignObjectToBin(objectID, objectDefID, flag, shader, textures, texKey, uniformBinID)
	asssigncalls = (asssigncalls + 1 ) % (2^20)
	shader = shader or GetShaderName(flag, objectDefID)
	texKey = texKey or fastObjectDefIDtoTextureKey[objectDefID]

	if objectDefID == nil then
		Spring.Echo("AsssignObjectToBin",objectID, objectDefID, flag, shader, textures, texKey, uniformBinID)
	end
	uniformBinID = uniformBinID or GetUniformBinID(objectDefID, "AsssignObjectToBin")
	--Spring.Echo("AsssignObjectToBin", objectID, objectDefID, flag, shader, textures, texKey, uniformBinID)
	--	Spring.Debug.TraceFullEcho()
	if (texKey == nil or uniformBinID == nil) then
		if badassigns[objectID] == nil then
			Spring.Echo("[CUS GL4]Failure to assign to ", objectID, objectDefID, flag, shader, textures, texKey, uniformBinID)
			Spring.Echo("REPORT THIS TO BEHERITH: bad object:", GetObjectDefName(objectID))
			badassigns[objectID] = true
		end
		return
	end

	local unitDrawBinsFlag = unitDrawBins[flag]
	if unitDrawBinsFlag[shader] == nil then
		unitDrawBinsFlag[shader] = {}
	end
	local unitDrawBinsFlagShader = unitDrawBinsFlag[shader]

	if unitDrawBinsFlagShader[uniformBinID] == nil then
		unitDrawBinsFlagShader[uniformBinID] = {}
	end

	local unitDrawBinsFlagShaderUniforms = unitDrawBinsFlagShader[uniformBinID]

	if unitDrawBinsFlagShaderUniforms[texKey] == nil then
		local mybinVAO = gl.GetVAO()
		local mybinIBO = gl.GetVBO(GL.ARRAY_BUFFER, true)

		if (mybinIBO == nil) or (mybinVAO == nil) then
			Spring.Echo("Failed to allocate IBO or VAO for CUS GL4", mybinIBO, mybinVAO)
			--Spring.Debug.TraceFullEcho()
			gadgetHandler:RemoveGadget()
			return
		end

		mybinIBO:Define(MAX_DRAWN_UNITS, {
			{id = 6, name = "instData", type = GL.UNSIGNED_INT, size = 4},
		})

		mybinVAO:AttachVertexBuffer(modelsVertexVBO)
		mybinVAO:AttachIndexBuffer(modelsIndexVBO)
		mybinVAO:AttachInstanceBuffer(mybinIBO)

		unitDrawBinsFlagShaderUniforms[texKey] = { -- so texkey was somehow nil...
			textures = textureKeytoSet[texKey], -- hashmap of textures for this unit
			IBO = mybinIBO, -- my own IBO, for incrementing
			VAO = mybinVAO, -- my own VBO, for incremental updating
			objectsArray = {}, -- {index: objectID}
			objectsIndex = {}, -- {objectID : index} (this is needed for efficient removal of items, as RemoveFromSubmission takes an index as arg)
			numobjects = 0,  -- a 'pointer to the end'
		}

		-- this uniform bin is totally new, so we are going to make the deferred version have a shared copy of this!
		-- This means that deferred and forward will share their uniformbins
		-- they could share up to the shader level, but I dont know why im not using that
		if flag == 1 then
			deferredrawBin = unitDrawBins[0]
			if deferredrawBin[shader] == nil then  deferredrawBin[shader] = {} end
			if deferredrawBin[shader][uniformBinID] == nil then deferredrawBin[shader][uniformBinID] = unitDrawBinsFlagShader[uniformBinID] end
		end
	end

	local unitDrawBinsFlagShaderUniformsTexKey = unitDrawBinsFlagShaderUniforms[texKey]

	if unitDrawBinsFlagShaderUniformsTexKey.objectsIndex[objectID] then
		Spring.Echo("Trying to add a unit to a bin that is already in it!")
	else
		if debugmode then Spring.Echo("AsssignObjectToBin success:",objectID, objectDefID, flag, shader, textures, texKey, uniformBinID	) end
	end

	local numobjects = unitDrawBinsFlagShaderUniformsTexKey.numobjects

	if objectID >= 0 then
		unitDrawBinsFlagShaderUniformsTexKey.IBO:InstanceDataFromUnitIDs(objectID, objectTypeAttribID, numobjects)
		unitDrawBinsFlagShaderUniformsTexKey.VAO:AddUnitsToSubmission   (objectID)
	else
		unitDrawBinsFlagShaderUniformsTexKey.IBO:InstanceDataFromFeatureIDs(-objectID, objectTypeAttribID, numobjects)
		unitDrawBinsFlagShaderUniformsTexKey.VAO:AddFeaturesToSubmission   (-objectID)
	end

	numobjects = numobjects + 1
	unitDrawBinsFlagShaderUniformsTexKey.numobjects = numobjects
	unitDrawBinsFlagShaderUniformsTexKey.objectsArray[numobjects] = objectID
	unitDrawBinsFlagShaderUniformsTexKey.objectsIndex[objectID    ] = numobjects

	if debugmode and flag == 0 then
		Spring.Echo("AsssignObjectToBin", objectID, objectDefID, texKey,uniformBinID, shader,flag, numobjects)
		local objids = "objectsArray "
		for k,v in pairs(unitDrawBinsFlagShaderUniformsTexKey.objectsArray) do
			objids = objids .. tostring(k) .. ":" ..tostring(v) .. " "
		end
		Spring.Echo(objids)
	end
end


local function AddObject(objectID, drawFlag)
	if (drawFlag >= 128) then --icon
		return
	end
	if (drawFlag >=  32) then --far tex
		return
	end

	local objectDefID
	if objectID >= 0 then
		objectDefID = Spring.GetUnitDefID(objectID)
		objectIDtoDefID[objectID] = objectDefID
	else
		objectDefID = -1 *  Spring.GetFeatureDefID(-1 * objectID)
		objectIDtoDefID[objectID] = objectDefID

	end



	--if debugmode then Spring.Debug.TraceEcho("AddObject",objectID, drawFlag) end
	--Spring.Echo(unitID, UnitDefs[unitDefID].name)

	for k = 1, #drawBinKeys do
		local flag = drawBinKeys[k]

		if HasAllBits(drawFlag, flag) then
			if overrideDrawFlagsCombined[flag] then
				AsssignObjectToBin(objectID, objectDefID, flag)
				--if flag == 1 then
				--	AsssignObjectToBin(objectID, objectDefID, 0) --deferred hack - what the fuck is this, it probably runs every time the 'forward opaque' pass is added
				--
				--end
			end
		end
	end
	-- Spring.Echo("AddObject",objectID, objectDefID, drawFlag)
	if objectID >= 0 then
		Spring.SetUnitEngineDrawMask(objectID, 255 - overrideDrawFlag) -- ~overrideDrawFlag & 255
		overriddenUnits[objectID] = drawFlag
	else
		if Spring.ValidFeatureID(-1 * objectID) == false then Spring.Echo("Invalid feature for drawmask", objectID, objectDefID) end
		Spring.SetFeatureEngineDrawMask(-1 * objectID, 255 - overrideDrawFlag) -- ~overrideDrawFlag & 255
		Spring.SetFeatureNoDraw(-1 * objectID, false) -- ~overrideDrawFlag & 255
		Spring.SetFeatureFade(-1 * objectID, true) -- ~overrideDrawFlag & 255
		overriddenFeatures[-1 *objectID] = drawFlag
	end
	--overriddenUnits[unitID] = overrideDrawFlag
end

local function RemoveObjectFromBin(objectID, objectDefID, texKey, shader, flag, uniformBinID)
	shader = shader or GetShaderName(flag, objectDefID)
	texKey = texKey or fastObjectDefIDtoTextureKey[objectDefID]
	if debugmode then Spring.Echo("RemoveObjectFromBin", objectID, objectDefID, texKey,shader,flag,objectIndex)  end

	if unitDrawBins[flag][shader] then
		if unitDrawBins[flag][shader][uniformBinID] then
			if unitDrawBins[flag][shader][uniformBinID][texKey] then

				-- do the pop magic
				local unitDrawBinsFlagShaderTexKey = unitDrawBins[flag][shader][uniformBinID][texKey]
				local objectIndex = unitDrawBinsFlagShaderTexKey.objectsIndex[objectID]

				--if flag == 0 then Spring.Echo("RemoveObjectFromBin", objectID, objectDefID, texKey,shader,flag,objectIndex) end
				if debugmode then Spring.Echo("RemoveObjectFromBin really", objectID, objectDefID, texKey,shader,flag,objectIndex) end
				if objectIndex == nil then
					-- Spring.Echo("Remove failed")
					return
					end
				local numobjects = unitDrawBinsFlagShaderTexKey.numobjects

				unitDrawBinsFlagShaderTexKey.VAO:RemoveFromSubmission(objectIndex - 1) -- do we become out of order?
				if objectIndex == numobjects then -- last element
					unitDrawBinsFlagShaderTexKey.objectsIndex[objectID] = nil
					unitDrawBinsFlagShaderTexKey.objectsArray[numobjects] = nil
					unitDrawBinsFlagShaderTexKey.numobjects = numobjects -1
				else
					local objectIDatEnd = unitDrawBinsFlagShaderTexKey.objectsArray[numobjects]
					if debugmode and flag == 0 then Spring.Echo("Moving", objectIDatEnd, "from", numobjects, " to", objectIndex, "while removing", objectID) end
					unitDrawBinsFlagShaderTexKey.objectsIndex[objectID     ] = nil -- pop back
					unitDrawBinsFlagShaderTexKey.objectsIndex[objectIDatEnd] = objectIndex -- bring the last objectID to to this one
					if objectID >= 0 then -- unit
						if Spring.ValidUnitID(objectIDatEnd) == true and Spring.GetUnitIsDead(objectIDatEnd) ~= true then
							unitDrawBinsFlagShaderTexKey.IBO:InstanceDataFromUnitIDs(objectIDatEnd, objectTypeAttribID, objectIndex - 1)
						else
							if debugmode then Spring.Echo("Tried to remove invalid unitID", objectID) end
						end
					else -- feauture
						if Spring.ValidFeatureID(-objectIDatEnd) == true then
							unitDrawBinsFlagShaderTexKey.IBO:InstanceDataFromFeatureIDs(-1 * objectIDatEnd, objectTypeAttribID, objectIndex - 1)
						else
							if debugmode then Spring.Echo("Tried to remove invalid featureID", objectID) end
						end
					end
					unitDrawBinsFlagShaderTexKey.objectsArray[numobjects ] = nil -- pop back
					unitDrawBinsFlagShaderTexKey.objectsArray[objectIndex] = objectIDatEnd -- Bring the last objectID here
					unitDrawBinsFlagShaderTexKey.numobjects = numobjects -1
				end
			else
				--Spring.Echo("Failed to find texKey for", objectID, objectDefID, texKey, shader, flag, uniformBinID)
				--	Spring.Debug.TableEcho(textures)
			end
		else
			if debugmode then Spring.Echo("Failed to find uniformBinID for", objectID, objectDefID, texKey, shader, flag, uniformBinID) end
		end
	else
		if debugmode then
			local defName ='niiiil'
			if objectDefID then
				if objectDefID >= 0 then
					defName =  UnitDefs[objectDefID].name
				else
					defName =  FeatureDefs[-1 * objectDefID].name
				end
			end
			Spring.Echo("Failed to find shader for", objectID, objectDefID, texKey, shader, flag, uniformBinID, defName)
		end
		--Spring.Debug.TraceFullEcho(30,30,30)
	end

end
local function UpdateObject(objectID, drawFlag)
	if (drawFlag >= 128) then --icon
		return
	end
	if (drawFlag >=  32) then --far tex
		return
	end

	local objectDefID = objectIDtoDefID[objectID]

	--if debugmode then Spring.Debug.TraceEcho("UpdateObject", objectID, drawFlag, objectDefID) end
	for k = 1, #drawBinKeys do
		local flag = drawBinKeys[k]
		local hasFlagOld
		if objectID >= 0 then
			hasFlagOld = HasAllBits(overriddenUnits[objectID], flag)
		else
			hasFlagOld = HasAllBits(overriddenFeatures[-1 * objectID], flag)
		end
		local hasFlagNew = HasAllBits(               drawFlag, flag)

		if hasFlagOld ~= hasFlagNew and overrideDrawFlagsCombined[flag] then
			local shader = GetShaderName(flag, objectDefID)
			local texKey  = fastObjectDefIDtoTextureKey[objectDefID]
			local uniformBinID = GetUniformBinID(objectDefID,'UpdateObject')

			if hasFlagOld then --had this flag, but no longer have
				RemoveObjectFromBin(objectID, objectDefID, texKey, shader, flag, uniformBinID)
				--if flag == 1 then
				--	RemoveObjectFromBin(objectID, objectDefID, texKey, nil, 0, uniformBinID)
				--end
			end
			if hasFlagNew then -- didn't have this flag, but now has
				AsssignObjectToBin(objectID, objectDefID, flag, shader, nil, texKey, uniformBinID)
				--if flag == 1 then
				--	AsssignObjectToBin(objectID, objectDefID, 0, nil, nil, texKey, uniformBinID) --deferred
				--end
			end
		end
	end
	if objectID >= 0 then
		overriddenUnits[objectID] = drawFlag
	else
		overriddenFeatures[-1 * objectID] = drawFlag
	end
end

local function RemoveObject(objectID) -- we get pos/neg objectID here
	--remove the object from every bin and table
	--Spring.Echo("RemoveObject", objectID)
	local objectDefID = objectIDtoDefID[objectID]
	--if objectID == nil then Spring.Debug.TraceFullEcho() end

	--if debugmode then Spring.Debug.TraceEcho("RemoveObject", objectID) end

	for k = 1, #drawBinKeys do
		local flag = drawBinKeys[k]
		if debugmode then Spring.Echo("RemoveObject Flags", objectID, flag, overrideDrawFlagsCombined[flag] ) end
		if overrideDrawFlagsCombined[flag] then
			local shader = GetShaderName(flag, objectDefID)
			local texKey  = fastObjectDefIDtoTextureKey[objectDefID]
			local uniformBinID = GetUniformBinID(objectDefID,'RemoveObject')
			RemoveObjectFromBin(objectID, objectDefID, texKey, shader, flag, uniformBinID)
			--if flag == 1 then
			--	RemoveObjectFromBin(objectID, objectDefID, texKey, nil, 0, uniformBinID)
			--end
		end
	end
	objectIDtoDefID[objectID] = nil
	if objectID >= 0 then
		overriddenUnits[objectID] = nil
		processedUnits[objectID] = nil
		Spring.SetUnitEngineDrawMask(objectID, 255)
	else
		overriddenFeatures[-1 * objectID] = nil
		processedFeatures[-1 * objectID] = nil
		Spring.SetFeatureEngineDrawMask(-1 * objectID, 255)
	end

	--Spring.Debug.TableEcho(unitDrawBins)
end

local spGetUnitHealth = Spring.GetUnitHealth
local spGetUnitIsCloaked = Spring.GetUnitIsCloaked

local function ProcessUnits(units, drawFlags)
	processedCounter = (processedCounter + 1) % (2 ^ 16)

	for i = 1, #units do
		local unitID = units[i]
		local drawFlag = drawFlags[i]
		local buildpercent = select(5, spGetUnitHealth(unitID))
		if (buildpercent and buildpercent < 1) or spGetUnitIsCloaked(unitID) then
			--under construction
			--using processedUnits here actually good, as it will dynamically handle unitfinished and cloak on-off
		else

			--Spring.Echo("ProcessUnit", unitID, drawFlag)
			if overriddenUnits[unitID] == nil then --object was not seen
				AddObject(unitID, drawFlag)
			elseif overriddenUnits[unitID] ~= drawFlag then --flags have changed
				UpdateObject(unitID, drawFlag)
			end
			processedUnits[unitID] = processedCounter
		end
	end

	for unitID, _ in pairs(overriddenUnits) do
		if processedUnits[unitID] ~= processedCounter then --object was not updated thus was removed
			RemoveObject(unitID)
		end
	end
end

local function ProcessFeatures(features, drawFlags)
	processedCounter = (processedCounter + 1) % (2 ^ 16)

	for i = 1, #features do
		local featureID = features[i]
		local drawFlag = drawFlags[i]

		-- TODO: this is the nastiest hack in the world, because zero is positive, and we can get features that have a featureID of 0.
		-- we will solve this by simply not CUS-ing a feature that has an ID of 0
		-- I leave this wonderful bug to any future soul who has to maintain this
		if featureID > 0 then
			--Spring.Echo("ProcessFeature", featureID	, drawFlag)
			if overriddenFeatures[featureID] == nil then --object was not seen
				AddObject(-1 * featureID, drawFlag)
			elseif overriddenFeatures[featureID] ~= drawFlag then --flags have changed
				UpdateObject(-1 * featureID, drawFlag)
			end
			processedFeatures[featureID] = processedCounter
		end
		processedFeatures[featureID] = processedCounter
	end

	for featureID, _ in pairs(overriddenFeatures) do
		if processedFeatures[featureID] ~= processedCounter then --object was not updated thus was removed
			RemoveObject(-1 * featureID)
		end
	end
end

local shaderactivations = 0

local shaderOrder = {'tree','feature','unit',} -- this forces ordering, no real reason to do so, just for testing

local function ExecuteDrawPass(drawPass)
	--defersubmissionupdate = (defersubmissionupdate + 1) % 10;
	local batches = 0
	local units = 0
	gl.Culling(GL.BACK)
	--for shaderName, data in pairs(unitDrawBins[drawPass]) do
	for _, shaderName in ipairs(shaderOrder) do
		if unitDrawBins[drawPass][shaderName] then
			local data = unitDrawBins[drawPass][shaderName]
			local unitscountforthisshader = 0
			--Spring.Echo("uniformBinID", uniformBinID)

			for _, uniformBin in pairs(data) do
				for _, texAndObj in pairs(uniformBin) do
					unitscountforthisshader = unitscountforthisshader + texAndObj.numobjects
				end
			end

			local shaderTable = shaders[drawPass][shaderName]

			if unitscountforthisshader > 0 then
				gl.UseShader(shaderTable.shaderObj)

				for uniformBinID, uniformBin in pairs(data) do

					--Spring.Echo("Shadername", shaderId.shaderName,"uniformBinID", uniformBinID)
					--local uniforms = uniformBins[uniformBinID]

					-- TODO: only activate shader if we actually have units in its bins?
					SetShaderUniforms(drawPass, shaderTable.shaderObj, uniformBinID)

					for _, texAndObj in pairs(uniformBin) do
						if texAndObj.numobjects > 0  then
							batches = batches + 1
							units = units + texAndObj.numobjects
							local mybinVAO = texAndObj.VAO
							for bindPosition, tex in pairs(texAndObj.textures) do
								if Spring.GetGameFrame() % 60 == 0 then
									--Spring.Echo(bindPosition, tex)
								end
								gl.Texture(bindPosition, tex)
							end

							SetFixedStatePre(drawPass, shaderTable)
							shaderactivations = shaderactivations + 1

							mybinVAO:Submit()

							SetFixedStatePost(drawPass, shaderTable)

							for bindPosition, tex in pairs(texAndObj.textures) do
								gl.Texture(bindPosition, false)
							end
						end
					end
				end

				gl.UseShader(0)
			end
		end
	end
	return batches, units
end

local function initGL4()
	shaders[0 ] = {}
	for k = 1, #drawBinKeys do
		local flag = drawBinKeys[k]
		shaders[flag] = {}
	end

	unitDrawBins = {
		[0    ] = {},	-- deferred opaque
		[1    ] = {},	-- forward  opaque
		[1 + 4] = {},	-- forward  opaque + reflection
		[1 + 8] = {},	-- forward  opaque + refraction
		[2    ] = {},	-- alpha
		[2 + 4] = {},	-- alpha + reflection
		[2 + 8] = {},	-- alpha + refraction
		[16   ] = {},	-- shadow
	}
	Spring.Echo("[CUS GL4] Initializing materials")
	initMaterials()

	Spring.Echo("[CUS GL4] Compiling Shaders")
	-- Initialize shaders types like so::
	-- shaders[0]['unit_deferred'] = LuaShaderObject
	compileMaterialShader(unitsNormalMapTemplate, "unit")
	compileMaterialShader(featuresNormalMapTemplate, "feature")
	compileMaterialShader(treesNormalMapTemplate, "tree")

	modelsVertexVBO = gl.GetVBO(GL.ARRAY_BUFFER, false)
	modelsIndexVBO = gl.GetVBO(GL.ELEMENT_ARRAY_BUFFER, false)

	if ((modelsVertexVBO == nil) or (modelsIndexVBO == nil)) then
		Spring.Echo("CUS GL4 failed to initialize VBO, exiting")
		gadgetHandler:RemoveGadget()
		return
	end

	modelsVertexVBO:ModelsVBO()
	modelsIndexVBO:ModelsVBO()




	Spring.Echo("[CUS GL4] Initializing bins")

	initBinsAndTextures()

	Spring.Echo("[CUS GL4] Collecting units")
	gadget:DrawWorldPreUnit	()
	Spring.Echo("[CUS GL4] Ready")
end

local function tableEcho(data, name, indent, tableChecked)
	name = name or "TableEcho"
	indent = indent or ""
	if (not tableChecked) and type(data) ~= "table" then
		Spring.Echo(indent .. name, data)
		return
	end
	if type (name) == "table" then
		name = '<table>'
	end
	Spring.Echo(indent .. name .. " = {")
	local newIndent = indent .. "    "
	for name, v in pairs(data) do
		local ty = type(v)
		if ty == "table" then
			tableEcho(v, name, newIndent, true)
		elseif ty == "boolean" then
			Spring.Echo(newIndent .. name .. " = " .. (v and "true" or "false"))
		elseif ty == "string" or ty == "number" then
			Spring.Echo(newIndent .. name .. " = " .. v)
		else
			Spring.Echo(newIndent .. name .. " = ", v)
		end
	end
	Spring.Echo(indent .. "},")
end

local function ReloadCUSGL4(optName, line, words, playerID)
	if (playerID ~= Spring.GetMyPlayerID()) then
		return
	end
	Spring.Echo("[CustomUnitShadersGL4] Reloading")
	gadget:Shutdown()
	gadget:Initialize()
	if FASTRELOADMODE == false then initGL4() end
end

local function DisableCUSGL4(optName, _, _, playerID)
	if (playerID ~= Spring.GetMyPlayerID()) then
		return
	end
	Spring.Echo("[CustomUnitShadersGL4] Disabling")
	gadget:Shutdown()
end

local updaterate = 1
local function CUSGL4updaterate(optName, line, words, playerID)
	if (playerID ~= Spring.GetMyPlayerID()) then
		return
	end
	if updaterate == 1 then
		updaterate = 10
	else
		updaterate = 1
	end
	Spring.Echo("[CustomUnitShadersGL4] Updaterate set to", updaterate)
end

local function DebugCUSGL4(optName, line, words, playerID)
	if (playerID ~= Spring.GetMyPlayerID()) then
		return
	end
	debugmode = not debugmode
	Spring.Echo("[CustomUnitShadersGL4] Debugmode set to", debugmode)
end

local function DumpCUSGL4(optName, line, words, playerID)
	if (playerID ~= Spring.GetMyPlayerID()) then
		return
	end
	Spring.Echo("[CustomUnitShadersGL4] Dumping unit bins:", debugmode)

	if unitDrawBins == nil then return end
	for drawflag, bin in pairs(unitDrawBins) do
		Spring.Echo(string.format("%i = { -- drawFlag",drawflag))
		for shadername, uniformbin in pairs(bin) do
			Spring.Echo(string.format("  %s = { -- shadername",shadername))
			for uniformbinid, texandobjset in pairs(uniformbin) do
				Spring.Echo(string.format("    %s = { -- uniformbin",uniformbinid))
				for texturekey, minibin in pairs(texandobjset) do
				Spring.Echo(string.format("      %i = { -- textureset",texturekey))
					for minibinattr, minibinvalue in pairs(minibin) do
						if type( minibinvalue ) == "table" then
							Spring.Echo(string.format("        %s = {",minibinattr))
							if minibinattr == "objectsIndex" then
								for k,v in pairs(minibinvalue) do
									local objdefname = (k>=0 and Spring.GetUnitDefID(k) and UnitDefs[Spring.GetUnitDefID(k)].name) or (Spring.GetFeatureDefID(-1 * k)  and FeatureDefs[Spring.GetFeatureDefID(-1 * k) ].name) or "???"
									Spring.Echo(string.format("          %i = %i, --(%s)", k,v,objdefname))
								end
							elseif minibinattr == "objectsArray" then
								for k,v in pairs(minibinvalue) do
									local objdefname = (v>=0 and Spring.GetUnitDefID(v) and UnitDefs[Spring.GetUnitDefID(v)].name) or (Spring.GetFeatureDefID(-1 * v)  and FeatureDefs[Spring.GetFeatureDefID(-1 * v) ].name) or "???"
									Spring.Echo(string.format("          %i = %i, --(%s)", k,v,objdefname))
								end
							else
								for k,v in pairs(minibinvalue) do
									Spring.Echo(string.format("          %s = %s,", tostring(k),tostring(v)))
								end
							end
							Spring.Echo("        },")
						else
							Spring.Echo(string.format("        %s = %s,", tostring(minibinattr),tostring(minibinvalue)))
						end
					end
					Spring.Echo("      },")
				end
				Spring.Echo("    },")
			end
			Spring.Echo("  },")
		end
		Spring.Echo("},")
	end
end


local function MarkBinCUSGL4(optName, line, words, playerID)
	if (playerID ~= Spring.GetMyPlayerID()) then
		return
	end
	Spring.Echo("[CustomUnitShadersGL4] Marking Bins", optName, line, words, playerID)
	local passnum = tonumber(line)
	if passnum == nil then return end


	local function markBin(drawPass)
		local count = 0

		local bin = unitDrawBins[drawPass]
		for shadername, uniformbin in pairs(bin) do
			for uniformbinid, texandobjset in pairs(uniformbin) do
				for texturekey, minibin in pairs(texandobjset) do
					for objectID, _ in pairs(minibin.objectsIndex) do
						local px, py, pz
						if objectID > 0 then
							px, py, pz = Spring.GetUnitPosition(objectID)
						else
							px, py, pz = Spring.GetFeaturePosition(-1* objectID)
						end
						if px then
							Spring.MarkerAddPoint(px,py,pz,
								tostring(drawPass) .. "/" ..
								tostring(shadername) .. "/" ..
								tostring(uniformbinid) .. "/" ..
								tostring(texturekey) .. "/" ..
								tostring(objectID))
							count = count + 1
						end
					end
				end
			end
		end
		Spring.Echo("Added markers for", count, "units in drawPass", drawPass)
	end

	markBin(passnum)
end



function gadget:Initialize()
	if FASTRELOADMODE then initGL4() end
	gadgetHandler:AddChatAction("reloadcusgl4", ReloadCUSGL4)
	gadgetHandler:AddChatAction("disablecusgl4", DisableCUSGL4)
	gadgetHandler:AddChatAction("cusgl4updaterate", CUSGL4updaterate)
	gadgetHandler:AddChatAction("debugcusgl4", DebugCUSGL4)
	gadgetHandler:AddChatAction("dumpcusgl4", DumpCUSGL4)
	gadgetHandler:AddChatAction("markbincusgl4", MarkBinCUSGL4)
end




function gadget:Shutdown()
	if debugmode then tableEcho(unitDrawBins, 'unitDrawBins') end


	for unitID, _ in pairs(overriddenUnits) do
		RemoveObject(unitID)
	end

	for featureID, _ in pairs(overriddenFeatures) do
		RemoveObject(-1 * featureID)
	end
	if unitDrawBins then
		for drawFlag, bins in pairs(unitDrawBins) do
			for shaderName, _ in pairs(bins) do
				shaders[drawFlag][shaderName]:Finalize()
			end
		end
	end

	modelsVertexVBO = nil
	modelsIndexVBO = nil

	unitDrawBins = nil
	--if debugmode then Spring.Debug.TraceFullEcho() end
	--gadgetHandler:RemoveChatAction("disablecusgl4")
	--gadgetHandler:RemoveChatAction("reloadcusgl4")
	--gadgetHandler:RemoveChatAction("cusgl4updaterate")

end


local totalbatches = 0
local totalunits = 0

local updateframe = 0

local updatecount = 0
local updatetimer = 31

local prevobjectcount = 0

local function countbintypes(flagarray)
	local fwcnt = 0
	local defcnt = 0
	local reflcnt = 0
	local shadcnt = 0

	for i=1, #flagarray do
		local flag = flagarray[i]
		if HasBit(flag,1) then
			fwcnt = fwcnt + 1
			defcnt = defcnt + 1
		end
		if HasBit(flag, 4) then
			reflcnt = reflcnt + 1
		end
		if HasBit(flag, 16) then
			shadcnt = shadcnt + 1
		end
	end
	return fwcnt, defcnt, reflcnt, shadcnt
end

function gadget:DrawWorldPreUnit()
	updatecount = updatecount + 1
	if unitDrawBins == nil then return end

	if updatecount % updatetimer == 0 then
		-- Spring.Echo("Total number of unit models drawn per frame", totalunits / updatetimer, "in ", totalbatches/updatetimer, "batches")
		totalbatches = 0
		totalunits = 0
	end

	updateframe = (updateframe + 1) % updaterate

	if updateframe == 0 then
		-- this call has a massive mem load, at 1k units at 225 fps, its 7mb/sec, e.g. for each unit each frame, its 32 bytes alloc/dealloc
		-- which isnt all that bad, but still far from optimal
		-- it is, however, not that bad CPU wise, and it doesnt force GC load either

		local units, drawFlagsUnits = Spring.GetRenderUnits(overrideDrawFlag, true)
		local features, drawFlagsFeatures = Spring.GetRenderFeatures(overrideDrawFlag, true)

		local totalobjects = #units + #features
		local t0 = Spring.GetTimer()

		ProcessUnits(units, drawFlagsUnits)
		ProcessFeatures(features, drawFlagsFeatures)
		local deltat = Spring.DiffTimers(Spring.GetTimer(),t0,  true) -- in ms




		if (deltat > 5) and FASTRELOADMODE then
			local usecperobjectchange = math.ceil((1000* deltat)  / (totalobjects - prevobjectcount))
			--Spring.Echo("[CUS GL4] ",totalobjects," Update time 50ms < ", deltat, "ms, per object change: ", usecperobjectchange, 'usec')

			local fwc, defc, reflc, shadc = countbintypes(drawFlagsUnits)
			--Spring.Echo("fwc", fwc,  "defc", defc, "reflc", reflc, "shadc", shadc)
			--Spring.Echo(countbintypes(drawFlagsUnits))
			-- PERF CONCULUSION:
				-- Additions of units are about 30 uS
				-- Removals of units is about 50 uS
			-- After faster texture key lookups, this has dropped significantly:
				-- Additions of units are about 7 uS
				-- Removals of units is about 10 uS
			-- Using shared deferred and forward bin perf is now even closer:
				-- Addition 6 us
				-- Removal 7 us
		end
		--if updatecount %100 == 0 then Spring.Echo(countbintypes(drawFlagsUnits)) end
		prevobjectcount = totalobjects

	end

end

local seenbitsopaque = 0
local seenbitsalpha = 0
local gf = 0
function gadget:GameFrame(n)
	gf = n
	if (n%300) == 0 then
		--Spring.Echo(Spring.GetGameFrame(), "processedCounter", processedCounter, asssigncalls,gettexturescalls, 'seenopaque', seenbitsopaque, 'seenalpha', seenbitsalpha)
	end
end



function gadget:DrawOpaqueUnitsLua(deferredPass, drawReflection, drawRefraction)
	if unitDrawBins == nil then return end
	local drawPass = 1 --opaque

	if deferredPass then
		drawPass = 0
	end

	if drawReflection then
		drawPass = 1 + 4
	end

	if drawRefraction then
		drawPass = 1 + 8
	end

	seenbitsopaque = math.bit_or(seenbitsopaque, drawPass)
	local batches, units = ExecuteDrawPass(drawPass)
	totalbatches = totalbatches + batches
	totalunits = totalunits + units
	-- if gf % 61 == 0 then Spring.Echo("drawPass", drawPass, "batches", batches, "units", units) end
end

function gadget:DrawAlphaUnitsLua(drawReflection, drawRefraction)
	if unitDrawBins == nil then return end
	local drawPass = 2 --alpha

	if drawReflection then
		drawPass = 2 + 4
	end

	if drawRefraction then
		drawPass = 2 + 8
	end

	seenbitsalpha = math.bit_or(seenbitsalpha, drawPass)
	local batches, units = ExecuteDrawPass(drawPass)
	--if gf % 61 == 0 then Spring.Echo("drawPass", drawPass, "batches", batches, "units", units) end

end

function gadget:DrawOpaqueFeaturesLua(deferredPass, drawReflection, drawRefraction)
	if unitDrawBins == nil then return end

	--Spring.Echo("gadget:DrawOpaqueFeaturesLua",deferredPass, drawReflection, drawRefraction)
	local drawPass = 1 --opaque

	if deferredPass then
		drawPass = 0
	end

	if drawReflection then
		drawPass = 1 + 4
	end

	if drawRefraction then
		drawPass = 1 + 8
	end

	seenbitsopaque = math.bit_or(seenbitsopaque, drawPass)
	--local batches, units = ExecuteDrawPass(drawPass)
	--if gf % 61 == 0 then Spring.Echo("drawPass", drawPass, "batches", batches, "units", units) end
end

function gadget:DrawAlphaFeaturesLua(drawReflection, drawRefraction)
	if unitDrawBins == nil then return end
	--Spring.Echo("gadget:DrawAlphaFeaturesLua",drawReflection, drawRefraction)
	local drawPass = 2 --alpha

	if drawReflection then
		drawPass = 2 + 4
	end

	if drawRefraction then
		drawPass = 2 + 8
	end

	seenbitsalpha = math.bit_or(seenbitsalpha, drawPass)
	--local batches, units = ExecuteDrawPass(drawPass)
	--if gf % 61 == 0 then Spring.Echo("drawPass", drawPass, "batches", batches, "units", units) end

end

function gadget:DrawShadowUnitsLua()
	if unitDrawBins == nil then return end
	ExecuteDrawPass(16)
end


function gadget:DrawShadowFeaturesLua()
	if unitDrawBins == nil then return end
	--ExecuteDrawPass(16)
end
