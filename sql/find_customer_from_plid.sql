
-- Time-stamp: <2013-10-08 12:38:43 daniel>

-- 'find_customer_from_plid.sql': Turn on a customers subscription

-- Custom Type Definitions and other macros
-- include(`custom.types.m4')

-- Database used
use DATABASE;


-- Start by changing line-end character
delimiter $$  -- change from ';'


--
-- Return a Customer ID from the table 'platypus'
-- based on the Platypus customer ID
drop procedure if exists find_customer_from_plid $$
create procedure find_customer_from_plid (

  in _plid platypus_t,  -- Customer Platypus ID
  out _cid cid_t  -- Customer ID

) begin


  set _cid = null;  -- default value for _cid

  select cid into _cid from platypus where plid = _plid;
  if _cid is null then
    call throw_error( concat( "No 'cid' associated with 'plid': ", _plid ) );
  end if;  -- if _cid is null

end $$  -- end find_customer_from_plid


delimiter ;  -- reset from '$$'