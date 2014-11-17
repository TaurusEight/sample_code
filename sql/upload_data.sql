

-- Time-stamp: <2014-08-02 21:45:16 daniel>


-- 'upload_data.sql': Find all information about a client service based on
-- their platypus ID number and the subscription SKU


-- Custom type definitions and other macros
-- include(`custom.types.m4')


-- Database to use - most likely 'newslets'
use DATABASE


-- Start by changing the line-end character
delimiter $$  -- change from ';'


--
-- Return enough client information to upload their newslet
-- and log enough information to keep Donna happy
drop procedure if exists upload_data $$
create procedure upload_data (

  in _plid platypus_t,  -- platypus id of the client
  in _sku sku_t  -- sku of the service to be uploaded

) begin

  declare _cid cid_t default null;
--   set @cid = null;  -- default value to start with
  call find_customer_from_plid( _plid, _cid );  -- get CID from PLID

  select

    client.firstname as firstname,
    client.lastname as lastname,
    client.cid as cid,
    subscription.enabled as enabled,
    facebook.fbid as fbid,
    page.sku as sku,
    page.pid as pid,
    page.token as token,
    service.directory as directory,
    service.album as album

  from

    client,
    subscription,
    facebook,
    page,
    service

  where

        client.cid = _cid
    and subscription.cid = client.cid
    and subscription.sku = _sku
    and facebook.cid = _cid
    and page.cid = _cid
    and page.sku = _sku
    and service.sku = _sku

  ;

end $$  -- end upload_data

delimiter ;  -- reset from '$$'