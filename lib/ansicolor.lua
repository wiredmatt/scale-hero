-- ansicolor.lua

--------------------------------------------------------------------------------

-- A super-simple way to make ansicolored text output in Lua.
-- To use, simply print out things from this module, then print out some text.
--
-- Example:
-- print(ansicolor.bg.green .. ansicolor.fg.RED .. "This is bright red on green")
-- print(ansicolor.invert .. "This is inverted..." .. ansicolor.reset .. " And this isn't.")
-- print(ansicolor.fg(0xDE) .. ansicolor.bg(0xEE) .. "You can use xterm-256 ansicolors too!" .. ansicolor.reset)
-- print("And also " .. ansicolor.bold .. "BOLD" .. ansicolor.normal .. " if you want.")
-- print(ansicolor.bold .. ansicolor.fg.BLUE .. ansicolor.bg.blue .. "Miss your " .. ansicolor.fg.RED .. "C-64" .. ansicolor.fg.BLUE .. "?" .. ansicolor.reset)
--
-- You can see all these examples in action by calling ansicolor.test()
--
-- Can't pick a good ansicolor scheme? Look at a handy chart:
-- print(ansicolor.chart())
--
-- If you want to add anything to this, check out the Wikipedia page on ANSI control codes:
-- http://en.wikipedia.org/wiki/ANSI_escape_code

--------------------------------------------------------------------------------

-- Copyright (C) 2012 Ross Andrews
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/lgpl.txt>.

--------------------------------------------------------------------------------

-- A note about licensing:
--
-- The LGPL isn't really intended to be used with non-compiled libraries. The way
-- I interpret derivative works of this library is this: if you don't modify this
-- file, and the program it's embedded in doesn't modify the Lua table it defines,
-- then you can distribute it with a program under any license. If you do either
-- of those things, then you've created a derivative work of this library and you
-- have to release the modifications you made under this same license.

local ansicolor = { _NAME = "ansicolor" }
local _M = ansicolor

local esc = string.char(27, 91)

local names = { 'black', 'red', 'green', 'yellow', 'blue', 'pink', 'cyan', 'white' }
local hi_names = { 'BLACK', 'RED', 'GREEN', 'YELLOW', 'BLUE', 'PINK', 'CYAN', 'WHITE' }

---@type table<string, string>
ansicolor.fg, ansicolor.bg = {}, {}

for i, name in ipairs(names) do
  ansicolor.fg[name] = esc .. tostring(30 + i - 1) .. 'm'
  _M[name] = ansicolor.fg[name]
  ansicolor.bg[name] = esc .. tostring(40 + i - 1) .. 'm'
end

for i, name in ipairs(hi_names) do
  ansicolor.fg[name] = esc .. tostring(90 + i - 1) .. 'm'
  _M[name] = ansicolor.fg[name]
  ansicolor.bg[name] = esc .. tostring(100 + i - 1) .. 'm'
end

local function fg256(_, n)
  return esc .. "38;5;" .. n .. 'm'
end

local function bg256(_, n)
  return esc .. "48;5;" .. n .. 'm'
end

setmetatable(ansicolor.fg, { __call = fg256 })
setmetatable(ansicolor.bg, { __call = bg256 })

ansicolor.reset = esc .. '0m'
ansicolor.clear = esc .. '2J'

ansicolor.bold = esc .. '1m'
ansicolor.faint = esc .. '2m'
ansicolor.normal = esc .. '22m'
ansicolor.invert = esc .. '7m'
ansicolor.underline = esc .. '4m'

ansicolor.hide = esc .. '?25l'
ansicolor.show = esc .. '?25h'

function ansicolor.move(x, y)
  return esc .. y .. ';' .. x .. 'H'
end

ansicolor.home = ansicolor.move(1, 1)

--------------------------------------------------

function ansicolor.chart(ch, col)
  local cols = '0123456789abcdef'

  ch = ch or ' '
  col = col or ansicolor.fg.black
  local str = ansicolor.reset .. ansicolor.bg.WHITE .. col

  for y = 0, 15 do
    for x = 0, 15 do
      local lbl = cols:sub(x + 1, x + 1)
      if x == 0 then lbl = cols:sub(y + 1, y + 1) end

      str = str .. ansicolor.bg.black .. ansicolor.fg.WHITE .. lbl
      str = str .. ansicolor.bg(x + y * 16) .. col .. ch
    end
    str = str .. ansicolor.reset .. "\n"
  end
  return str .. ansicolor.reset
end

function ansicolor.test()
  print(ansicolor.reset .. ansicolor.bg.green .. ansicolor.fg.RED .. "This is bright red on green" .. ansicolor.reset)
  print(ansicolor.invert .. "This is inverted..." .. ansicolor.reset .. " And this isn't.")
  print(ansicolor.fg(0xDE) .. ansicolor.bg(0xEE) .. "You can use xterm-256 ansicolors too!" .. ansicolor.reset)
  print("And also " .. ansicolor.bold .. "BOLD" .. ansicolor.normal .. " if you want.")
  print(ansicolor.bold ..
    ansicolor.fg.BLUE ..
    ansicolor.bg.blue .. "Miss your " .. ansicolor.fg.RED .. "C-64" .. ansicolor.fg.BLUE .. "?" .. ansicolor.reset)
  print("Try printing " .. ansicolor.underline .. _M._NAME .. ".chart()" .. ansicolor.reset)
end

return ansicolor
