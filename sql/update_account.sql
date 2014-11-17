
-- Time-stamp: <2013-10-08 14:18:30 daniel>

-- 'account.sql': Tools to open/create a new account in the database

-- Custom Type Definitions and other macros
-- include(`custom.types.m4')

-- Database used
use DATABASE;




-- Start by changing line end character
delimiter $$  -- change from ';'

--
-- Handle the initial creation of an account in the database
drop function if exists update_account $$
create function update_account (

  _fbid facebook_t,  -- Facebook ID
  _token facebook_t,  -- Facebook Token
  _firstname human_name_t,  -- first name
  _lastname human_name_t  -- last name

) returns cid_t deterministic modifies sql data
begin

  -- insert ID and Tokne into table 'facebook'
  insert into facebook ( fbid, token )
    values ( _fbid, _token )
    on duplicate key update token = _token;

  -- insert or update table 'client'
  call find_customer_from_fbid( _fbid, @cid );  -- Get new or old cid
  insert into client ( cid, firstname, lastname )
    values ( @cid, _firstname, _lastname )
    on duplicate key update
      firstname = _firstname,
      lastname = _lastname;

  -- return CustomerID
  return @cid;

end $$  -- end create_account

delimiter ;  -- reset from '$$'