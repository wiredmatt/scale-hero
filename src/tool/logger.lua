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

---@param ... any
function logger:log(...)
  print({
    __PREFIX__ = self.colors.info
  }, ...)
end

---@param ... any
function logger:debug(...)
  print({
    __PREFIX__ = self.colors.debug .. self.levels.debug
  }, ...)
end

---@param ... any
function logger:warn(...)
  print({
    __PREFIX__ = self.colors.warn .. self.levels.warn
  }, ...)
end

---@param ... any
function logger:error(...)
  print({
    __PREFIX__ = self.colors.error .. self.levels.error
  }, ...)
end

return logger
