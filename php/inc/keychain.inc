<?php

// Time-stamp: <2014-11-20 09:39:46 daniel>
// 'key.ring.inc': Holds password for MySQL and PostgreSQL
// Apache is configured to prevent '.inc' files from being seen

// Definition of namespace under which the constants are defined
//-----------------------------------------------------------------------------
namespace keychain {

  const client_name = 'd***r';
  const client_password = 'W***l';
  const client_database = 'b***n';


  // Wrap these constants into a class structure
  //---------------------------------------------------------------------------
  class admin {
    const user = 'c***r';
    const password = 'O***o';
    const database = 'b***n';
  }  // end class client

  class client {
    const user = 'd***r';
    const password = 'W***l';
    const database = 'b***n';
  }  // end class client

}  // end namespace keychain

?>
