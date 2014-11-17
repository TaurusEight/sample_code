# Time-stamp: <2013-10-15 14:49:36 daniel>
# 'element.coffee': Defines the element class and helper functions


# Shortcut to finding a single element
$ = (I) ->
  E = document.getElementById I
  E = document.querySelector I if not E
  throw new Error "'#{I}' not found" if not E
  return E

# Shortcut to finding an array of elements
$$ = (I) ->
  E = document.getElementsByClassName I
  E = document.getElementsByTagName I if E.length < 1
  E = document.querySelectorAll I if E.length < 1
  throw new Error "'#{I}' not found" if E.length < 1
  return E

##
# Wrap common functions for elements in the document
class Element

  constructor: (E) ->
    if typeof E is 'string'
      @handle = document.getElementById E
      @handle = document.querySelector E unless @handle
    else
      @handle = E  # already an actual element in the document
    throw new Error "#{E} not found!" unless @handle

  info: ->
    console.log @handle.innerHTML

##
# Wraper for array of elements
class Elements

  constructor: (S) ->
    if typeof S is 'string'
      vector = document.getElementsByClassName S
      vector = document.getElementsByTagName S unless vector
      vector = document.querySelectorAll S unless vector
    else
      vector = S  # vector of elements aready used
    throw new Error "#{S} not found!" unless vector
    @handles.push new Element handle for handle in vector

  info: ->
    console.log e.innerHTML for e in @vhandles.value
