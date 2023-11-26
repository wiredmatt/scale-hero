local iffy = require 'lib.iffy'
require("src.game.enum")

function Export()
  -- load atlas
  iffy.newImage("main_atlas", "assets/tiny_dungeon.png")

  -- load tiles
  iffy.newSprite("main_atlas", SPRITE_NAMES.ground_base_1, 0, 64, 16, 16)
  iffy.newSprite("main_atlas", SPRITE_NAMES.ground_base_2, 16, 64, 16, 16)
  iffy.newSprite("main_atlas", SPRITE_NAMES.ground_border_1, 32, 64, 16, 16)
  iffy.newSprite("main_atlas", SPRITE_NAMES.ground_border_2, 48, 64, 16, 16)
  iffy.newSprite("main_atlas", SPRITE_NAMES.ground_corner, 64, 64, 16, 16)
  iffy.newSprite("main_atlas", SPRITE_NAMES.ground_border_end, 80, 64, 16, 16)
  iffy.newSprite("main_atlas", SPRITE_NAMES.ground_spike, 96, 48, 16, 16)
  iffy.newSprite("main_atlas", SPRITE_NAMES.ground_debris, 112, 48, 16, 16)

  -- load characters
  iffy.newSprite("main_atlas", SPRITE_NAMES.hero_bob, 16, 112, 16, 16)
  iffy.newSprite("main_atlas", SPRITE_NAMES.hero_knight, 0, 128, 16, 16)


  -- load enemies
  iffy.newSprite("main_atlas", SPRITE_NAMES.enemy_cacti, 0, 144, 16, 16)
  iffy.newSprite("main_atlas", SPRITE_NAMES.enemy_bat, 0, 160, 16, 16)
  iffy.newSprite("main_atlas", SPRITE_NAMES.enemy_ghost, 16, 160, 16, 16)

  -- load indicators
  iffy.newSprite("main_atlas", SPRITE_NAMES.indicator_base, 0, 80, 16, 16)



  -- generates assets/main_atlas.xml
  iffy.exportXML("main_atlas", "assets")
end

function Load()
  iffy.newAtlas("main_atlas", "assets/tiny_dungeon.png", "assets/main_atlas.xml")
end

local Atlas = {
  Export = Export,
  Load = Load,
  lib = iffy,
  ground_keys = { -- only ground
    SPRITE_NAMES.ground_base_1,
    SPRITE_NAMES.ground_base_2,
  },
  character_keys = { -- enemies and heroes
    SPRITE_NAMES.hero_knight,
    SPRITE_NAMES.hero_bob,

    SPRITE_NAMES.enemy_cacti,
    SPRITE_NAMES.enemy_bat,
    SPRITE_NAMES.enemy_ghost,
  },
  hero_keys = { -- only heroes
    SPRITE_NAMES.hero_knight,
    SPRITE_NAMES.hero_bob,
  },
  enemy_keys = { -- only enemies
    SPRITE_NAMES.enemy_cacti,
    SPRITE_NAMES.enemy_bat,
    SPRITE_NAMES.enemy_ghost,
  },
}

return Atlas
