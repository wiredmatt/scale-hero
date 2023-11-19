# Scale Hero

My submission for [Game Off 2023](https://itch.io/jam/game-off-2023)

## Tech

- [Love2D](love2d.org/) - I don't like high level game engines, but I also don't like having to write *everything* from scratch, so this framework proved to be actually pretty good for anything you could think of, even if it says it's only for 2D, there's a pretty well developed 3D framework which based off it, [LOVR](https://github.com/bjornbytes/lovr). So anything you learn to do with Love you can make with Lovr.
- [iffy](./lib/iffy.lua) - Slightly modified version of [iffy](https://github.com/besnoi/iffy). Very nice abstractions to work with sprites and quads in spritesheets.
- [object](./lib/object.lua) - Slightly modified version of [classic](https://github.com/rxi/classic). OOP for Lua! Really not necessary since you can totally make OOP with Lua tables and EmmyLua annotations, but this library utilities and its mixin implementation  are super useful.
- [pprint.lua](https://github.com/jagt/pprint.lua) - Helps printing stuff to stdout! The default print function lacks the ability to properly print tables and nested tables. See my overwrite [here](./src/__setup.lua#L10)

## TODO

- [ ] Implement grid-based spatial partitioning for `level:mousemoved` in `level.lua`
- [ ] Update highlighted tile when re-scaling? probably not necessary unless scaling can happen while the player is doing something