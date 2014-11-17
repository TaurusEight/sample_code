

-- Time-stamp: <2013-10-11 13:12:04 daniel>

-- 'renew_subscription.sql': Called when a subscription needs to be renewed.

-- Custome Data Types
-- include(`custom.types.m4')

-- Select the Database
use DATABASE;


delimiter $$  -- Change from ';'

--
-- Called by platypus to renew a customer subscription
drop procedure if exists renew_subscription $$
create procedure DATABASE.renew_subscription (

  in _plid platypus_t,  -- ID from platypus
  in _sku sku_t  -- Product ID

) begin

  -- Get the customer ID based on the platypus ID
  select cid into @cid from platypus where plid = _plid;

  -- Set subscription to active for this customer
  update subscription set active = true where cid = @cid and sku = _sku;

end $$  -- end renew_subscription
delimiter ;  -- reset back from '$$'
