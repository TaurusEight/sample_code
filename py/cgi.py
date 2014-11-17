
# Time-stamp: <2013-10-31 21:10:48 daniel>

# 'cgi.py': base class for reading data passed through HTTP CGI protocals


#
# Required modules
import argparse  # Argument parsing
from penny.encoding import CGI, Dictionary
#from penny.logging import ErrorLog  # Error log
from penny.lanra import Lanra as Database  # Newsletter database
from penny.debug import Debug  # debugging print
from penny.log import Log  # Error and Info logging

#
# Wrapper class for handling incoming subscription updates
class Application( CGI ) :

  # Used to turn on or off debugging
  @staticmethod
  def arguments( ) :
    parser = argparse.ArgumentParser()
    parser.add_argument( '-d', '--debug', nargs = '*', default = False, help = 'Turn on debugging output' )
    Debug.status( parser.parse_args().debug )  # turn on or off debugging

  # Constructor
  def __init__( self, log_file_path = '/opt/ebd/var/log/error.log' ) :
    Application.arguments()  # any command line arguments?
    super().__init__()
    self.log = Log( log_file_path )
    self.result = Dictionary( { 'success' : True, 'payload': 'None' } )
    self.db = Database()


  # Output return header for the HTTP request
  def header( self ) :
    print( "Content-Type: application/json\n\n" )
    print( self.result )


  # Primary routine of this object must be defined by derived class
  def main( self ) :
    return


  # Output an exception to the file
  def exception( self, error ) :
    self.log.error( str( error ) )
    self.result.payload = str( error )
    self.result.success = False


  # Perform actions of this script
  def run( self ) :
    try : self.main()
    except Exception as error : self.exception( error )
    self.header()
