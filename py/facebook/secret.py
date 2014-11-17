
# Time-stamp: <2014-11-16 16:47:14 daniel>

# 'secret.py': Facebook App ID and App Secret for both
# www.pennylake.com and www.tigerwalk.info


##
# Required modules
from socket import gethostname  # find the host we are running on


##
# Base wrapper for App Secret and App ID
class Value( object ) :

  # Constants  - Actuall values are hidden in public code!
  App = {
    'ti**lk': {
      'id': '******',
      'secret': '******'  },
    'pe**om': {
      'id': '******',
      'secret': '******' }
    }

  # constructor
  def __init__( self ) :
    super().__init__()
    self.host()

  # find the value based on the hostname
  def host( self ) :
    hostname = gethostname()
    if hostname not in Value.App :
      raise Exception( 'Unknown hostname: {}'.format( hostname ) )
    self.handle = Value.App[ hostname ]


##
# Wrapper for the actual values used
##

##
# App ID
class ID( Value ) :
  def __str__( self ) : return self.handle[ 'id' ]


##
# App Secret
class Secret( Value ) :
  def __str__( self ) : return self.handle[ 'secret' ]


##
# Wrapper used to create an access_token from the ID and Secret

##
# Wrapper
class Client( object ) :

  # constructor
  def __init__( self ) :
    self.id = ID()
    self.secret = Secret()

  # common parameters in a Facebook request
  def parameters( self ) :
    return { 'client_id': self.id.__str__(), 'client_secret': self.secret.__str__() }

  # return an access_token created from the ID and Secret
  def access_token( self ) :
    return '{}|{}'.format( self.id, self.secret )

  # return as a string object
  def __str__( self ) :
    return "{} : {}".format( self.id, self.secret )
