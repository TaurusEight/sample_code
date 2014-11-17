
-- Time-stamp: <2014-02-03 15:45:52 ad7tb>

-- include(`custom.types.m4')


--
-- Select the database to be used
use DATABASE;


--
-- Change the end of line character
delimiter $$  -- change from ';'


--
-- Return a list of token/cid pairs that are 45 or more days old
drop procedure if exists expiring_tokens $$
create procedure expiring_tokens () begin

  -- Select all tokens and CIDs older than 45 days
  select fbid, token, cid
    from facebook
    where tstamp <= ( now() - interval 45 day )
      and tstamp > ( now() - interval 61 day )
    order by cid;

end $$  -- end expiring_tokens


--
-- Insert the token into the table 'facebook'
drop procedure if exists store_customer_token $$
create procedure store_customer_token (

  _fbid facebook_t,  -- customers facebook id
  _token facebook_t  -- access token for customers facebook account

) begin

  update facebook
    set token = _token,
        tstamp = current_timestamp
    where fbid = _fbid;

end $$  -- end store_customer_token

--
-- Given a cid return the long term access token or zero if not found
drop function if exists find_token $$
create function find_token (

  _cid  cid_t   -- Customer ID

) returns facebook_t deterministic
begin

  set @duration = 45;  -- number of days old token can be
  set @token = null;  -- return value

  select tid into @token
    from token
    where cid = _cid and tstamp > subdate( current_timestamp, @duration );

  if @token is null then set @token = 'no-value'; end if;
  return @token;

end  $$  -- end create find_token

delimiter ;  -- restore from '$$'
