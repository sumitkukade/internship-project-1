
DROP TABLE IF EXISTS applicationProcess.requestResult;
DROP PROCEDURE IF EXISTS applicationProcess.requestString;

CREATE TABLE applicationProcess.requestResult (
  result text,
  isResult boolean
);

delimiter |

CREATE PROCEDURE applicationProcess.requestString(IN line text)
BEGIN
  declare len integer;
  declare count integer;
  declare cnt integer;
  declare string text;
  declare applicationId varchar(5);
  declare userName varchar(15);
  declare isAppId integer;
  declare isuser integer;
  set count = 1;
  set cnt = 0;
  set len = (select length(line)+1 - (select length(replace(line,",",""))));
  if(len = 2) then
     while count<= len do
        set string = (select applicationProcess.split_str(line,",",len-(len-count)));
        set isAppId = (select string in (select appId from applicationProcess.applicationDomain));
        set isuser = (select string in (select userId from applicationProcess.userIdDomain));
        if(isAppId = 1) then
            set applicationId = string;
            set cnt = cnt + 1;
        else if(isuser = 1) then
            set userName = string;
            set cnt = cnt + 1;
        end if;
        end if;
         set count = count + 1;
     End while;
     if(cnt = 2) then
        insert into applicationProcess.requestResult(result,isResult) values ((select concat_ws(",",userName,applicationId)),1);
     else
        insert into applicationProcess.requestResult(result,isResult) values("",0);
     end if;
  else
     insert into applicationProcess.requestResult(result,isResult) values("",0);
  End if;
END;

  |
delimiter ;
