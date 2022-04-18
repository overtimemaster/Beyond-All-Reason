-- chickenunitexplosion-small-red
-- chickenunitexplosion-medium-red
-- chickenunitexplosion-large-red

return {
  ["chickenunitexplosion-tiny-red"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 6,
        heatfalloff        = 1.35,
        maxheat            = 18,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 0.3,
        sizegrowth         = 1,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare-chickens]],
      },
    },

    -- put this next to groundflash
    --explosionwave = {
    --  air                = true,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  water              = true,
    --  underwater         = true,
    --  properties = {
    --    airdrag            = 0.87,
    --    alwaysvisible      = true,
    --    colormap           = [[1 0 0 0.05	0 0 0 0.0]], -- same as groundflash colors
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = 5,
    --    emitvector         = [[0, 0, 0]],
    --    gravity            = [[0, 0, 0]],
    --    numparticles       = 1,
    --    particlelife       = [[20]], -- same as groundflash ttl
    --    particlelifespread = 0,
    --    particlesize       = 2, -- groundflash flashsize 25 = 1, so if flashsize is 200, particlesize here would be 8
    --    particlesizespread = 1,
    --    particlespeed      = [[8]],
    --    particlespeedspread = 6,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 3, -- same as groundflash circlegrowth
    --    sizemod            = 1.0,
    --    texture            = [[bloodblast]],
    --  },
    --},

    groundflash = {
      air                = true,
      alwaysvisible      = true,
      flashalpha         = 0.25,
      flashsize          = 10,
      ground             = true,
      ttl                = 10,
      water              = true,
      underwater         = true,
      color = {
        [1]  = 1,
        [2]  = 0,
        [3]  = 0,
      },
    },
    kickedupdirt = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.1 0.05 0.02 0.15	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 3,
        particlelife       = 2,
        particlelifespread = 20,
        particlesize       = 0.2,
        particlesizespread = 0.15,
        particlespeed      = 0.1,
        particlespeedspread = 0.4,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke-chickens]],
      },
    },
    kickedupwater = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 4,
        particlelife       = 2,
        particlelifespread = 23,
        particlesize       = 0.4,
        particlesizespread = 0.3,
        particlespeed      = 1.5,
        particlespeedspread = 4.25,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[wake-chickens]],
      },
    },
    orangeexplosionspikes = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[0.7 0.8 0.9 0.012   0.9 0.5 0.2 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 1,
        particlelife       = 6,
        particlelifespread = 0,
        particlesize       = 0.33,
        particlesizespread = 0.2,
        particlespeed      = 0.2,
        particlespeedspread = 0.4,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 1,
        texture            = [[flashside2-chickens]],
        useairlos          = false,
      },
    },
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 2,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.1,
        maxheat            = 24,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 0.2,
        sizegrowth         = 1.9,
        speed              = [[0, 1 0, 0]],
        texture            = [[bloodblast]],
      },
    },
  },

  ["chickenunitexplosion-small-red"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 8,
        heatfalloff        = 1.3,
        maxheat            = 18,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 1,
        sizegrowth         = 5,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare-chickens]],
      },
    },

    -- put this next to groundflash
    --explosionwave = {
    --  air                = true,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  water              = true,
    --  underwater         = true,
    --  properties = {
    --    airdrag            = 0.87,
    --    alwaysvisible      = true,
    --    colormap           = [[1 0 0 0.05	0 0 0 0.0]], -- same as groundflash colors
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = 5,
    --    emitvector         = [[0, 0, 0]],
    --    gravity            = [[0, 0, 0]],
    --    numparticles       = 1,
    --    particlelife       = [[20]], -- same as groundflash ttl
    --    particlelifespread = 0,
    --    particlesize       = 4, -- groundflash flashsize 25 = 1, so if flashsize is 200, particlesize here would be 8
    --    particlesizespread = 1,
    --    particlespeed      = [[8]],
    --    particlespeedspread = 6,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 6, -- same as groundflash circlegrowth
    --    sizemod            = 1.0,
    --    texture            = [[bloodblast]],
    --  },
    --},

    groundflash = {
      air                = true,
      alwaysvisible      = true,
      flashalpha         = 0.3,
      flashsize          = 25,
      ground             = true,
      ttl                = 13,
      water              = true,
      underwater         = true,
      color = {
        [1]  = 1,
        [2]  = 0,
        [3]  = 0,
      },
    },
    kickedupdirt = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.1 0.08 0.04 0.14	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 5,
        particlelife       = 3,
        particlelifespread = 26,
        particlesize       = 2,
        particlesizespread = 1,
        particlespeed      = 0.5,
        particlespeedspread = 1.7,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke-chickens]],
      },
    },
    kickedupwater = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 5,
        particlelife       = 2,
        particlelifespread = 30,
        particlesize       = 1.5,
        particlesizespread = 1,
        particlespeed      = 2,
        particlespeedspread = 5.5,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[wake-chickens]],
      },
    },
    orangeexplosionspikes = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[0.7 0.8 0.9 0.018   0.9 0.5 0.2 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 3,
        particlelife       = 8,
        particlelifespread = 0,
        particlesize       = 0.2,
        particlesizespread = 0.1,
        particlespeed      = 0.2,
        particlespeedspread = 1.5,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 1,
        texture            = [[flashside2-chickens]],
        useairlos          = false,
      },
    },
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 2,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 30,
        heatfalloff        = 2.6,
        maxheat            = 25,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 0.4,
        sizegrowth         = 3.5,
        speed              = [[0, 1 0, 0]],
        texture            = [[bloodblast]],
      },
    },
  },


  ["chickenunitexplosion-medium-red"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.35,
        maxheat            = 18,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 1,
        sizegrowth         = 3,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare-chickens]],
      },
    },

    -- put this next to groundflash
    --explosionwave = {
    --  air                = true,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  water              = true,
    --  underwater         = true,
    --  properties = {
    --    airdrag            = 0.87,
    --    alwaysvisible      = true,
    --    colormap           = [[1 0 0 0.05	0 0 0 0.0]], -- same as groundflash colors
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = 5,
    --    emitvector         = [[0, 0, 0]],
    --    gravity            = [[0, 0, 0]],
    --    numparticles       = 1,
    --    particlelife       = [[20]], -- same as groundflash ttl
    --    particlelifespread = 0,
    --    particlesize       = 2, -- groundflash flashsize 25 = 1, so if flashsize is 200, particlesize here would be 8
    --    particlesizespread = 1,
    --    particlespeed      = [[8]],
    --    particlespeedspread = 6,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 3, -- same as groundflash circlegrowth
    --    sizemod            = 1.0,
    --    texture            = [[bloodblast]],
    --  },
    --},

    groundflash = {
      air                = true,
      alwaysvisible      = true,
      flashalpha         = 0.55,
      flashsize          = 55,
      ground             = true,
      ttl                = 20,
      water              = true,
      underwater         = true,
      color = {
        [1]  = 1,
        [2]  = 0,
        [3]  = 0,
      },
    },
    kickedupdirt = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.25 0.20 0.10 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 10,
        particlelife       = 2,
        particlelifespread = 26,
        particlesize       = 1.5,
        particlesizespread = 1,
        particlespeed      = 1.25,
        particlespeedspread = 4.25,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke-chickens]],
      },
    },
    kickedupwater = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 10,
        particlelife       = 2,
        particlelifespread = 30,
        particlesize       = 1.25,
        particlesizespread = 1,
        particlespeed      = 1.5,
        particlespeedspread = 4.25,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[wake-chickens]],
      },
    },
    orangeexplosionspikes = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[0.7 0.8 0.9 0.025   0.9 0.5 0.2 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 5,
        particlelife       = 8,
        particlelifespread = 0,
        particlesize       = 1,
        particlesizespread = 2,
        particlespeed      = 1,
        particlespeedspread = 3.5,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 1,
        texture            = [[flashside2-chickens]],
        useairlos          = false,
      },
    },
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 2,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 15,
        heatfalloff        = 1.4,
        maxheat            = 24,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 1.25,
        sizegrowth         = 5,
        speed              = [[0, 1 0, 0]],
        texture            = [[bloodblast]],
      },
    },
  },

  ["chickenunitexplosion-large-red"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 1,
        sizegrowth         = 9.5,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare-chickens]],
      },
    },

	-- put this next to groundflash
	--explosionwave = {
    --  air                = true,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  water              = true,
	--  underwater         = true,
    --  properties = {
    --    airdrag            = 0.87,
    --    alwaysvisible      = true,
    --    colormap           = [[1 0 0 0.05	0 0 0 0.0]], -- same as groundflash colors
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = 5,
    --    emitvector         = [[0, 0, 0]],
    --    gravity            = [[0, 0, 0]],
    --    numparticles       = 1,
    --    particlelife       = [[20]], -- same as groundflash ttl
    --    particlelifespread = 0,
    --    particlesize       = 6, -- groundflash flashsize 25 = 1, so if flashsize is 200, particlesize here would be 8
    --    particlesizespread = 1,
    --    particlespeed      = [[8]],
    --    particlespeedspread = 6,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 12, -- same as groundflash circlegrowth
    --    sizemod            = 1.0,
    --    texture            = [[bloodblast]],
    --  },
    --},

    groundflash = {
      air                = true,
      alwaysvisible      = true,
      flashalpha         = 0.6,
      flashsize          = 125,
      ground             = true,
      ttl                = 20,
      water              = true,
	  underwater         = true,
      color = {
        [1]  = 1,
        [2]  = 0,
        [3]  = 0,
      },
    },
    kickedupdirt = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.25 0.20 0.10 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 20,
        particlelife       = 2,
        particlelifespread = 30,
        particlesize       = 2,
        particlesizespread = 2,
        particlespeed      = 2,
        particlespeedspread = 8,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke-chickens]],
      },
    },
    kickedupwater = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
	  underwater         = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.7 0.7 0.9 0.35	0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 20,
        particlelife       = 2,
        particlelifespread = 30,
        particlesize       = 2,
        particlesizespread = 2,
        particlespeed      = 2.5,
        particlespeedspread = 8,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[wake-chickens]],
      },
    },
    orangeexplosionspikes = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        airdrag            = 0.8,
        alwaysvisible      = true,
        colormap           = [[0.7 0.8 0.9 0.03   0.9 0.5 0.2 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 10,
        particlelife       = 8,
        particlelifespread = 0,
        particlesize       = 2.5,
        particlesizespread = 6,
        particlespeed      = 3,
        particlespeedspread = 4,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1,
        sizemod            = 1,
        texture            = [[flashside2-chickens]],
        useairlos          = false,
      },
    },
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 2,
      ground             = true,
      water              = true,
	  underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.2,
        maxheat            = 20,
        pos                = [[r-2 r2, 5, r-2 r2]],
        size               = 1,
        sizegrowth         = 12,
        speed              = [[0, 1 0, 0]],
        texture            = [[bloodblast]],
      },
    },
  },

  ["chickenunitexplosion-huge-red"] = {
    centerflare = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true,
    underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 1.3,
        maxheat            = 20,
        pos                = [[r-2 r2, 5, r-2 r2]],
        rotParams          = [[-50 r100, -25 r50, -180 r360]],
        size               = 3.2,
        sizegrowth         = 9.5,
        speed              = [[0, 1 0, 0]],
        texture            = [[flare-chickens]],
      },
    },

splashes = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      --unit               = false,
      properties = {
        airdrag            = 0.93,
        colormap           = [[1 1 1 1   0.9 0.9 0.9 1   0 0 0 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 80,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.14, 0]],
        numparticles       = [[15 r10]],
        particlelife       = 15,
        particlelifespread = 12.5,
        particlesize       = 12,
        particlesizespread = 19,
        particlespeed      = 3.5,
        particlespeedspread = 7,
        rotParams          = [[-50 r100, -25 r50, 150 r60]],
        pos                = [[0, 1, 0]],
        sizegrowth         = -0.1,
        sizemod            = 1,
        texture            = [[blooddrop2]],
        alwaysvisible      = true,
        drawOrder          = 1,
      },
    },

    centersplatsh = {
      air                = true,
      class              = [[heatcloud]],
      count              = 1,
      ground             = true,
      water              = true, 
    underwater         = true,
      properties = {
        heat               = 15,
        heatfalloff        = 1.1,
        maxheat            = 20,
        pos                = [[r-2 r2, 0, r-2 r2]],
        rotParams          = [[-50 r100, -25 r50, -180 r360]],
        size               = 2.6,
        sizegrowth         = 6,
        speed              = [[0, 1, 0]],
        texture            = [[bloodcentersplatsh]],
        drawOrder          = 1,
      },
    },

  -- put this next to groundflash
  --explosionwave = {
    --  air                = true,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 1,
    --  ground             = true,
    --  water              = true,
  --  underwater         = true,
    --  properties = {
    --    airdrag            = 0.87,
    --    alwaysvisible      = true,
    --    colormap           = [[1 0 0 0.05 0 0 0 0.0]], -- same as groundflash colors
    --    directional        = false,
    --    emitrot            = 90,
    --    emitrotspread      = 5,
    --    emitvector         = [[0, 0, 0]],
    --    gravity            = [[0, 0, 0]],
    --    numparticles       = 1,
    --    particlelife       = [[20]], -- same as groundflash ttl
    --    particlelifespread = 0,
    --    particlesize       = 6, -- groundflash flashsize 25 = 1, so if flashsize is 200, particlesize here would be 8
    --    particlesizespread = 1,
    --    particlespeed      = [[8]],
    --    particlespeedspread = 6,
    --    pos                = [[0, 1, 0]],
    --    sizegrowth         = 12, -- same as groundflash circlegrowth
    --    sizemod            = 1.0,
    --    texture            = [[bloodblast]],
    --  },
    --},

    groundflash_blood = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = false,
      underwater         = false,
      properties = {
        colormap           = [[0.64 0 0.01 0.55   0 0 0 0.01]],
        size               = 50,
        sizegrowth         = 5,
        ttl                = 17,
        texture            = [[groundflash]],
        --alwaysvisible      = true,
      },
    },
    kickedupdirt = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.25 0.20 0.10 0.35  0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 20,
        particlelife       = 3,
        particlelifespread = 35,
        particlesize       = 2.8,
        particlesizespread = 2.4,
        particlespeed      = 2.4,
        particlespeedspread = 9,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.5,
        sizemod            = 1.0,
        texture            = [[bigexplosmoke-chickens]],
      },
    },
    kickedupwater = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
    underwater         = true,
      properties = {
        airdrag            = 0.87,
        alwaysvisible      = true,
        colormap           = [[0.7 0.7 0.9 0.35 0 0 0 0.0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.1, 0]],
        numparticles       = 20,
        particlelife       = 2,
        particlelifespread = 30,
        particlesize       = 2,
        particlesizespread = 2,
        particlespeed      = 2.5,
        particlespeedspread = 8,
        pos                = [[0, 1, 0]],
        sizegrowth         = 0.3,
        sizemod            = 1.0,
        texture            = [[wake-chickens]],
      },
    },
    orangeexplosionspikes = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 2,
      ground             = true,
      water              = true,
    underwater         = true,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0.96 0.11 0.13 0.15   0.16 0 0 0.05]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 32,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.01, 0]],
        numparticles       = 9,
        particlelife       = 13,
        particlelifespread = 8,
        particlesize       = 5,
        particlesizespread = 10,
        particlespeed      = 3.4,
        particlespeedspread = 4.5,
        pos                = [[0, 2, 0]],
        sizegrowth         = 1.7,
        sizemod            = 1,
        texture            = [[flashside3]],
        useairlos          = false,
      },
    },
    outerflash = {
      air                = true,
      class              = [[heatcloud]],
      count              = 4,
      ground             = true,
      water              = true,
    underwater         = true,
      properties = {
        alwaysvisible      = true,
        heat               = 10,
        heatfalloff        = 0.9,
        maxheat            = 20,
        pos                = [[r-2 r2, 5, r-2 r2]],
        rotParams          = [[-50 r100, -25 r50, -180 r360]],
        size               = 24.3,
        sizegrowth         = 4,
        speed              = [[0, 1 0, 0]],
        texture            = [[bloodblast]],
      },
    },
    bloodblast = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 2,
      ground             = true,
      water              = true,
      underwater         = true,
      --unit               = false,
      properties = {
        airdrag            = 0.92,
        colormap           = [[1 1 1 1   1 1 1 0.8   1 1 1 0.9  0 0 0 0.01]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 120,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.01, 0]],
        numparticles       = 2,
        particlelife       = 18,
        particlelifespread = 10,
        particlesize       = 20,
        particlesizespread = 18,
        particlespeed      = 0.1,
        particlespeedspread = 0.1,
        rotParams          = [[-50 r100, -25 r50, -180 r360]],
        pos                = [[-10 r20, 0 r30, -10 r20]],
        sizegrowth         = 2.9,
        sizemod            = 0.99,
        texture            = [[bloodblast2]],
        alwaysvisible      = true,
      },
    },
    blood_sparks = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true, 
    underwater         = true,
      properties = {
        airdrag            = 0.96,
        colormap           = [[1 1 1 0.8   0.9 0.9 0.9 1  1 1 1 1   0 0 0 0.01]],
        directional        = true,
        emitrot            = 15,
        emitrotspread      = 35,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.12, 0]],
        numparticles       = [[2 r8]],
        particlelife       = 14,
        particlelifespread = 22,
        particlesize       = 4.4,
        particlesizespread = 7.5,
        particlespeed      = 3.5,
        particlespeedspread = 7.5,
        rotParams          = [[-60 r120, -30 r60, 180]],
        pos                = [[0, 4, 0]],
        sizegrowth         = 0.27,
        sizemod            = 0.96,
        texture            = [[bloodspark2]],
        useairlos          = false,
        drawOrder          = 2,
      },
    },
  },

}
