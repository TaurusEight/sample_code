<?php

// Time-stamp: <2014-11-20 09:41:40 daniel>
// 'template.html2text.inc': PHP class to convert HTML to TEXT
// using an external utility over STDIN and STDOUT
//-----------------------------------------------------------------------------

// code wrapper
//-----------------------------------------------------------------------------
namespace template {


  // Required modules
  //---------------------------------------------------------------------------
  require_once( 'inc/boost.process.inc' );  // base process module


  // Process wrapper
  //---------------------------------------------------------------------------
  class html2text extends \boost\process {



    // Scrub the HTML free of special code strings
    protected function scrub_text( $html ) {

      $search = array( '&amp;', "&#149;", "&#96;", "&egrave;", "&eacute;", "&#174;",
                       '&reg;', "&#169;", '&#151;', "&#153;", "&deg;", "&frac12;",
                       "&frac14;", "&ntilde;", '&#233;', '&copy;' );  // end $special

      $replace = array( '&', "*", "'", "e", "e", "(R)",
                        '(R)', "(C)", '-', " TM", " deg", " 1/2",
                        " 1/4", 'N', 'e', '(C)' );  // end $special

      return \str_replace( $search, $replace, $html );

    }  // end 'scrub_text'


    // constructor: one parameter - reference to html to be converted to text
    public function __construct( &$html ) {
      $cmd = "/usr/bin/html2text -rcfile /srv/http/v2/ebd/etc/html2text.rc";
      parent::__construct( $cmd, $this->scrub_text( $html ) );
    }  // end constructor


  }  // end definition for class html2text


}  // end namespace template

?>