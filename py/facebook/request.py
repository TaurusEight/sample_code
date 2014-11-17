# Time-stamp: <2013-11-07 10:04:36 daniel>

##
# Required modules
import requests
from urllib.parse import parse_qs
from collections import Counter


##
# Create the dictionary that is used with a request
class Payload( object ) :

  def __init__( self, *items ) :
    super().__init__()
    self.handle = {}
    self.iterate_items( items )


  def iterate_items( self, items ) :
    for item in items :
      self.add( item )

  def __str__( self ) : return str( self.handle )


  def add( self, item ) :
    self.handle.update( item )


class AccessTokenPayload( Payload ) :

  def __init__( self, token, *items ) :
    super().__init__( { 'access_token': token } )
    self.iterate_items( items )


##
# Wrap requests to Facebook
class Request( object ) :

  # constants
  URL = 'https://graph.facebook.com/{}'

  # constructor
  def __init__( self, caller, url, payload = None ) :
    super().__init__()
    self.caller = caller
    self.payload = Payload() if payload is None else payload
    self.url = Request.URL.format( url )


  # Internal function to get JSON data from this request for error testing
  # over-ridden in child classes to further drill down into Facebook returned data
  def _json( self, request ) :
    return request.json()

  # Check the results of a request for error from Facebook
  def _check_for_error( self, request ) :
    json = self._json( request )
    if 'error' in json : raise Exception( '{} : {}'.format( self.caller, json[ 'error' ][ 'message' ] ) )
    return json

  # Wrap GET request to Facebook in a simple interface
  def get( self ) :
    return self._check_for_error( requests.get( self.url, params = self.payload.handle ) )

  # Wrap POST request to Facebook into a simple interface
  def post( self ) :
    return self._check_for_error( requests.post( self.url, params = self.payload.handle ) )

  def post_files( self _files ) :
    return self._check_for_error( requests.post( self.url, files = _files, params = self.payload.handle ) )


##
# Some Facebook requests return JSON encased within a 'data' element
class DataRequest( Request ) :

  def __init__( self, caller, url, payload = None ) :
    super().__init__( caller, url, payload )

  def _json( self, request ) :
    result = request.json()
    if 'data' in result : return result[ 'data' ]
    return result


##
# Requesting a token requires a special break down
class TokenRequest( Request ) :

  def __init__( self, caller, url, payload = None ) :
    super().__init__( caller, url, payload )

  def _json( self, request ) :
    try :
      token = parse_qs( request.text, False, True )[ 'access_token' ][ 0 ]
      return { 'token': token }
    except ValueError as ve :
      return request.json()
