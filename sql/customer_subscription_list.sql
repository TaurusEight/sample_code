
-- Time-stamp: <2014-05-16 10:35:39 ad7tb>

-- 'customer_subscription_list.sql': Create alist of clients who have an
-- enabled subscription to a service based on the sku number


-- Customer Data Types
-- include(`custom.types.m4')


-- Select the database
use newslets;

--
-- Return a list of all Facebook ID, Facebook Page ID and tokens
-- for those clients who have a subscription to this service (SKU).
drop procedure if exists newslets.customer_subscription_list;
delimiter $$  -- replace ';'
create procedure newslets.customer_subscription_list (

  _cid cid_t  -- Product SKU number of service

) begin

  select

    service.description as description,
    subscription.cid as cid,
    subscription.sku as sku,
    page.pid as pid

  from

    service,
    subscription,
    page

  where

    service.sku = subscription.sku and
    subscription.cid = _cid and
    subscription.active = true and
    page.sku = subscription.sku and
    page.cid = _cid

  order by

    service.description

  ;



end $$
delimiter ;  -- restore
