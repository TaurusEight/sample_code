# Time-stamp: <2012-11-02 16:56:31 daniel>
# 'form.coffee': Wrapper class for dealing with HTML forms

# Wrap DOM form into a class in order to handle serializing and submitting
# -----------------------------------------------------------------------------
class Form

  constructor: (@H) ->
    @H = $(@H) if typeof @H == "string"
    @H.onsubmit = @submit  # handle the submit event on the form

  submit: (Ev) => return  # to be over-ridden in child subclass

  # build a query_string of all controls on form
  serialize: ->
    query_string = ''  # init the string
    encode = (K,V) -> "#{encodeURIComponent K}=#{encodeURIComponent V}&"
    split = (item) -> encode item.name, item.value
    query_string += split item for item in @H.getElementsByTagName 'input'
    return query_string.replace /&$/, ''  # remove trailing '&'

  disable: ->
    el.disabled = true for el in @H.getElementsByTagName 'input'

  enable: ->
    el.disabled = false for el in @H.getElementsByTagName 'input'
