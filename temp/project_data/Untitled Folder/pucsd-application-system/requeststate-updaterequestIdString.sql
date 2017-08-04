DROP PROCEDURE IF EXISTS applicationProcess.validateUpdatedrequestIdString;
DROP TABLE IF EXISTS applicationProcess.requestIdStringResult;

CREATE TABLE IF NOT EXISTS applicationProcess.requestIdStringResult (
  isResult integer NOT NULL,
  result text NOT NULL
);

delimiter |

CREATE PROCEDURE applicationProcess.validateUpdatedrequestIdString(IN line text)
BEGIN
  declare len integer;
  declare count integer;
  declare cnt integer;
  declare string text;
  declare fromState text;
  declare toState text;
  declare applicationId varchar(5);
  declare rqstId bigint;
  declare remark text;
  declare params text;
  declare flag boolean;
  declare isAppId integer;
  declare isState integer;
  declare isrqstId  integer;
  set count = 1;
  set cnt = 0;
  set flag = 0;
  set len = (select length(line)+1 - (select length(replace(line,",",""))));
  if(len <= 8 and len >= 5) then
     while count<= len do
        set string = (select applicationProcess.split_str(line,",",len-(len-count)));
        set isAppId = (select string in (select appId from applicationProcess.applicationDomain));
        set isState = (select string in (select applicationState from applicationProcess.applicationStateDomain));
        set isrqstId = (select string in (select requestId from userInputDatabase.inputRequests where requestId = string));
        if(isAppId = 1) then
            set applicationId = string;
            set cnt = cnt + 1;
        else if(isState = 1) then
             if(flag = 0) then
                set fromState = (select concat_ws(",",fromState,string));
                set flag = 1;
                set cnt = cnt + 1;
             else
                set toState = (select concat_ws(",",toState,string));
                set flag = 0;
                set cnt = cnt + 1;
             end if;
        else if(isrqstId = 1) then
             set rqstId = string;
             set cnt = cnt + 1;
        else
             set remark = (select concat_ws(",",remark,string));
        end if;
        end if;
        end if;
         set count = count + 1;
     End while;
     if(cnt = 6) then
        insert into applicationProcess.requestIdStringResult(result,isResult) values ((select concat_ws(",",applicationId,fromState,toState,rqstId,remark)),1);
     else
        insert into applicationProcess.requestIdStringResult(result,isResult) values("",0);
     end if;
  else
     insert into applicationProcess.requestIdStringResult(result,isResult) values("",0);
  End if;
END;

  |
delimiter ;
