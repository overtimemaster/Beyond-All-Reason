return {
	armageo = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 0,
		buildcostenergy = 27000,
		buildcostmetal = 1600,
		buildpic = "ARMAGEO.DDS",
		buildtime = 33152,
		canrepeat = false,
		category = "ALL NOTSUB NOWEAPON NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 10 0",
		collisionvolumescales = "77 66 77",
		collisionvolumetype = "CylY",
		energymake = 1250,
		energystorage = 12000,
		explodeas = "advancedFusionExplosion",
		footprintx = 4,
		footprintz = 4,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 3240,
		maxslope = 15,
		maxwaterdepth = 0,
		objectname = "Units/ARMAGEO.s3o",
		script = "Units/ARMAGEO.cob",
		seismicsignature = 0,
		selfdestructas = "advgeo",
		sightdistance = 273,
		yardmap = "h yyooooyy yyssssyy osooooso osojjoso osojjoso osooooso yyssssyy yyooooyy",
		customparams = {
			usebuildinggrounddecal = true,
			buildinggrounddecaltype = "decals/armageo_aoplane.dds",
			buildinggrounddecalsizey = 11,
			buildinggrounddecalsizex = 11,
			buildinggrounddecaldecayspeed = 30,
			unitgroup = 'energy',
			cvbuildable = true,
			geothermal = 1,
			model_author = "Cremuss",
			normaltex = "unittextures/Arm_normal.dds",
			removestop = true,
			removewait = true,
			subfolder = "armbuildings/landeconomy",
			techlevel = 2,
		},
		sfxtypes = {
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			select = {
				[1] = "geothrm1",
			},
		},
	},
}