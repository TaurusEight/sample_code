

-- Time-stamp: <2013-10-24 13:47:43 daniel>

-- 'toggle_subscription.sql': Called when customer toggles a subscription.

-- Custome Data Types
-- include(`custom.types.m4')

-- Select the Database
use DATABASE;


delimiter $$  -- Change from ';'

--
-- Called by platypus to toggle a customer subscription
drop procedure if exists toggle_subscription $$
create procedure toggle_subscription (

  in _cid cid_t,  -- Customer ID
  in _sku sku_t  -- Product ID

) begin

  -- Toggle the value in 'enabled'
  update subscription
    set enabled = not enabled
    where cid = _cid and sku = _sku;

end $$  -- end toggle_subscription
delimiter ;  -- reset back from '$$'
