<?php

// Time-stamp: <2014-11-20 09:34:30 daniel>
// 'push.profile.php': Stores data from the web site into the database

//-----------------------------------------------------------------------------
namespace Push {

  // Modules used by this class
  //---------------------------------------------------------------------------
  require_once( 'mysql/mysql.base.php' );  // database access module
  require_once( 'bydesign/ebd.log.php' );  // logging module
  require_once( 'client.url.php' );  // website parsing routines


  // Wrapper class that handles updating SQL database with clients profile
  //---------------------------------------------------------------------------
  class Profile extends \mysql\database {

    const max_field_length = 100;  // max size for data coming in.

    private $result = array( 'success' => true, 'message' => 'All Good' );
    private $parameters = array(
                                'cid' => null,
                                'firstname' => null,
                                'lastname' => null,
                                'address' => null,
                                'address_2nd' => null,
                                'city_name' => null,
                                'state-name' => null,
                                'post_code' => null,
                                'main_phone' => null,
                                'cell_phone' => null,
                                'fax_phone' => null,
                                'contact_email' => null,
                                'display_email' => null,
                                'title_code' => null,
                                'vanity_url' => null,
                                'website' => null,
                                'facebook' => null
                                 );  // end parameters

    // The SQL query used to update the database
    const insert = "update clients set
                    firstname = '%s',
                    lastname = '%s',
                    address = '%s',
                    address2 = '%s',
                    city = '%s',
                    state = '%s',
                    zip = '%s',
                    mainphone = '%s',
                    cellphone = '%s',
                    faxphone = '%s',
                    email = '%s',
                    consultantemail = '%s',
                    title = '%s'
                    where customerid = %d";


    // Call stored procedure to update the clients websites
    protected function websites() {

      $this->log->debug( \sprintf( "1 WEBSITE: %s", $this->website ) );

      $this->facebook_page = \Website\RMSite( $this->facebook_page );
      $this->website = \Website\RMSite( $this->website );
      $this->vanity_url = \Website\RMProtocol( $this->vanity_url );

      $this->log->debug( \sprintf( "2 WEBSITE: %s", $this->website ) );

      $query = sprintf( "call Client.UpdateWebsites( %d, '%s', '%s', '%s' )",
                        $this->cid,
                        $this->website,
                        $this->vanity_url,
                        $this->facebook );

      $this->log->info( $query );

      if ( $this->query( $query ) == false )
        throw new \Exception( $this->error() );



    }  // end websites


    // Add data to the database
    protected function _update() {
      $query = sprintf( self::insert,
                        $this->firstname,
                        $this->lastname,
                        $this->address,
                        $this->address_2nd,
                        $this->city_name,
                        $this->parameters[ 'state-name' ],
                        $this->post_code,
                        $this->main_phone,
                        $this->cell_phone,
                        $this->fax_phone,
                        $this->contact_email,
                        $this->display_email,
                        $this->title_code,
                        $this->cid );

      $this->log->info( $query );

      if ( $this->query( $query ) == false )
        throw new \Exception( $this->error() );

      $this->websites();  // update client websites

    }  // end _update


    // Mimimal security on each incoming field to try and keep hackers from
    // owning our database.  Still worry but this is the first step.
    protected function _pamper( $key ) {
      $key = \trim( $_REQUEST[ $key ] );  // remove white space before and after data
      $key = \substr( $key, 0, self::max_field_length );  // limit to 100 characters
      $key = $this->real_escape_string( $key );  // make it safe for an SQL qury
      return $key;
    }  // end _pamper


    // check CGI for additional values for parameters
    // Escape each incoming string both to prevent SQL injection attacks
    // and to prevent problems with users from Irland.
    protected function _parse_request() {
      $has = function( $k ) { return \array_key_exists( $k, $_REQUEST ); };
      foreach( array_keys( $this->parameters ) as $key ) {
        if ( $has( $key ) ) $this->parameters[ $key ] = $this->_pamper( $key );
      }  // end foreach
    }  // end _parse_request


    // Write line to the EBD log
    protected function _log() {
     $this->log->info( sprintf( 'PROFILE %s %s, %d, %s, %d',
                                $this->firstname,
                                $this->lastname ,
                                $this->cid,
                                $_SERVER[ 'REMOTE_ADDR' ],  // IP of client
                                true ) );  // end _log
    }  // end _log


    //  Retreive data from parameters by name
    public function __get( $name ) {
      if ( isset( $this->parameters[ $name ] ) )
        return $this->parameters[ $name ];
    }  // end _get


    // Dump results back to the javascript
    public function output() {
      header( 'Content-type: application/json' );
      echo json_encode( $this->result );
    }  // end output


    // Constructor
    public function __construct() {
      $this->log = new \ByDesign\Log( '/srv/http/v2/log/debug.output' );
      try {
        parent::__construct();  // call parent class constructor
        $this->_parse_request();  // parse request
        $this->_update();  // perform the full update to the database
        $this->_log();  // write out line to standard log
      } catch( \Exception $e ) {
        $this->result[ 'success' ] = false;
        $this->result[ 'message' ] = 'Error updating profile.';
        $this->log->error( 'PROFILE ' . $e->getMessage() );
      }  // end try / catch
    }  // end constructor
  }  // end definition of class 'Profile'


  // entry into script
  $profile = new Profile();
  $profile->output();


}  // end namespace 'Push'

?>