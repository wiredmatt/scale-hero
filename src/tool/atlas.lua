local iffy = require 'lib.iffy'
require("src.game.enum")

function Export()
  -- load atlas
  iffy.newImage("main_atlas", "assets/tiny_dungeon.png")

  -- load tiles
  iffy.newSprite("main_atlas", SpriteName.ground_base_1, 0, 64, 16, 16)
  iffy.newSprite("main_atlas", SpriteName.ground_base_2, 16, 64, 16, 16)
  iffy.newSprite("main_atlas", SpriteName.ground_border_1, 32, 64, 16, 16)
  iffy.newSprite("main_atlas", SpriteName.ground_border_2, 48, 64, 16, 16)
  iffy.newSprite("main_atlas", SpriteName.ground_corner, 64, 64, 16, 16)
  iffy.newSprite("main_atlas", SpriteName.ground_border_end, 80, 64, 16, 16)
  iffy.newSprite("main_atlas", SpriteName.ground_spike, 96, 48, 16, 16)
  iffy.newSprite("main_atlas", SpriteName.ground_debris, 112, 48, 16, 16)

  -- load characters
  iffy.newSprite("main_atlas", SpriteName.hero_bob, 16, 112, 16, 16)
  iffy.newSprite("main_atlas", SpriteName.hero_knight, 0, 128, 16, 16)


  -- load enemies
  iffy.newSprite("main_atlas", SpriteName.enemy_cacti, 0, 144, 16, 16)
  iffy.newSprite("main_atlas", SpriteName.enemy_bat, 0, 160, 16, 16)
  iffy.newSprite("main_atlas", SpriteName.enemy_ghost, 16, 160, 16, 16)

  -- load indicators
  iffy.newSprite("main_atlas", SpriteName.indicator_base, 0, 80, 16, 16)



  -- generates assets/main_atlas.xml
  -- NOTE: Comment this line when making the build
  -- iffy.exportXML("main_atlas", "assets")
end

function Load()
  iffy.newAtlas("main_atlas", "assets/tiny_dungeon.png", "assets/main_atlas.xml")
end

local Atlas = {
  Export = Export,
  Load = Load,
  lib = iffy,
  ground_keys = { -- only ground
    SpriteName.ground_base_1,
    SpriteName.ground_base_2,
  },
  character_keys = { -- enemies and heroes
    SpriteName.hero_knight,
    SpriteName.hero_bob,

    SpriteName.enemy_cacti,
    SpriteName.enemy_bat,
    SpriteName.enemy_ghost,
  },
  hero_keys = { -- only heroes
    SpriteName.hero_knight,
    SpriteName.hero_bob,
  },
  enemy_keys = { -- only enemies
    SpriteName.enemy_cacti,
    SpriteName.enemy_bat,
    SpriteName.enemy_ghost,
  },
}

return Atlas
