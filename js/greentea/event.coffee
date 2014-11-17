# Time-stamp: <2012-11-02 16:02:37 daniel>
# 'event.coffee': Wrapper for event objects


# Add both static class methods and instance class methods
# -----------------------------------------------------------------------------
class Event

  constructor: (@event) ->


# Provide common functions for handling events used with forms
# -----------------------------------------------------------------------------
class Event.Form extends Event

  @stop: (E) ->
    E.preventDefault()
    E.stopPropagation()

  stop: -> Event.Form.stop @event


# Wrap common functions of mouse based events
# -----------------------------------------------------------------------------
class Event.Mouse extends Event

  constructor: (E) ->
    super E
    @offset = new Point E.offsetX, E.offsetY
    @client = new Point E.clientX, E.clientY
    @point = new Point E.x - E.target.offsetLeft,    \
                       E.y - E.target.offsetTop
