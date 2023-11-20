local ansicolor = require "lib.ansicolor"

local logger = {
  ---@type table<string, string>
  colors = {
    debug = ansicolor.bold .. ansicolor.fg.green,
    info = ansicolor.bold .. ansicolor.fg.white,
    warn = ansicolor.bold .. ansicolor.fg.yellow,
    error = ansicolor.bold .. ansicolor.fg.red,
  },
  levels = {
    debug = "[DEBUG] ",
    info = "[INFO] ",
    warn = "[WARN] ",
    error = "[ERROR] ",
    fatal = "[FATAL] ",
  }
}

function logger:log(text)
  print({
    __PREFIX__ = self.colors.info
  }, self.levels.info .. text)
end

function logger:debug(text)
  print({
    __PREFIX__ = self.colors.debug .. self.levels.debug
  }, self.levels.debug .. text)
end

function logger:warn(text)
  print({
    __PREFIX__ = self.colors.warn .. self.levels.warn
  }, self.levels.info .. text)
end

function logger:error(text)
  print({
    __PREFIX__ = self.colors.error .. self.levels.error
  }, self.levels.info .. text)
end

return logger
