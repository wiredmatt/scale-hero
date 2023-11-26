---@enum TileType
TileType = {
  ground = 0,
  wall = 1,
}

---@enum AnimationType
AnimationType = {
  loop = 0,
  once = 1,
}

---@enum ActionAnimation
ActionAnimation = {
  idle_base = "idle_base",
  hit_right = "hit_right",
  hit_left = "hit_left",
  hit_down = "hit_down",
  hit_up = "hit_up",
  hit_down_right = "hit_down_right",
  hit_down_left = "hit_down_left",
  hit_up_left = "hit_up_left",
  hit_up_right = "hit_up_right",
  get_hit_x = "get_hit_x",
  get_hit_y = "get_hit_y"
}

---@enum AtlasKey
SpriteName = {
  -- start ground tiles
  ground_base_1 = "ground_base_1",
  ground_base_2 = "ground_base_2",
  ground_border_1 = "ground_border_1",
  ground_border_2 = "ground_border_2",
  ground_corner = "ground_corner",
  ground_border_end = "ground_border_end",
  ground_spike = "ground_spike",
  ground_debris = "ground_debris",
  -- end ground tiles


  -- start characters
  hero_knight = "hero_knight",
  hero_bob = "hero_bob",



  enemy_cacti = "enemy_cacti",
  enemy_bat = "enemy_bat",
  enemy_ghost = "enemy_ghost",
  -- end characters

  -- start indicators
  indicator_base = "indicator_base"
  -- end indicators

}
