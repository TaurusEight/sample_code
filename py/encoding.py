#!/usr/bin/env python3

# Time-stamp: <2013-09-20 17:37:20 daniel>

# Create objects that have predefined attributes that can
# dump their values as JSON encoded strings.


# Required modules
#------------------------------------------------------------------------------
from json import loads, dumps  # JSON support
from datetime import datetime  # Get the current date and time
import cgi as module_cgi  # Common Gateway Interface


# Wrapper for a JSON string object
#------------------------------------------------------------------------------
class Template( object ) :

  # Constructor
  def __init__( self ) :
    """Wrapper for overloading __setattr__ and __getattr__ with JSON dump"""
    super().__init__()
    self.handle = {}
    self.__initialized = True

  # Return the attribute if found - no error is thrown if it is not found
  def __getattr__( self, name ) :
    """Map a value to an attribute called 'name'"""
    if name in self.__dict__ :
      return self.__dict__[ name ]
    elif name in self.handle.keys() :
      return self.__dict__[ 'handle' ][ name ]

  # Set the value associated with the 'key'd attribute
  def __setattr__( self, key, value ) :
    """Map a value to an attribute called 'key', but only after init"""
    if not '_Template__initialized' in self.__dict__ :
      return super( Template, self ).__setattr__( key, value )
    elif key in self.__dict__[ 'handle' ].keys() :
      self.handle[ key ] = value
    else : self.__dict__[ key ] = value

  # Set the attributes from a pass list of key/value pairs
  def set( self, pairs ) :
    """Place values into this object"""
    for key in self.keys() :
      self.__setattr__( key, pairs[ key ] )

  # Add a new key to this object and give it a value or replace the value if exists
  def apply( self, key, value = None ) :
    self.__dict__[ 'handle' ][ key ] = value


  # Return a list of keys associated with this template
#  def keys( self ) :
#    return self.handle.keys()

  # Return all values stored by keys in this object
#  def values( self ) :
#    """Return all stored values by keys in this object"""
#    return self.handle.values()

  # Return the value of the key
  def __getitem__( self, key ) :
    """Return the value of a specific key"""
    return self.handle[ key ]

  # Set the value of the key
  def __setitem__( self, key, value ) :
    """Set the value of a specific key"""
    if key in self.handle.keys() : self.handle[ key ] = value
    else : raise Exception( key, value )

  # Dump the dictionary as a string
  def __str__( self ) :
    """Dump this directory as a full JSON string"""
    return dumps( self.handle )

  # change the value of a key already stored in the template
  def update( self, key, value ) :
    self.__setitem__( key, value )


# Wrap the template object around a dictionary
#------------------------------------------------------------------------------
class Dictionary( Template ) :

  # constructor
  def __init__( self, d ) :
    """Create a encoding object based on a directory of keys"""
    super().__init__()
    self.handle = d


# Wrap the template object around a list
#------------------------------------------------------------------------------
class List( Template ) :

  # constructor
  def __init__( self, l ) :
    """Create an encoding object based on a list"""
    super().__init__()
    self.handle = {}.fromkeys( l )


# Used with the class CGI as a default Exception class for reporting
# issues with requests to form IDs that do not exist
#------------------------------------------------------------------------------
class CGIException( Exception ) :

  # constructor
  def __init__( self, key ) :
    """Create a standard error for unknown ID in form data"""
    Exception.__init__( self, "'%s' : CGI key not found!" % key )


# Wrap an encoding class that parses CGI
#------------------------------------------------------------------------------
class CGI( Dictionary ) :

  # constructor
  def __init__( self ) :
    D = { 'when' : "%s" % datetime.now(), 'form': 'default' }
    super().__init__( D )
    self.__parse_cgi()

  # parse the Common Gateway Interface values
  def __parse_cgi( self ) :
    form = module_cgi.FieldStorage( keep_blank_values = True )
    for name in form.keys() :
      self.handle[ name ] = module_cgi.escape( form.getvalue( name ), True )

  # Return the value of the key or throw an exception
  def __getattr__( self, key ) :
    value = super().__getattr__( key )
    if not value : raise CGIException( key )
    return value


# If run as a script
#------------------------------------------------------------------------------
if __name__ == "__main__" : pass

#  print( List( [ 'one', 'two' ] ) )
#  print( Dictionary( { 'Ben' : 'father', 'Adam' : 'son' } ) )
#  temp = List( [ 'aaa', 'bbb' ] )
#  temp.aaa = 111
#  temp.bbb = 222
#  print( temp )
#  d = Dictionary( { 'payload' : 'nothing', 'success' : True } )
#  print( d )
#  x = CGI()
#  print( x )
