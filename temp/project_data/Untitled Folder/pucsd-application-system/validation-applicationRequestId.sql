
DROP TABLE IF EXISTS applicationProcess.applicationRequestResult;
DROP PROCEDURE IF EXISTS applicationProcess.applicationRequestIdvalidation;
DROP PROCEDURE IF EXISTS applicationProcess.applicationRequestIdupdatation;

CREATE TABLE applicationProcess.applicationRequestResult (
  result text,
  isResult boolean
);


delimiter |

CREATE PROCEDURE applicationProcess.applicationRequestIdvalidation(IN line text)
BEGIN
  declare len integer;
  declare count integer;
  declare cnt integer;
  declare string text;
  declare applicationId varchar(5);
  declare fromState varchar(15);
  declare toState varchar(15);
  declare reqstId bigint;
  declare isrequestId integer;
  declare isAppId integer;
  declare isState integer;
  declare flag integer;
  set count = 1;
  set flag = 0;
  set cnt = 0;
  set len = (select length(line)+1 - (select length(replace(line,",",""))));
  if(len = 2) then
     while(count <= len) do
        set string = (select applicationProcess.split_str(line,",",len-(len-count)));
        set isAppId = (select string in (select appId from applicationProcess.applicationDomain));
        set isrequestId = (select string in (select requestId from userInputDatabase.inputRequests where requestId = string));
        if(isAppId = 1) then
            set applicationId = string;
            set cnt = cnt + 1;
        else if(isrequestId = 1) then
            set reqstId = string;
            set cnt = cnt + 1;
        end if;
        end if;
        set count = count + 1;
     end while;
     if(cnt = 2 ) then
        insert into applicationProcess.applicationRequestResult(result,isResult) values ((select concat_ws(",",reqstId,applicationId)),1);
     else
        insert into applicationProcess.applicationRequestResult(result,isResult) values("",0);
     end if;
  else
     insert into applicationProcess.applicationRequestResult(result,isResult) values("",0);
  End if;
END;

CREATE PROCEDURE applicationProcess.applicationRequestIdupdatation(IN line text)
BEGIN
  declare len integer;
  declare count integer;
  declare cnt integer;
  declare string text;
  declare applicationId text;
  declare fromState varchar(15);
  declare toState varchar(15);
  declare reqstId bigint;
  declare isrequestId integer;
  declare isAppId integer;
  declare isState integer;
  declare flag integer;
  set count = 1;
  set flag = 0;
  set cnt = 0;
  set len = (select length(line)+1 - (select length(replace(line,",",""))));
  if(len = 3) then
     while(count <= len) do
        set string = (select applicationProcess.split_str(line,",",len-(len-count)));
        set isAppId = (select string in (select appId from applicationProcess.applicationDomain));
        set isrequestId = (select string in (select requestId from userInputDatabase.inputRequests where requestId = string));
        if(isAppId = 1) then
            set applicationId = (select concat_ws(",",applicationId,string));
            set cnt = cnt + 1;
        else if(isrequestId = 1) then
            set reqstId = string;
            set cnt = cnt + 1;
        end if;
        end if;
        set count = count + 1;
     end while;
     if(cnt = 3 ) then
        insert into applicationProcess.applicationRequestResult(result,isResult) values ((select concat_ws(",",reqstId,applicationId)),1);
     else
        insert into applicationProcess.applicationRequestResult(result,isResult) values("",0);
     end if;
  else
     insert into applicationProcess.applicationRequestResult(result,isResult) values("",0);
  End if;
END;

  |
delimiter ;
