
-- Time-stamp: <2014-02-11 11:28:24 ad7tb>

-- 'service_by_hour.sql': Return a list of services based on
-- the hour listed in the table 'service' under 'hr'.


-- Customer Data Types
-- include(`custom.types.m4')


-- Select the database
use DATABASE;


--
-- Based on the current time create a list of services that
-- are set to be uploaded to customers now
delimiter $$
drop procedure if exists services_by_hour $$
create procedure services_by_hour ( )
begin

  set @hr = hour( now() );  -- Current hour of the day

  select
    service.sku as sku,
    service.directory as directory,
    service.album as album
  from service
  where service.hr = @hr and service.active = 1;

end $$  -- create services_by_hour
delimiter ;
-- services_by_hour