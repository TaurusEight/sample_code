

-- Time-stamp: <2013-10-11 13:09:49 daniel>

-- 'initialize_subscription.sql': Called to setup a subscription
-- when a customer first buys it.

-- Custome Data Types
-- include(`custom.types.m4')

-- Select the Database
use DATABASE;


--
-- Called by platypus when a customer first buys
delimiter $$

drop procedure if exists initialize_subscription $$
create procedure DATABASE.initialize_subscription (

  in _cid int unsigned,  -- customer ID
  in _plid platypus_t,  -- ID from platypus
  in _sku sku_t  -- Product ID

) begin


  -- check 'page' table for current entry
  select pid into @pid from page where cid = _cid and sku = _sku;
  if @pid is null then
    insert into page ( cid, sku ) values ( _cid, _sku );
  end if;  -- if pid is null


  -- update 'platypus' table - put _plid into it
  insert into platypus ( cid, plid ) values ( _cid, _plid )
    on duplicate key update cid = _cid;

  -- update 'subscription'
  insert into subscription ( cid, sku, active ) values ( _cid, _sku, true )
    on duplicate key update active = true;


end $$  -- end initialize_subscription
delimiter ;  -- reset back from '$$'
