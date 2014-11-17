
-- Time-stamp: <2013-10-24 20:24:28 daniel>

-- 'kill_customer.sql': Delete all trace of customer from database

-- Custom Data Types
-- include(`custom.types.m4')

-- Select the Database
use DATABASE;


delimiter $$  -- Change from ';'

--
-- Make sure this procedure is only defined once
drop procedure if exists kill_customer $$
create procedure kill_customer (

  in _cid cid_t  -- customer id

) begin

  delete from subscription where cid = _cid;
  delete from platypus where cid = _cid;
  delete from page where cid = _cid;
  delete from client where cid = _cid;
  delete from facebook where cid = _cid;

end $$  -- end kill_customer

delimiter ;  -- Restore from '$$'
