<?php

// Time-stamp: <2014-11-20 09:41:29 daniel>
// 'design.php': class to handle creation of each newsletter from a template

// Wrapper namespace for this set of functions
//-----------------------------------------------------------------------------
namespace Design {

  // Modules used by this class
  //---------------------------------------------------------------------------
  require_once( 'boost.php' );
  require_once( 'inc/template.m4.inc' );  // m4 macro process
  require_once( 'inc/template.html2text.inc' );  // process to convert html to text


  // Wrapper for the code needed for a newsletter
  //---------------------------------------------------------------------------
  class Newsletter {

    // Public members
    public $html = null;  // Will hold the produced newsletter as HTML
    public $text = null;  // Will hold the produced newsletter as TEXT


    // Private members
    private $template = null;  // holds template bits
    private $client = null;  // holds details about the client





    // Generate the text version of the newsletter directly from the HTML
    // Call the external utility 'html2text' and pipe the data to it and from it
    private function generate_text() {
      $process = new \template\html2text( $this->html );
      $this->text = $process->output;
    }  // end generate_text



    private function generate_html() {
      $process = new \template\m4( $this->client, $this->template );
      $this->html = $process->output;
    }  // end generate_html


    // insure client data and a template has been passed
    // then create the newsletter
    public function __construct( $client = null, &$template = null ) {

      if ( $client == null || $template == null )
        throw new \Exception( 'Bad parameters to Design\Newsletters' );

      $this->client = new \boost\collection( $client );
      $this->template = $template;

      $this->generate_html();
      $this->generate_text();

    }  // end constructor


  }  // end definition for class 'Newsletter'


}  // end namespace Design
