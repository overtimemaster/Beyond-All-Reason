-- UI Effects

return {
 ["radarpulse_t1_slow"] = {

    radarpulse = {
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = false,
      underwater         = false,
      properties = {
        colormap           = [[0 0 0 0.01    0.14 0.28 0.05 0.022    0.03 0.30 0.03 0.015    0 0 0 0.01]],
        dir                = [[0, 1, 0]],
        --gravity            = [[0.0, -0.4, 0.0]],
        frontoffset        = 0,
        fronttexture       = [[radarfx1]],
        length             = 45,
        sidetexture        = [[none]],
        size               = 12,
        sizegrowth         = 1.2,
        ttl                = 40,
        pos                = [[0, 0, 0]],
        rotParams          = [[-48, 32, -180 r360]],
        useairlos          = false,
      },
    },
  },

  ["radarpulse_t1"] = {

    radarpulse = {
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        colormap           = [[0.14 0.28 0.05 0.022    0.03 0.30 0.03 0.015    0 0 0 0.01]],
        dir                = [[0, 1, 0]],
        --gravity            = [[0.0, -0.4, 0.0]],
        frontoffset        = 0,
        fronttexture       = [[radarfx1]],
        length             = 45,
        sidetexture        = [[none]],
        size               = 16,
        sizegrowth         = 0.3,
        ttl                = 12,
        pos                = [[0, 5, 0]],
        rotParams          = [[-48, 32, -180 r360]],
        useairlos          = false,
      },
    },
  },

  ["radarpulse_t1_short"] = {

    radarpulse = {
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = false,
      underwater         = false,
      properties = {
        colormap           = [[0 0 0 0.01   0.03 0.30 0.03 0.01    0 0 0 0.01]],
        dir                = [[0, 1, 0]],
        --gravity            = [[0.0, -0.4, 0.0]],
        frontoffset        = 0,
        fronttexture       = [[radarfx1]],
        length             = 45,
        sidetexture        = [[none]],
        size               = 32,
        sizegrowth         = 1.0,
        ttl                = 8,
        pos                = [[0, 0, 0]],
        rotParams          = [[-48, 32, -180 r360]],
        useairlos          = false,
      },
    },
  },

-- Don't use _ground since groundflash in it discards airlos=false 
  -- ["radarpulse_t2_ground"] = {

  --   groundflash_small = {
  --     class              = [[CSimpleGroundFlash]],
  --     count              = 1,
  --     air                = true,
  --     ground             = true,
  --     water              = false,
  --     underwater         = false,
  --     properties = {
  --       colormap           = [[0 0 0 0.01    0.21 0.71 0.21 0.6    0.21 0.71 0.21 0.2    0 0 0 0.01]],
  --       size               = 14,
  --       sizegrowth         = 0.7,
  --       ttl                = 30,
  --       texture            = [[radarfx2ground]],
  --       useairlos          = false,
  --     },
  --   },

    -- radarpulse = {
    --   class              = [[CBitmapMuzzleFlame]],
    --   count              = 1,
    --   air                = true,
    --   ground             = true,
    --   water              = false,
    --   underwater         = false,
    --   properties = {
    --     colormap           = [[0 0 0 0.01    0.14 0.28 0.05 0.022    0.03 0.30 0.03 0.015    0 0 0 0.01]],
    --     dir                = [[0, 1, 0]],
    --     --gravity            = [[0.0, -0.4, 0.0]],
    --     frontoffset        = 0,
    --     fronttexture       = [[radarfx2]],
    --     length             = 45,
    --     sidetexture        = [[none]],
    --     size               = 10,
    --     sizegrowth         = 1.8,
    --     ttl                = 20,
    --     pos                = [[0, -10, 0]],
    --   },
    -- },
  -- },

  ["radarpulse_t2"] = {

    radarpulse = {
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        colormap           = [[0 0 0 0.01    0.05 0.30 0.03 0.01   0 0 0 0.01]],
        dir                = [[0, 1, 0]],
        --gravity            = [[0.0, -0.4, 0.0]],
        frontoffset        = 0,
        fronttexture       = [[radarfx2]],
        length             = 45,
        sidetexture        = [[none]],
        size               = 20,
        sizegrowth         = 0.2,
        ttl                = 32,
        pos                = [[0, 0, 0]],
        rotParams          = [[-48, 32, -180 r360]],
        useairlos          = false,
      },
    },
  },

  ["radarpulse_t2_slow"] = {

    radarpulse = {
      class              = [[CBitmapMuzzleFlame]],
      count              = 1,
      air                = true,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        colormap           = [[0 0 0 0.01    0.14 0.28 0.05 0.022    0.03 0.30 0.03 0.015    0 0 0 0.01]],
        dir                = [[0, 1, 0]],
        --gravity            = [[0.0, -0.4, 0.0]],
        frontoffset        = 0,
        fronttexture       = [[radarfx2]],
        length             = 45,
        sidetexture        = [[none]],
        size               = 15,
        sizegrowth         = 1.0,
        ttl                = 40,
        pos                = [[0, 0, 0]],
        rotParams          = [[-48, 32, -180 r360]],
        useairlos          = false,
      },
    },
  },

  -- ["testceg-dir"] = {

  --   waterexplosion = {
  --     air                = true,
  --     class              = [[CSimpleParticleSystem]],
  --     count              = 1,
  --     ground             = true,
  --     underwater         = 1,
  --     water              = true,
  --     properties = {
  --       airdrag            = 0.97,
  --       colormap           = [[0.6 0.6 0.63 0.009   0.40 0.4 0.43 0.013   0.1 0.1 0.1 0.006   0 0 0 0.01]],
  --       directional        = true,
  --       emitrot            = 25,
  --       emitrotspread      = [[20 r-20 r20]],
  --       emitvector         = [[0,1,0]],
  --       gravity            = [[0, -0.1, 0]],
  --       numparticles       = 11,
  --       particlelife       = 120,
  --       particlelifespread = 42,
  --       particlesize       = 22,
  --       particlesizespread = 55,
  --       particlespeed      = [[6 i0.95]],
  --       particlespeedspread = 7,
  --       rotParams          = [[-60 r120, -30 r60, -180 r360]],
  --       pos                = [[0, 18, 0]],
  --       sizegrowth         = -0.21,
  --       sizemod            = 1.0,
  --       texture            = [[explowater]],
  --       useairlos          = true,
  --       alwaysvisible      = true,
  --     },
  --   },
  -- },
  -- ["testceg-nodir"] = {

  --   waterexplosion = {
  --     air                = true,
  --     class              = [[CSimpleParticleSystem]],
  --     count              = 1,
  --     ground             = true,
  --     underwater         = 1,
  --     water              = true,
  --     properties = {
  --       airdrag            = 0.97,
  --       colormap           = [[0.6 0.6 0.63 0.009   0.40 0.4 0.43 0.013   0.1 0.1 0.1 0.006   0 0 0 0.01]],
  --       directional        = false,
  --       emitrot            = 25,
  --       emitrotspread      = [[20 r-20 r20]],
  --       emitvector         = [[0,1,0]],
  --       gravity            = [[0, -0.1, 0]],
  --       numparticles       = 11,
  --       particlelife       = 120,
  --       particlelifespread = 42,
  --       particlesize       = 22,
  --       particlesizespread = 55,
  --       particlespeed      = [[6 i0.95]],
  --       particlespeedspread = 7,
  --       rotParams          = [[-60.0 r120, 0.0, 0.0]],
  --       pos                = [[0, 18, 0]],
  --       sizegrowth         = -0.21,
  --       sizemod            = 1.0,
  --       texture            = [[explowater]],
  --       useairlos          = true,
  --       alwaysvisible      = true,
  --     },
  --   },
  -- },
  -- ["testceg-muzzle"] = {

  --   spawnbeam = {
  --     air                = true,
  --     class              = [[CBitmapMuzzleFlame]],
  --     count              = 1,
  --     ground             = true,
  --     underwater         = 1,
  --     water              = true,
  --     properties = {
  --       colormap           = [[0.88 0.65 0.10 0.20   0.85 0.85 0.24 0.14   0.78 0.50 0.15 0.08   0.58 0.30 0.08 0.06   0 0 0 0.01]],
  --       dir                = [[0, 1, 0]],
  --       --gravity            = [[0.0, 0.1, 0.0]],
  --       frontoffset        = 0,
  --       fronttexture       = [[blastwave]],
  --       length             = 240,
  --       sidetexture        = [[lightning]],
  --       size               = 50,
  --       sizegrowth         = 0.8,
  --       ttl                = 100,
  --       pos                = [[0, 6, 0]],
  --     },
  --   },
  -- },
  -- ["testceg-muzzlex1"] = {

  --   spawnbeam = {
  --     air                = true,
  --     class              = [[CBitmapMuzzleFlame]],
  --     count              = 1,
  --     ground             = true,
  --     underwater         = 1,
  --     water              = true,
  --     properties = {
  --       colormap           = [[0.88 0.65 0.10 0.20   0.85 0.85 0.24 0.14   0.78 0.50 0.15 0.08   0.58 0.30 0.08 0.06   0 0 0 0.01]],
  --       dir                = [[1, 0, 0]],
  --       --gravity            = [[0.0, 0.1, 0.0]],
  --       frontoffset        = 0,
  --       fronttexture       = [[blastwave]],
  --       length             = 240,
  --       sidetexture        = [[lightning]],
  --       size               = 50,
  --       sizegrowth         = 0.8,
  --       ttl                = 100,
  --       pos                = [[0, 6, 0]],
  --     },
  --   },
  -- },
  -- ["testceg-muzzlex-1"] = {

  --   spawnbeam = {
  --     air                = true,
  --     class              = [[CBitmapMuzzleFlame]],
  --     count              = 1,
  --     ground             = true,
  --     underwater         = 1,
  --     water              = true,
  --     properties = {
  --       colormap           = [[0.88 0.65 0.10 0.20   0.85 0.85 0.24 0.14   0.78 0.50 0.15 0.08   0.58 0.30 0.08 0.06   0 0 0 0.01]],
  --       dir                = [[-1, 0, 0]],
  --       --gravity            = [[0.0, 0.1, 0.0]],
  --       frontoffset        = 0,
  --       fronttexture       = [[blastwave]],
  --       length             = 240,
  --       sidetexture        = [[lightning]],
  --       size               = 50,
  --       sizegrowth         = 0.8,
  --       ttl                = 100,
  --       pos                = [[0, 6, 0]],
  --     },
  --   },
  -- },
  -- ["testceg-muzzlez1"] = {

  --   spawnbeam = {
  --     air                = true,
  --     class              = [[CBitmapMuzzleFlame]],
  --     count              = 1,
  --     ground             = true,
  --     underwater         = 1,
  --     water              = true,
  --     properties = {
  --       colormap           = [[0.88 0.65 0.10 0.20   0.85 0.85 0.24 0.14   0.78 0.50 0.15 0.08   0.58 0.30 0.08 0.06   0 0 0 0.01]],
  --       dir                = [[0, 0, 1]],
  --       --gravity            = [[0.0, 0.1, 0.0]],
  --       frontoffset        = 0,
  --       fronttexture       = [[blastwave]],
  --       length             = 240,
  --       sidetexture        = [[lightning]],
  --       size               = 50,
  --       sizegrowth         = 0.8,
  --       ttl                = 100,
  --       pos                = [[0, 6, 0]],
  --     },
  --   },
  -- },
  -- ["testceg-muzzlez-1"] = {

  --   spawnbeam = {
  --     air                = true,
  --     class              = [[CBitmapMuzzleFlame]],
  --     count              = 1,
  --     ground             = true,
  --     underwater         = 1,
  --     water              = true,
  --     properties = {
  --       colormap           = [[0.88 0.65 0.10 0.20   0.85 0.85 0.24 0.14   0.78 0.50 0.15 0.08   0.58 0.30 0.08 0.06   0 0 0 0.01]],
  --       dir                = [[0, 0, -1]],
  --       --gravity            = [[0.0, 0.1, 0.0]],
  --       frontoffset        = 0,
  --       fronttexture       = [[blastwave]],
  --       length             = 240,
  --       sidetexture        = [[lightning]],
  --       size               = 50,
  --       sizegrowth         = 0.8,
  --       ttl                = 100,
  --       pos                = [[0, 6, 0]],
  --     },
  --   },
  -- },
}