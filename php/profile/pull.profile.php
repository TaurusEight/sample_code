<?

// Time-stamp: <2014-11-20 09:34:18 daniel>
// 'pull.profile.php': Return JSON encoded data for a clients account.

// namespace wrapper
//-----------------------------------------------------------------------------
namespace Pull {


  // Required modules
  //---------------------------------------------------------------------------
  require_once( 'mysql/mysql.base.php' );  // database access module


  // Class wrapper
  //---------------------------------------------------------------------------
  class Profile extends \mysql\database {


    // Requests data specific to 'client' information displayed
    const CLIENT_QUERY = 'select * from Client.Profile where cid = %d';
    const EBD_QUERY = 'select * from ebd.Profile where cid = %d';


    // standard parameters used with the query
    protected $parameters = array( 'cid' => 0 );


    // array to store results of the queries before converting them to JSON
    protected $result = array( 'message' => 'good',
                               'client' => null,
                               'ebd' => null,
                               'success' => true );


    // check CGI for additional values for parameters
    protected function _parse_request() {
      foreach( array_keys( $this->parameters ) as $key ) {
        if ( isset( $_REQUEST[ $key ] ) and ( $_REQUEST[ $key ] != '' ) )
          $this->parameters[ $key ] = $this->escape_string( $_REQUEST[ $key ] );
      }  // end foreach
    }  // end _parse_request


    // Perform one or the other of the two queies this script performs
    protected function _specific_query( $query, &$dump ) {
      $response = $this->query( sprintf( $query, $this->parameters[ 'cid' ] )  );
      if ( $response->num_rows != 1 ) throw new \Exception( 'Can not retrrieve data!' );
      $dump = $response->fetch_assoc();
    }  // end _specific_query


    // Perform both queries
    protected function _query() {
      $this->_specific_query( self::EBD_QUERY, $this->result[ 'ebd' ] );
      $this->_specific_query( self::CLIENT_QUERY, $this->result[ 'client' ] );
    }  // end _query


    // Dump the data back to the Ajax Request
    public function output() {
      header( 'Content-type: application/json' );
      echo json_encode( $this->result );
    }  // end output


    // constructor
    public function __construct( $cid = 0 ) {
      try {
        parent::__construct();  // call parent constructor
        $this->_parse_request();  // get data passed from javascript
        $this->_query();  // get data from data base and parse it
      } catch( \Exception $e ) {
        $this->result[ 'message' ] = $e->getMessage();
        $this->result[ 'success' ] = false;
      }  // end try catch
    }  // end constructor

  }  // end definition for class 'Profile'


  // Entry into script
  $profile = new Profile();
  $profile->output();


}  // end namespace 'Pull'
