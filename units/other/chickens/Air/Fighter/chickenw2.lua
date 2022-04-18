return {
	chickenw2 = {
		acceleration = 2,
		airsightdistance = 1500,
		amphibious = true,
		autoheal = 10,
		bankscale = "1",
		bmcode = "1",
		brakerate = 0.2,
		buildcostenergy = 2200,
		buildcostmetal = 72,
		builder = false,
		buildpic = "chickens/chickenw2.DDS",
		buildtime = 1950,
		cancrash = false,
		canfly = true,
		canguard = true,
		canland = true,
		canmove = true,
		canpatrol = true,
		canstop = true,
		cansubmerge = false,
		capturable = false,
		category = "ALL MOBILE WEAPON NOTLAND VTOL NOTSUB NOTSHIP NOTHOVER CHICKEN",
		collide = false,
		collisionvolumeoffsets = "0 7 -6",
		collisionvolumescales = "48 12 22",
		collisionvolumetype = "box",
		cruisealt = 150,
		defaultmissiontype = "VTOL_standby",
		explodeas = "TALON_DEATH",
		floater = true,
		footprintx = 1,
		footprintz = 1,
		hidedamage = 1,
		maneuverleashlength = "1280",
		mass = 200,
		maxacc = 1.0325,
		maxaileron = 0.01718,
		maxbank = 0.8,
		maxdamage = 1100,
		maxelevator = 0.01343,
		maxpitch = 0.625,
		maxrudder = 0.00893,
		maxvelocity = 11,
		moverate1 = "32",
		noautofire = false,
		nochasecategory = "NOTAIR",
		objectname = "Chickens/chicken_crow.s3o",
		script = "Chickens/chickenw2.cob",
		seismicsignature = 0,
		selfdestructas = "TALON_DEATH",
		separation = "0.2",
		side = "THUNDERBIRDS",
		sightdistance = 0,
		smoothanim = true,
		speedtofront = 0.07,
		steeringmode = "1",
		tedclass = "VTOL",
		turninplace = true,
		turnradius = 64,
		turnrate = 1600,
		unitname = "chickenw2",
		usesmoothmesh = true,
		wingangle = 0.06593,
		wingdrag = 0.435,
		workertime = 0,
		customparams = {
			subfolder = "other/chickens",
			model_author = "KDR_11k, Beherith",
			normalmaps = "yes",
			normaltex = "unittextures/chicken_m_normals.png",
			treeshader = "yes",
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:blood_spray",
				[2] = "custom:blood_explode",
				[3] = "custom:dirt",
			},
			pieceexplosiongenerators = {
				[1] = "blood_spray",
				[2] = "blood_spray",
				[3] = "blood_spray",
			},
		},
		weapondefs = {
			weapon = {
				areaofeffect = 32,
				collidefriendly = 0,
				collidefeature = 0,
				avoidfeature = 0,
				avoidfriendly = 0,
				avoidfriendly = false,
				burnblow = true,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0.3,
				explosiongenerator = "custom:chickenspike-large-sparks-burn",
				impulseboost = 1,
				impulsefactor = 1,
				interceptedbyshieldtype = 0,
				model = "Chickens/spike.s3o",
				name = "Spike",
				noselfdamage = true,
				predictboost = 1,
				range = 600,
				reloadtime = 1.6,
				smoketrail = true,
				soundstart = "talonattack",
				startvelocity = 600,
				texture1 = "",
				texture2 = "sporetrail",
				turret = true,
				weaponacceleration = 250,
				weapontimer = 1,
				weaponvelocity = 1000,
				damage = {
					default = 200,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "NOTAIR",
				def = "WEAPON",
				maindir = "0 0 1",
				maxangledif = 90,
				onlytargetcategory = "VTOL",
			},
		},
	},
}