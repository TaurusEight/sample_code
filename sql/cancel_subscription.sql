
-- Time-stamp: <2013-10-11 14:04:15 daniel>

-- 'deactivate_subscription.sql': Turn on a customers subscription

-- Custom Type Definitions and other macros
-- include(`custom.types.m4')

-- Database used
use DATABASE;


-- Start by changing line-end character
delimiter $$  -- change from ';'


--
-- Turn off a customers subscription but do not
-- remove data from the database.  Subscription maybe
-- turned on again later.
drop procedure if exists cancel_subscription $$
create procedure cancel_subscription (

  in _plid platypus_t,  -- Platypus ID
  in _sku sku_t  -- Product ID

) begin

  -- Make sure we have a good Customer ID
  call find_customer_from_plid( _plid, @cid );

  update subscription set active = false
    where cid = @cid and sku = _sku;

end $$  -- end cancel_subscription
delimiter ;  -- reset from '$$'