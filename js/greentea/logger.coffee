# Time-stamp: <2013-01-11 20:07:31 daniel>
# 'logger.coffee': Create a better logging function for CoffeeScript apps
#
# Usage: Log.info 'text'

# Better console logging
class Logger

  commands = [ 'log', 'info', 'warn', 'error' ]
  isDev = -> true

  constructor: ->
    for name in commands
      @[name] = do (name) ->
        ->
          if isDev() and window.console?
            window.console[name].apply console, arguments

Log = new Logger()
