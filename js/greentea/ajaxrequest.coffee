# Time-stamp: <2012-11-02 16:53:55 daniel>
# 'ajax.request.coffee': Wrapper for HTML5 ajax requests


class Ajax

  # Takes a URL as the first parameter and defaults to POST as the method
  constructor: (@url) ->
    @H = new XMLHttpRequest  # create the request
    throw new Error 'XMLHttpRequest not supported!' unless @H
    @method = 'POST'  # default can be changed in subclass if needed
    @async = true  # default - if set to false the script will wait
    @H.onreadystatechange = @change


# Wrapper class for a request.
# -----------------------------------------------------------------------------
class Ajax.Request extends Ajax

  open: ->
    @H.open @method, @url, @async
    @H.setRequestHeader "Content-type", "application/x-www-form-urlencoded"

  send: (QS="") ->
    @initial()
    @open()
    @H.send QS

  # Called during execution of the request by the server
  # Called five or more times based on functions in 'func'
  change: =>
    func = [ @uninitialized, @loading, @loaded, @interactive, @complete ]
    if @H.readyState in [ 0, 1, 2, 3, 4 ] then func[ @H.readyState ]()
    else Log.error "Ajax 'readyState' outof bounds!"

  uninitialized: => return  # to be furnished by subclass if needed
  loading: =>  return   # to be furnished by subclass if needed
  loaded: =>  return  # to be furnished by subclass if needed
  interactive: =>  return # to be furnished by subclass if needed

  # Called when request is completed by the server.
  # If .status is not 200 it's an error.
  # Then parse the responseText to JSON and call 'success'
  # Finally, call complete to end the functions of the request.
  complete: =>
    if @H.status == 200
      json = JSON.parse @H.responseText
      @success json, @H.responseText, @H.status
    else @failure @H.status  # Not HTTP code 200
    @final @H.status

  success: (J,R,S) =>   return  # to be furnished by subclass if needed
  initial: => return  # called before the request is open/sent
  final: (S) =>  return  # called after request has returned

  # Called when return status code is not 200
  failure: (S) => Log.error "Error: status:'#{S}'  URL:'#{@url}'"
