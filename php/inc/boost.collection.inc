<?php

  // Time-stamp: <2014-11-20 09:41:06 daniel>
  // 'boost.php': Utility classes used by other classes


// Default namespace for utility classes
//-----------------------------------------------------------------------------
namespace boost {

  // Wrap functions for collections into a class
  //---------------------------------------------------------------------------
  class collection {

    // class members
    private $handle = 0;  // holds key value pairs

    // throw exception if the key is not in the handle
    private function __except( $k ) {
      if ( \array_key_exists( $k, $this->handle ) == false )
        throw new \OutOfBoundsException( $k . ' is not an index!' );
    }  // end __except

    // Set the value of the key in the handle
    public function __set( $k, $v ) {
      $this->__except( $k );
      $this->handle[ $k ] = $v;
    }  // end __set

    // return the value of the key
    public function __get( $k ) {
      $this->__except( $k );
      return $this->handle[ $k ];

    }  // end __get

    public function json() {
      return \json_encode( $this->handle );
    }  // end json

    // return the keys in this object
    public function keys() { return \array_keys( $this->handle ); }

    // copy data into handle
    public function __construct( $data ) { $this->handle = $data; }

  }  // end class vector

}  // end namespace boost


?>