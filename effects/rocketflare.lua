local definitions = {

	["RocketFlare"] = {
		fire = {
			class = [[CBitmapMuzzleFlame]],
			water=1,
			air=1,
			underwater=1,
			ground=1,
			count=1,
			properties = {
				dir = [[dir]],
				colorMap=[[1 0.6 0.25 0.015  0.75 0.3 0.1 0.006]],
				size=-2.6,
				length=-11,
				sizeGrowth=0.75,
				ttl=5,
				frontOffset=0,
				sideTexture=[[shot]],
				frontTexture=[[flashcrap]],
			}
		},
		fireglow = {
			air                = true,
			class              = [[CSimpleParticleSystem]],
			count              = 1,
			ground             = true,
			water              = true,
			properties = {
				airdrag            = 0,
				colormap           = [[0.08 0.055 0.015 0.005   0 0 0 0.01]],
				directional        = true,
				emitrot            = 90,
				emitrotspread      = 0,
				emitvector         = [[0.0, 1, 0.0]],
				gravity            = [[0.0, 0.0, 0.0]],
				numparticles       = 1,
				particlelife       = 5,
				particlelifespread = 0,
				particlesize       = 35,
				particlesizespread = 6,
				particlespeed      = 0,
				particlespeedspread = 0,
				pos                = [[0.0, 0, 0.0]],
				sizegrowth         = -0.25,
				sizemod            = 1,
				texture            = [[glow]],
				useairlos          = true,
			},
		},
		smoke = {
			air                = true,
			class              = [[CSimpleParticleSystem]],
			count              = 1,
			ground             = true,
			water              = true,
			properties = {
				airdrag            = 0.84,
				colormap           = [[ 0.12 0.11 0.1 0.45   0.12 0.11 0.10 0.4   0.07 0.07 0.07 0.22   0 0 0 0]],
				directional        = false,
				emitrot            = 0,
				emitrotspread      = 20,
				emitvector         = [[dir]],
				gravity            = [[0,0,0]],
				numparticles       = 17,
				particlelife       = 55,
				particlelifespread = 0,
				particlesize       = 1.7,
				particlesizespread = 1.2,
				particlespeed      = -0.25,
				particlespeedspread = -2.5,
				pos                = [[0, 1, 3]],
				sizegrowth         = 0.04,
				sizemod            = 1.0,
				texture            = [[smoke]],
			},
		},
	},

	["RocketFlare-large"] = {
		fire = {
			class = [[CBitmapMuzzleFlame]],
			water=1,
			air=1,
			underwater=1,
			ground=1,
			count=1,
			properties = {
				dir = [[dir]],
				colorMap=[[1 0.6 0.25 0.015  0.75 0.3 0.1 0.006]],
				size=-3.7,
				length=-15,
				sizeGrowth=0.75,
				ttl=5,
				frontOffset=0,
				sideTexture=[[shot]],
				frontTexture=[[flashcrap]],
			}
		},
		fireglow = {
			air                = true,
			class              = [[CSimpleParticleSystem]],
			count              = 1,
			ground             = true,
			water              = true,
			properties = {
				airdrag            = 0,
				colormap           = [[0.08 0.055 0.015 0.005   0 0 0 0.01]],
				directional        = true,
				emitrot            = 90,
				emitrotspread      = 0,
				emitvector         = [[0.0, 1, 0.0]],
				gravity            = [[0.0, 0.0, 0.0]],
				numparticles       = 1,
				particlelife       = 6,
				particlelifespread = 0,
				particlesize       = 50,
				particlesizespread = 9,
				particlespeed      = 0,
				particlespeedspread = 0,
				pos                = [[0.0, 0, 0.0]],
				sizegrowth         = -0.25,
				sizemod            = 1,
				texture            = [[glow]],
				useairlos          = true,
			},
		},
		smoke = {
			air                = true,
			class              = [[CSimpleParticleSystem]],
			count              = 1,
			ground             = true,
			water              = true,
			properties = {
				airdrag            = 0.84,
				colormap           = [[ 0.12 0.11 0.1 0.45   0.12 0.11 0.10 0.4   0.07 0.07 0.07 0.22   0 0 0 0]],
				directional        = false,
				emitrot            = 0,
				emitrotspread      = 20,
				emitvector         = [[dir]],
				gravity            = [[0,0,0]],
				numparticles       = 25,
				particlelife       = 55,
				particlelifespread = 0,
				particlesize       = 2.8,
				particlesizespread = 2.8,
				particlespeed      = -0.4,
				particlespeedspread = -3.5,
				pos                = [[0, 1, 3]],
				sizegrowth         = 0.04,
				sizemod            = 1.0,
				texture            = [[smoke]],
			},
		},
	},
	
}

return definitions
