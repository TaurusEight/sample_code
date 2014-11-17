-- Time-stamp: <2013-10-01 21:36:51 daniel>

-- 'find_customer_from_fbid.sql': Tools to open/create a new account in the database

-- Custom Type Definitions and other macros
-- include(`custom.types.m4')

-- Database used
use DATABASE;



-- Start by changing line-end character
delimiter $$  -- change from ';'

--
-- Return a customer ID based on the
-- customers Facebook ID
drop procedure if exists find_customer_from_fbid $$
create procedure find_customer_from_fbid (

  in _fbid facebook_t,  -- Customers Facebook ID
  out _cid cid_t  -- Customer ID

) begin

  set _cid = null;  -- default value for _cid

  select cid into _cid from facebook where fbid = _fbid;
  if _cid is null then
    call throw_error( concat( "No 'cid' associated with 'fbid': ", _fbid ) );
  end if;  -- end if @cid is null

end  $$  -- end find_customer_from_fbid

delimiter ;  -- reset from '$$'
