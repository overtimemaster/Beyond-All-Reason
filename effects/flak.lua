
local definitions = {
    ["flak"] = {
        shardcloud = {
            air                = true,
            class              = [[CExpGenSpawner]],
            count              = 6,
            ground             = true,
            water              = true,
            underwater         = true,
            properties = {
                delay              = [[r7]],
                explosiongenerator = [[custom:flakshard]],
                pos                = [[-38 r76, -30 r60, -38 r76]],
            },
        },
        -- glow = {
        --     air                = true,
        --     class              = [[CSimpleParticleSystem]],
        --     count              = 1,
        --     ground             = true,
        --     water              = true,
        --     properties = {
        --         airdrag            = 0,
        --         colormap           = [[0.115 0.09 0.1 0.01   0 0 0 0.01]],
        --         directional        = true,
        --         emitrot            = 90,
        --         emitrotspread      = 0,
        --         emitvector         = [[dir]],
        --         gravity            = [[0.0, 0.0, 0.0]],
        --         numparticles       = 1,
        --         particlelife       = 12,
        --         particlelifespread = 12,
        --         particlesize       = 95,
        --         particlesizespread = 15,
        --         particlespeed      = 0,
        --         particlespeedspread = 0,
        --         pos                = [[0.0, 90, 0.0]],
        --         sizegrowth         = 0,
        --         sizemod            = 1,
        --         texture            = [[glow2]],
        --         useairlos          = true,
        --     },
        -- },
        brightflare = {
          air                = true,
          class              = [[CBitmapMuzzleFlame]],
          count              = 1,
          ground             = true,
          underwater         = true,
          water              = true,
          properties = {
            colormap           = [[0.8 0.6 0.7 0.6    0.30 0.18 0.23 0.3   0 0 0 0]],
            dir                = [[0, 1, 0]],
            --gravity            = [[0.0, 0.1, 0.0]],
            frontoffset        = 0,
            fronttexture       = [[exploflare]],
            length             = 40,
            sidetexture        = [[none]],
            size               = 70,
            sizegrowth         = [[-0.5 r-0.5]],
            ttl                = 6,
            pos                = [[0, 0, 0]],

          },
        },
        explosion = {
            air                = true,
            class              = [[CSimpleParticleSystem]],
            count              = 0,
            ground             = true,
            water              = true,
            underwater         = false,
            properties = {
                airdrag            = 0.77,
                colormap           = [[0 0 0 0   1 0.8 0.9 0.09   0.9 0.5 0.6 0.066   0.6 0.28 0.3 0.033   0 0 0 0]],
                directional        = true,
                emitrot            = 45,
                emitrotspread      = 32,
                emitvector         = [[0, 1, 0]],
                gravity            = [[0, -0.01, 0]],
                numparticles       = 3,
                particlelife       = 6,
                particlelifespread = 5,
                particlesize       = 2,
                particlesizespread = 2,
                particlespeed      = 0.2,
                particlespeedspread = 1,
                pos                = [[0, 2, 0]],
                sizegrowth         = 0.2,
                sizemod            = 1.1,
                texture            = [[flashside2]],
                useairlos          = false,
            },
        },
        smoke = {
            class = [[CSimpleParticleSystem]],
            water=0,
            air=1,
            ground=1,
            count=0,
            properties = {
                airdrag=0.7,
                alwaysVisible = 0,
                sizeGrowth = 0.12,
                sizeMod = 1,
                pos = [[-2 r4, -2 r4, -2 r4]],
                emitRot=35,
                emitRotSpread=40,
                emitVector = [[0, 1, 0]],
                gravity = [[0, 0.014, 0]],
                colormap = [[0.9 0.6 0.66 0.4   0.1 0.07 0.085 0.6   0.044 0.04 0.041 0.4   0.04 0.034 0.034 0.4   0.025 0.025 0.025 0.26   0.014 0.014 0.014 0.15   0.01 0.01 0.01 0.1    0.006 0.006 0.006 0.06   0 0 0 0.01]],
                Texture=[[smoke]],
                particleLife=5,
                particleLifeSpread=55,
                numparticles=[[2.6 r1]],
                particleSpeed=0.3,
                particleSpeedSpread=1.5,
                particleSize=8,
                particleSizeSpread=8,
                directional=0,
            },
        },
    },
    ["flakshard"] = {
        explosion = {
            air                = true,
            class              = [[CSimpleParticleSystem]],
            count              = 1,
            ground             = true,
            water              = true,
            underwater         = false,
            properties = {
                airdrag            = 0.77,
                colormap           = [[0 0 0 0   1 0.8 0.9 0.18   0.9 0.5 0.6 0.066   0.6 0.28 0.3 0.033   0 0 0 0]],
                directional        = true,
                emitrot            = 45,
                emitrotspread      = 32,
                emitvector         = [[0, 1, 0]],
                gravity            = [[0, -0.01, 0]],
                numparticles       = [[2.5 r1]],
                particlelife       = 3,
                particlelifespread = 7,
                particlesize       = 2.2,
                particlesizespread = 2.4,
                particlespeed      = 0.2,
                particlespeedspread = 1,
                rotParams          = [[-120 r240, -60 r120, -180 r360]],
                pos                = [[0, 2, 0]],
                sizegrowth         = 0.2,
                sizemod            = 1.1,
                texture            = [[flashside2]],
                useairlos          = false,
            },
        },
        glow = {
            air                = true,
            class              = [[CSimpleParticleSystem]],
            count              = 1,
            ground             = true,
            water              = true,
            properties = {
                airdrag            = 0,
                colormap           = [[0.13 0.1 0.117 0.01   0 0 0 0.01]],
                directional        = true,
                emitrot            = 90,
                emitrotspread      = 0,
                emitvector         = [[dir]],
                gravity            = [[0.0, 0.0, 0.0]],
                numparticles       = 1,
                particlelife       = 8,
                particlelifespread = 12,
                particlesize       = 48,
                particlesizespread = 14,
                particlespeed      = 0,
                particlespeedspread = 0,
                pos                = [[0.0, 90, 0.0]],
                sizegrowth         = 0,
                sizemod            = 1,
                texture            = [[glow2]],
                useairlos          = true,
            },
        },
        smoke = {
            class = [[CSimpleParticleSystem]],
            water=0,
            air=1,
            ground=1,
            count=1,
            properties = {
                airdrag=0.7,
                alwaysVisible = 0,
                sizeGrowth = 0.06,
                sizeMod = 1,
                rotParams          = [[-6 r12, -0.5 r1, -180 r360]],
                pos = [[-2 r4, -2 r4, -2 r4]],
                emitRot=35,
                emitRotSpread=40,
                emitVector = [[0, 1, 0]],
                gravity = [[0, 0.014, 0]],
                colormap = [[0.9 0.6 0.66 0.4   0.1 0.07 0.085 0.6   0.044 0.04 0.041 0.4   0.04 0.034 0.034 0.4   0.025 0.025 0.025 0.26   0.014 0.014 0.014 0.14   0.01 0.01 0.01 0.09    0.006 0.006 0.006 0.06   0 0 0 0.01]],
                Texture=[[smoke]],
                particleLife=6,
                particleLifeSpread=23,
                numparticles=1,
                particleSpeed=0.3,
                particleSpeedSpread=1.5,
                particleSize=7.5,
                particleSizeSpread=10.5,
                directional=0,
            },
        },
        smoke2 = {
            class = [[CSimpleParticleSystem]],
            water=0,
            air=1,
            ground=1,
            count=1,
            properties = {
                airdrag=0.7,
                alwaysVisible = 0,
                sizeGrowth = 0.08,
                sizeMod = 1,
                rotParams          = [[-60 r120, -30 r60, -180 r360]],
                pos = [[-2 r4, -2 r4, -2 r4]],
                emitRot=35,
                emitRotSpread=40,
                emitVector = [[0, 1, 0]],
                gravity = [[0, 0.014, 0]],
                colormap = [[0.9 0.6 0.66 0.55   0.1 0.07 0.085 0.7   0.044 0.04 0.041 0.55   0.04 0.034 0.034 0.4   0.036 0.033 0.033 0.36   0.025 0.025 0.025 0.32   0.014 0.014 0.014 0.2   0.01 0.01 0.01 0.15    0.006 0.006 0.006 0.08   0 0 0 0.01]],
                Texture=[[smoke_puff]],
                particleLife=5,
                particleLifeSpread=55,
                numparticles=[[0.6 r1]],
                particleSpeed=0.3,
                particleSpeedSpread=1.5,
                particleSize=7.5,
                particleSizeSpread=10.5,
                directional=0,
            },
        },
    },
}



return definitions