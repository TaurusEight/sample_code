<?

// Time-stamp: <2014-11-20 09:42:30 daniel>
// 'template.m4.php': Wrap the call to the m4 processor.
// Replace client data in the template before making the process call.


// Namespace for this class - Same as others that deal with design templates
//-----------------------------------------------------------------------------
namespace template {

  // Required modules
  //---------------------------------------------------------------------------
  require_once( 'inc/boost.process.inc' );  // process module


  // Wrap call to the M4 macro processor into a php class
  //---------------------------------------------------------------------------
  class m4 extends \boost\process {

    // Scrub the HTML free of special code strings
    protected function add_client( $client, $template ) {

      $block = <<<DONE
define(<<_FIRSTNAME>>,<<%s>>)dnl
define(<<_LASTNAME>>,<<%s>>))dnl
define(<<_COUNTRY>>,<<%s>>))dnl
define(<<_CONSULTANTEMAIL>>,<<%s>>))dnl
define(<<_HEADSHOT>>,<<[headshotimage]>>))dnl
define(<<_HEADSHOTWIDTH>>,<<[headshotwidth]>>))dnl
define(<<_HEADSHOTHEIGHT>>,<<[headshotheight]>>))dnl
define(<<_PHONE>>,<<%s>>))dnl
define(<<_TITLE>>,<<%s>>))dnl
define(<<_CWEBSITE>>,<<%s>>))dnl
DONE;

      $data = sprintf( $block,
                       $client->firstname,
                       $client->lastname,
                       $client->country,
                       $client->email,
                       $client->phone,
                       $client->title,
                       $client->consultant
                       );  // end resplace

      return \str_replace( '@@CLIENTDATA@@', $data, $template );

    }  // end add_client


    // constructor: one parameter - reference to html to be converted to text
    public function __construct( &$client, &$template ) {
      $cmd = "/usr/bin/m4 -";
      parent::__construct( $cmd, $this->add_client( $client, $template ) );
    }  // end constructor


  }  // end definition for class m4

}  // end namespace template


?>