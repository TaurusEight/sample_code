<?

// Time-stamp: <2014-11-20 09:41:14 daniel>
// 'boost.process.inc': Defines common code used to run an external
// process into and out of memory.  Used for running the 'm4' macro on
// templates to turn them into HTML and then to run 'html2text'
//-----------------------------------------------------------------------------

// Wrap this class within this namespace
namespace boost {


  // Wrapper for the code needed to run an external process
  class process {


    // Public instanse members
    public $output = null;  // will hold the output of the process


   // Throw an excpetion because something strange happened
    protected function is_process( $process ) {

      if ( \is_resource( $process ) ) return $process;
      throw new \Exception( "'boost\process': Resource error!" );

    }  // end '_exceptioin'


    // Using the supplied command run the process
    protected function run( $command, $input ) {

      $descriptorspec = array(
                              0 => array( "pipe", "r" ),
                              1 => array( "pipe", "w" ),
                              2 => array( "pipe", "w" )
                              );  // end $descriptorspec

      $process = $this->is_process( \proc_open( $command, $descriptorspec, $pipe ) );
      \fwrite( $pipe[ 0 ], $input );  \fclose( $pipe[ 0 ] );
      $this->output = \stream_get_contents( $pipe[ 1 ] );  \fclose( $pipe[ 1 ] );
      \proc_close( $process );

    }  // end run


    // constructor
    public function __construct( &$command, &$input ) {
      $this->run( $command, $input );
    }  // end constructor


  }  // end definition for class 'process'


}  // end namespace 'boost'

?>