return {
	cortoast = {
		acceleration = 0,
		activatewhenbuilt = false,
		brakerate = 0,
		buildangle = 8192,
		buildcostenergy = 17000,
		buildcostmetal = 2500,
		buildpic = "CORTOAST.DDS",
		buildtime = 25717,
		canrepeat = false,
		category = "ALL NOTLAND WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		corpse = "DEAD",
		damagemodifier = 0.25,
		explodeas = "mediumBuildingExplosionGeneric",
		footprintx = 3,
		footprintz = 3,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 3840,
		maxslope = 10,
		maxwaterdepth = 0,
		nochasecategory = "MOBILE",
		objectname = "Units/CORTOAST.s3o",
		onoffable = true,
		script = "Units/CORTOAST.cob",
		seismicsignature = 0,
		selfdestructas = "mediumBuildingExplosionGenericSelfd",
		sightdistance = 416,
		usepiececollisionvolumes = 1,
		yardmap = "ooooooooo",
		customparams = {
			usebuildinggrounddecal = true,
			buildinggrounddecaltype = "decals/cortoast_aoplane.dds",
			buildinggrounddecalsizey = 5,
			buildinggrounddecalsizex = 5,
			buildinggrounddecaldecayspeed = 30,
			unitgroup = 'weapon',
			model_author = "Mr Bob",
			normaltex = "unittextures/cor_normal.dds",
			onoffname = "trajectory",
			subfolder = "corbuildings/landdefenceoffence",
			techlevel = 2,
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "2.98622894287 -7.32421874261e-08 6.36557769775",
				collisionvolumescales = "66.412979126 46.1585998535 60.6329803467",
				collisionvolumetype = "Box",
				damage = 2304,
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 1507,
				object = "Units/cortoast_dead.s3o",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "55.0 4.0 6.0",
				collisionvolumetype = "cylY",
				damage = 576,
				energy = 0,
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 241,
				object = "Units/cor3X3A.s3o",
				reclaimable = true,
				resurrectable = 0,
				world = "All Worlds",
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:barrelshot-large",
			},
			pieceexplosiongenerators = {
				[1] = "deathceg2",
				[2] = "deathceg3",
				[3] = "deathceg4",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			cloak = "kloak2",
			uncloak = "kloak2un",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "twrturn3",
			},
			select = {
				[1] = "twrturn3",
			},
		},
		weapondefs = {
			cortoast_gun = {
				accuracy = 450,
				areaofeffect = 164,
				avoidfeature = false,
				cegtag = "arty-heavy",
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.4,
				explosiongenerator = "custom:genericshellexplosion-medium-aoe",
				gravityaffected = "true",
				impulseboost = 0.123,
				impulsefactor = 0.5,
				--model = "artshell-medium.s3o",
				name = "Pop-up long-range heavy g2g plasma cannon",
				noselfdamage = true,
				predictboost = 0.2,
				range = 1390,
				reloadtime = 2.1,
				soundhit = "xplomed2",
				soundhitwet = "splslrg",
				soundstart = "cannhvy5",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 450,
				damage = {
					bombers = 90,
					commanders = 420,
					default = 420,
					fighters = 90,
					hvyboats = 420,
					lboats = 420,
					subs = 90,
					vtol = 90,
				},
			},
			cortoast_gun_high = {
				accuracy = 450,
				areaofeffect = 240,
				avoidfeature = false,
				cegtag = "arty-huge",
				craterareaofeffect = 240,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.65,
				explosiongenerator = "custom:genericshellexplosion-large-bomb",
				gravityaffected = "true",
				hightrajectory = 1,
				impulseboost = 0.123,
				impulsefactor = 2,
				--model = "artshell-medium.s3o",
				name = "Pop-up high-trajectory long-range heavy g2g AoE plasma cannon",
				noselfdamage = true,
				proximitypriority = -2,
				range = 1390,
				reloadtime = 8,
				soundhit = "xplolrg4",
				soundhitwet = "splslrg",
				soundstart = "cannhvy6",
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 440,
				damage = {
					bombers = 90,
					commanders = 960,
					default = 960,
					fighters = 90,
					hvyboats = 960,
					lboats = 960,
					subs = 90,
					vtol = 90,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL GROUNDSCOUT",
				def = "CORTOAST_GUN",
				maindir = "0 1 0",
				maxangledif = 230,
				onlytargetcategory = "SURFACE",
			},
			[2] = {
				badtargetcategory = "VTOL GROUNDSCOUT",
				def = "CORTOAST_GUN_HIGH",
				onlytargetcategory = "SURFACE",
			},
		},
	},
}