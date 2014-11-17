
# Time-stamp: <2013-11-07 16:34:10 daniel>

##
# Required modules
from penny.facebook.object import FacebookObject
from penny.facebook.secret import Client
from penny.facebook.request import Request, DataRequest, TokenRequest, Payload


##
# Wrapper for a facebook token
class Token( FacebookObject ) :

  # constructor
  def __init__( self, token = 0 ) :
    super().__init__( token )


  # Call the Facebook API token debug routine
  def debug( self ) :
    payload = Payload( { 'access_token': Client().access_token(), 'input_token': self.handle } )
    return DataRequest( 'Token.debug', 'debug_token', payload ).get()


  # Call Facebook and exchange this token for a new 60 day token
  def exchange( self ) :
    payload = Payload( Client().parameters(), { 'grant_type': 'fb_exchange_token', 'fb_exchange_token': self.handle } )
    self.handle = TokenRequest( 'Token.exchange', 'oauth/access_token', payload ).post()[ 'token' ]


##
# Off load the exchange into a subclass where it belongs
class LongTermToken( Token ) :

  def __init__( self, token ) :
    super().__init__( token )
    self.exchange()


##
# Non-expiring Page Access Token
class PageAccessToken( Token ) :

  # constructor:
  # 'pid': ID of Facebook Page to get token for
  # 'token': Current access token for this account
  def __init__( self, pid, token ) :
    super().__init__()
    self.request( pid, token )

  # Request page access token from Facebook
  def request( self, pid, token ) :
    payload = Payload( { 'fields': 'access_token', 'access_token': str( token ) } )
    self.handle = Request( 'PageAccessToken.request', pid, payload ).get()[ 'access_token' ]
