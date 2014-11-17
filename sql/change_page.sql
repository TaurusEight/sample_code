

-- Time-stamp: <2013-10-30 14:23:22 daniel>

-- 'page.sql': Defines the table that stores information about the page a client
-- has selected for a newslet to be uploaded

-- Custome Data Types
-- include(`custom.types.m4')

-- Select the Database
use DATABASE;


-- Used by before insert and before update trigger
delimiter $$


--
-- If the value of _pid is null or zero
-- use the facebook ID for the customer
drop procedure if exists check_pid $$
create procedure check_pid (

  in _cid int,   -- Customer ID
  inout _pid facebook_t  -- Facebook page ID

) begin

  -- if no PID use the FBID for the PID
  if _pid = '0' or _pid is null then
    select fbid into _pid from facebook where cid = _cid;
  end if;  -- if _pid is 0

end $$  -- end check_pid
delimiter ;



-- Called before insert make sure ID is not null or '0'
-- drop trigger if exists DATABASE.before_page_insert;
--create trigger DATABASE.before_page_insert
--  before insert on DATABASE.page
--  for each row call DATABASE.check_pid( new.cid, new.pid );


-- Called before table has been updated check that ID is not null or '0'
--  drop trigger if exists DATABASE.before_page_update;
--create trigger DATABASE.before_page_update
--  before update on DATABASE.page
--  for each row call DATABASE.check_pid( old.cid, new.pid );


-- Easy procedure for inserting or updating Facebook Page PIDS
delimiter $$


--
-- Change the facebook page associated with this
-- customer subscription.
drop procedure if exists change_page $$
create procedure change_page (

  in _cid cid_t,  -- Customer ID
  in _sku sku_t,  -- Product SKU number
  in _pid facebook_t,  -- Facebook Page ID
  in _token facebook_t  -- Facebook Page Access Token

) begin

  set @token = '0';
  set @pid = _pid;

  call DATABASE.check_pid( _cid, @pid );

  if _token is not null then set @token = _token; end if;

  insert into page ( cid, sku, pid, token )
    values ( _cid, _sku, @pid, @token )
    on duplicate key update pid = @pid, token = @token;

end $$
delimiter ;