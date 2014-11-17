-- Time-stamp: <2013-10-01 14:23:50 daniel>

-- 'account.sql': Tools to open/create a new account in the database

-- Custom Type Definitions and other macros
-- include(`custom.types.m4')

-- Database used
use DATABASE;


-- Start by changing line-end character
delimiter $$  -- change from ';'


--
-- Handle errors so bad that the process has to exit
drop procedure if exists throw_error $$
create procedure throw_error (

  _message long_string_t  -- message from function

) begin

  insert into DATABASE.log ( message ) values ( _message );
  signal sqlstate '99001' set message_text = _message;

end $$  -- end throw_error


delimiter ;  -- reset from '$$'