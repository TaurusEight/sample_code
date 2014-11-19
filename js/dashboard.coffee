
# Time-stamp: <2014-11-18 18:03:24 daniel>


##
# Wrapper for Ajax request to change Client page where service newslet it uploaded
class PageSelectionRequest extends Ajax.Request

  Notice: 'Change was successful.'
  Warning: 'Notice: This setting does not cancel your service it only disables daily posting to your Facebook account.'

  constructor: (@select) ->
    super './local/scripts/change.page.application'

  send: (cid,sku,pid) =>
    super "_cid=#{cid}&_sku=#{sku}&_pid=#{pid}"

  success: =>
    alert( if @select.value == 'disabled' then @Warning else @Notice )


  failure: (S) =>
    alert 'Due to a system error this change could not be completed at this time.'

  final: =>
    @select.disabled = false


##
# Wrapper for setting up the client page used by a service
class PageSelection

  constructor: (@cid) ->
    controls = $$( 'td select' )
    select.onchange = @changed for select in controls

  changed: (event) =>
    select = event.target
    select.disabled = true
    sku = select.parentNode.parentNode.id  # sku of this service
    new PageSelectionRequest( select ).send @cid, sku, select.value


##
# Request for server to create account table for this client
class ServiceTable extends Ajax.Request

  # constructor
  constructor: ( @A ) ->
    super './local/scripts/dashboard.application'

  # have parent class send request
  send: ( userID, accessToken ) =>
    super "_fbid=#{userID}&_token=#{accessToken}"

  # instructions should be visiable only when payload loaded
  instructions: =>
    $( 'instructions' ).style.display = 'block'


  # no currently active service contracts
  empty: (payload) =>
    if payload.substring(0,4) == 'http'
      @A.innerHTML = '<p>One moment please ...</p>'
      window.location = payload
      return true
    return false

  # Check to insure a valid payload and update @A
  payload: (payload) =>
    return if @empty payload
    @A.innerHTML = payload
    input = document.querySelector 'input[name=nscid]'
    return unless document.getElementById( 'dashboard' )
    new PageSelection( input.value )  # input.value is the customer ID
    @instructions()  # show the instructions

  # When the request was successfull
  success: (J) =>
    if J.success == true
      @payload J.payload
    else
      @failure()

  # If request failed due to database issues - check written logs
  failure: (S) =>
    @A.innerHTML = "<p class='error'>Oops...  we're experiencing more traffic than we can handle right now.  Please try again in a few minutes.  Thanks for your patience!</p>"



##
# Wrapper for Facebook authentication and login
class Facebook

  # constructor
  constructor: ->
    @init_facebook()  # initialize Facebook
    $( 'login_button' ).onclick = @login_button

  # Call the Facebook initializion function and get login status
  init_facebook: =>
    FB.init
      appId: '***'
      status: true
      cookies: true
      xfbml: true
      oauth: true
    FB.getLoginStatus @response_from_facebook

  # Call facebook login when login_button is clicked
  login_button: =>
    scope = { scope: 'publish_actions,publish_stream,user_photos,manage_pages' }
    FB.login @response_from_facebook, scope

  # Handle a login request response from Facebook
  response_from_facebook: (R) =>
    article = $( 'wrapper' )
    article.style.display = 'block'
    if R && R.status == 'connected'
      article.innerHTML = '<div><img src="./local/images/loading.gif" width="98" height="100" /></div>'
      service_table = new ServiceTable article
      service_table.send R.authResponse.userID, R.authResponse.accessToken



##
# Wrapper for application functions
class Application

  constructor: ->
    try
      @facebook = new Facebook()  # create a facebook object
    catch E
      Log.error E.message


##
# Entry into script
app = new Application()
