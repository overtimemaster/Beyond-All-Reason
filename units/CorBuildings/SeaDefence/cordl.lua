return {
	cordl = {
		acceleration = 0,
		activatewhenbuilt = true,
		brakerate = 0,
		buildangle = 16384,
		buildcostenergy = 2200,
		buildcostmetal = 250,
		buildpic = "CORDL.DDS",
		buildtime = 6800,
		canrepeat = false,
		category = "ALL NOTLAND WEAPON NOTSUB NOTSHIP NOTAIR NOTHOVER SURFACE EMPABLE",
		collisionvolumeoffsets = "0 3 0",
		collisionvolumescales = "38 52 38",
		collisionvolumetype = "CylY",
		corpse = "DEAD",
		explodeas = "smallBuildingExplosionGeneric",
		footprintx = 4,
		footprintz = 4,
		icontype = "building",
		idleautoheal = 5,
		idletime = 1800,
		maxdamage = 2100,
		maxslope = 15,
		maxwaterdepth = 0,
		objectname = "Units/CORDL.s3o",
		script = "Units/CORDL.cob",
		seismicsignature = 0,
		selfdestructas = "smallBuildingExplosionGenericSelfd",
		sightdistance = 611,
		sonardistance = 600,
		yardmap = "yyyyyooyyooyyyyy",
		customparams = {
			usebuildinggrounddecal = true,
			buildinggrounddecaltype = "decals/cordl_aoplane.dds",
			buildinggrounddecalsizey = 4,
			buildinggrounddecalsizex = 4,
			buildinggrounddecaldecayspeed = 30,
			unitgroup = 'sub',
			model_author = "Mr Bob",
			normaltex = "unittextures/cor_normal.dds",
			removewait = true,
			subfolder = "corbuildings/seadefence",
		},
		featuredefs = {
			dead = {
				blocking = true,
				category = "corpses",
				collisionvolumeoffsets = "-0.56217956543 -6.50129699707 0.0390319824219",
				collisionvolumescales = "41.9183044434 28.9974060059 37.2331542969",
				collisionvolumetype = "Box",
				damage = 645,
				energy = 0,
				featuredead = "HEAP",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 30,
				hitdensity = 100,
				metal = 182,
				object = "Units/cordl_dead.s3o",
				reclaimable = true,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				collisionvolumescales = "55.0 4.0 6.0",
				collisionvolumetype = "cylY",
				damage = 323,
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 73,
				object = "Units/cor3X3B.s3o",
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
			cloak = "kloak1",
			uncloak = "kloak1un",
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
				[1] = "servmed2",
			},
			select = {
				[1] = "servmed2",
			},
		},
		weapondefs = {
			coax_depthcharge = {
				avoidfeature = false,
				avoidfriendly = false,
				bouncerebound = 0.6,
				bounceslip = 0.6,
				burnblow = true,
				collidefriendly = false,
				craterareaofeffect = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.15,
				explosiongenerator = "custom:genericshellexplosion-small-uw",
				flighttime = 1.75,
				groundbounce = true,
				impulseboost = 0.123,
				impulsefactor = 0.123,
				model = "cordepthcharge.s3o",
				name = "Depthcharge launcher",
				noselfdamage = true,
				numbounce = 1,
				range = 600,
				reloadtime = 1.5,
				soundhit = "xplodep2",
				soundhitwet = "splsmed",
				soundstart = "torpedo1",
				soundhitvolume = 3,
				soundhitwetvolume = 12,
				startvelocity = 300,
				tracks = true,
				turnrate = 64000,
				turret = true,
				waterweapon = true,
				weapontype = "TorpedoLauncher",
				weaponvelocity = 200,
				damage = {
					default = 225,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTSUB",
				def = "COAX_DEPTHCHARGE",
				onlytargetcategory = "NOTHOVER",
			},
		},
	},
}