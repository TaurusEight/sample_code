
-- Time-stamp: <2013-10-30 14:19:08 daniel>

-- 'active_subscriptions.sql': Create alist of clients who have an
-- enabled subscription to a service based on the sku number


-- Customer Data Types
-- include(`custom.types.m4')


-- Select the database
use DATABASE;  -- The data used

--
-- Return a list of all Facebook ID, Facebook Page ID and tokens
-- for those clients who have a subscription to this service (SKU).
delimiter $$  -- replace ';'
drop procedure if exists list_of_subscribers $$
create procedure list_of_subscribers (

  _sku sku_t  -- Product ID of subscription

) begin

  -- Get a list of all clients that have this subscription
  -- and it is both enabled and activated.
  select
    client.cid as cid,  -- Customer ID
    concat( client.firstname, ' ', client.lastname ) as fullname,
    facebook.fbid as fbid,  -- Facebook ID
    facebook.token as access_token,  -- Facebook token for Facebook ID
    page.pid as pid,  -- Facebook ID of page selected by customer
    page.token as page_token  -- Facebook ID of page access token
  from
    client,
    facebook,
    page,
    subscription
  where
    facebook.cid = client.cid and
    client.cid = subscription.cid and
    page.sku = _sku and
    page.cid = client.cid and
    page.pid not like '%disabled%' and
    subscription.sku = _sku
  ;  -- end select statements


end $$  --
delimiter ;  -- restore to ';'
