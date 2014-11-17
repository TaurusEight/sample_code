
# Time-stamp: <2013-11-07 16:32:52 daniel>

# 'accounts.py':  Functions to read Facebook Account data for a client


##
# Required modules
from penny.facebook.object import FacebookObject
from penny.facebook.request import DataRequest, Payload
from penny.encoding import Dictionary


##
# Create a list of Client Facebook pages as key, value pair with page name and page ID
class Accounts( FacebookObject ) :

  def __init__( self, fbid, token ) :
    super().__init__( [] )
    self.request( fbid, token )

  # Get the list of pages and store them as a list in self.handle
  def request( self, fbid, token ) :
    payload = Payload( { 'access_token': str( token ) } )
    data  = DataRequest( 'Accounts.request', '{}/accounts'.format( fbid ), payload ).get()
    for page in data : self.handle.append( Dictionary( { 'name': page[ 'name' ], 'id': page[ 'id' ] } ) )
