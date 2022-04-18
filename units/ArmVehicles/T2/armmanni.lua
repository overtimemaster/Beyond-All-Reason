return {
	armmanni = {
		acceleration = 0.00715,
		brakerate = 0.01431,
		buildcostenergy = 13500,
		buildcostmetal = 1200,
		buildpic = "ARMMANNI.DDS",
		buildtime = 25706,
		canmove = true,
		category = "ALL TANK MOBILE WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 -6 -7",
		collisionvolumescales = "39 49 39",
		collisionvolumetype = "box",
		corpse = "DEAD",
		explodeas = "penetrator",
		footprintx = 3,
		footprintz = 3,
		idleautoheal = 5,
		idletime = 1800,
		leavetracks = true,
		mass = 5001,
		maxdamage = 2500,
		maxreversevelocity = 0.608,
		maxslope = 12,
		maxvelocity = 1.4,
		maxwaterdepth = 0,
		movementclass = "TANK3",
		nochasecategory = "VTOL",
		objectname = "Units/ARMMANNI.s3o",
		script = "Units/ARMMANNI.cob",
		seismicsignature = 0,
		selfdestructas = "penetrator",
		sightdistance = 650,
		trackoffset = 6,
		trackstrength = 10,
		tracktype = "armacv_tracks",
		trackwidth = 46,
		turninplace = true,
		turninplaceanglelimit = 90,
		turninplacespeedlimit = 1.00188,
		turnrate = 120.8,
		customparams = {
			unitgroup = 'weapon',
			basename = "base",
			cannon1name = "barrel",
			driftratio = "0",
			firingceg = "barrelshot-small",
			flare1name = "flash",
			kickback = "-2",
			model_author = "FireStorm",
			normaltex = "unittextures/Arm_normal.dds",
			restoretime = "3000",
			rockstrength = "3",
			sleevename = "sleeve",
			subfolder = "armvehicles/t2",
			techlevel = 2,
			turretname = "turret",
			wpn1turretx = "50",
			wpn1turrety = "50",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "0.488914489746 -0.0356475219727 -0.0921630859375",
				collisionvolumescales = "42.3086700439 54.9257049561 44.5536499023",
				collisionvolumetype = "Box",
				damage = 2000,
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 20,
				hitdensity = 100,
				metal = 734,
				object = "Units/armmanni_dead.s3o",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "55.0 4.0 6.0",
				collisionvolumetype = "cylY",
				damage = 1500,
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 294,
				object = "Units/arm3X3C.s3o",
				reclaimable = true,
				resurrectable = 0,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
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
				[1] = "tarmmove",
			},
			select = {
				[1] = "tarmsel",
			},
		},
		weapondefs = {
			atam = {
				areaofeffect = 12,
				avoidfeature = false,
				beamtime = 0.3,
				corethickness = 0.23,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				energypershot = 1000,
				explosiongenerator = "custom:laserhit-large-blue",
				impulseboost = 0,
				impulsefactor = 0,
				largebeamlaser = true,
				laserflaresize = 6.05,
				name = "Heavy long-range g2g tachyon beam",
				noselfdamage = true,
				range = 950,
				reloadtime = 4.7,
				rgbcolor = "0 0 1",
				scrollspeed = 5,
				soundhitdry = "",
				soundhitwet = "sizzle",
				soundstart = "annigun1",
				soundtrigger = 1,
				targetmoveerror = 0.3,
				texture3 = "largebeam",
				thickness = 4.5,
				tilelength = 150,
				tolerance = 10000,
				turret = true,
				weapontype = "BeamLaser",
				weaponvelocity = 1500,
				customparams = {
					expl_light_life_mult = 1.3,
					expl_light_radius_mult = 1.15,
					expl_light_mult = 1.15,
					light_radius_mult = "1.2",
					light_mult = 3,
				},
				damage = {
					commanders = 1000,
					default = 2500,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "VTOL",
				def = "ATAM",
				maindir = "0 0 1",
				maxangledif = 180,
				onlytargetcategory = "SURFACE",
			},
		},
	},
}