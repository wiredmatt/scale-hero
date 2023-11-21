local ansicolor = require "lib.ansicolor"

local logger = {
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
  }, text)
end

function logger:debug(text)
  print({
    __PREFIX__ = self.colors.debug .. self.levels.debug
  }, text)
end

function logger:warn(text)
  print({
    __PREFIX__ = self.colors.warn .. self.levels.warn
  }, text)
end

function logger:error(text)
  print({
    __PREFIX__ = self.colors.error .. self.levels.error
  }, text)
end

return logger
