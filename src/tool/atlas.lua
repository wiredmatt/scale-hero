local iffy = require 'lib.iffy'

function Export()
  -- load atlas
  -- iffy.newImage("main_atlas", "assets/tiny_dungeon.png")
  -- -- load tiles
  -- iffy.newSprite("main_atlas", "ground_base_1", 0, 64, 16, 16)
  -- iffy.newSprite("main_atlas", "ground_base_2", 16, 64, 16, 16)
  -- iffy.newSprite("main_atlas", "ground_border_1", 32, 64, 16, 16)
  -- iffy.newSprite("main_atlas", "ground_border_2", 48, 64, 16, 16)
  -- iffy.newSprite("main_atlas", "ground_corner", 64, 64, 16, 16)
  -- iffy.newSprite("main_atlas", "ground_border_end", 80, 64, 16, 16)
  -- iffy.newSprite("main_atlas", "ground_spike", 96, 48, 16, 16)
  -- iffy.newSprite("main_atlas", "ground_debris", 112, 48, 16, 16)


  -- -- generates assets/main_atlas.xml
  -- iffy.exportXML("main_atlas", "assets")
end

function Load()
  iffy.newAtlas("main_atlas", "assets/tiny_dungeon.png", "assets/main_atlas.xml")
end

local Atlas = {
  Export = Export,
  Load = Load,
  lib = iffy
}

return Atlas
