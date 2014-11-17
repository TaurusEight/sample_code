# Time-stamp: <2013-09-11 16:23:59 daniel>


# 'object.py': Defines the base class for all Facebook objects


##
# Parent Wrapper for all Facebook objects
class FacebookObject( object ) :


  # constructor
  def __init__( self, handle = 0 ) :
    super().__init__()
    self.handle = handle


  # Convert this object into a string
  def __str__( self ) : return str( self.handle )
