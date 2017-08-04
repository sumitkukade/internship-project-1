DROP PROCEDURE IF EXISTS applicationProcess.validateUpdatedString;
DROP TABLE IF EXISTS applicationProcess.requestStringResult;

CREATE TABLE IF NOT EXISTS applicationProcess.requestStringResult (
  isResult integer NOT NULL,
  result text NOT NULL
);

delimiter |

CREATE PROCEDURE applicationProcess.validateUpdatedString(IN line text)
BEGIN
  declare len integer;
  declare count integer;
  declare cnt integer;
  declare string text;
  declare fromState text;
  declare toState text;
  declare applicationId varchar(5);
  declare remark text;
  declare params text;
  declare flag boolean;
  declare isAppId integer;
  declare isState integer;
  declare isrequestId integer;
  declare rqstID bigint;
  set count = 1;
  set cnt = 0;
  set flag = 0;
  set len = (select length(line)+1 - (select length(replace(line,",",""))));
  if((len <= 7 and len >= 5) or (len <= 8 and len >=  5)) then
     while count<= len do
        set string = (select applicationProcess.split_str(line,",",len-(len-count)));
        set isAppId = (select string in (select appId from applicationProcess.applicationDomain));
        set isState = (select string in (select applicationState from applicationProcess.applicationStateDomain));
        set isrequestId = (select string in (select requestId from userInputDatabase.inputRequests));
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
        else if(isrequestId = 1) then
             set rqstID = string;
             set cnt = cnt + 1;
        else
              set remark = (select concat_ws(",",remark,string));
        end if;
        end if;
        end if;
         set count = count + 1;
     End while;
     if(cnt = 5) then
        insert into applicationProcess.requestStringResult(result,isResult) values ((select concat_ws(",",applicationId,fromState,toState,remark)),1);
     else if(cnt = 6) then
        insert into applicationProcess.requestStringResult(result,isResult) values ((select concat_ws(",",rqstID,applicationId,fromState,toState,remark)),2);
     else
        insert into applicationProcess.requestStringResult(result,isResult) values("",0);
     end if;
     end if;
  else
     insert into applicationProcess.requestStringResult(result,isResult) values("",0);
  End if;
END;

  |
delimiter ;
