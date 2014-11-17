-- Time-stamp: <2013-10-01 14:20:48 daniel>

-- 'account.sql': Tools to open/create a new account in the database

-- Custom Type Definitions and other macros
-- include(`custom.types.m4')

-- Database used
use DATABASE;




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


--
-- Return a customer ID based on the
-- customers Facebook ID
drop procedure if exists find_customer $$
create procedure find_customer (

  in _fbid facebook_t,  -- Customers Facebook ID
  out _cid cid_t  -- Customer ID

) begin

  set _cid = null;

  select cid into _cid from facebook where fbid = _fbid;
  if _cid is null then
    call throw_error( concat( "Bad FBID: ", _fbid ) );
  end if;  -- end if @cid is null

end  $$  -- end find_customer
