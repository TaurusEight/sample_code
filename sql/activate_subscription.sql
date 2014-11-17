
-- Time-stamp: <2013-10-09 13:15:09 daniel>

-- 'activate_subscription.sql': Turn on a customers subscription

-- Custom Type Definitions and other macros
-- include(`custom.types.m4')

-- Database used
use DATABASE;


-- Start by changing line-end character
delimiter $$  -- change from ';'


--
-- Turn on a subscription
drop procedure if exists activate_subscription $$
create procedure activate_subscription (

  in _cust_id short_string_t,  -- customer ID
  in _sku sku_t,  -- Product ID
  in _plid platypus_t  -- Platypus ID

) begin

  -- Make sure we have a good Customer ID
  if _cust_id = 'no-value' then

    call find_customer_from_plid( _plid, @cid );

  else

    set @cid = cast( _cust_id as unsigned integer );

    -- Update platypus with the clients possible new plid
    insert into platypus ( cid, plid )
      values ( @cid, _plid )
      on duplicate key update cid = @cid;


  -- Check to see if a page already exists
  -- for this subscription
  select pid into @pid from page
    where sku = _sku and cid = @cid;
  if @pid is null then  -- means there is no entery
    call change_page( @cid, _sku, null, null );
  end if;  -- if @pid is null

  end if;  -- if _cid = 'no-value'


  -- Turn on this customers subscription
  insert into subscription ( cid, sku, active )
    values ( @cid, _sku, true )
    on duplicate key update active = true;


end $$  -- end activate_subscription


delimiter ;  -- reset from '$$'
