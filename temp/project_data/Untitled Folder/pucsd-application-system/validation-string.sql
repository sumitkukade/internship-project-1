
CREATE TABLE procedureResult (
  result text,
  isResult boolean
);

delimiter |

CREATE PROCEDURE applicationProcess.validatingString(IN line text)
BEGIN
  declare len integer;
  declare count integer;
  declare cnt integer;
  declare string text;
  declare fromState varchar(30);
  declare toState varchar(30);
  declare applicationId varchar(5);
  declare remark text;
  declare params text;
  declare flag boolean;
  declare isAppId integer;
  declare isState integer;
  set count = 1;
  set cnt = 0;
  set flag = 0;
  set len = (select length(line)+1 - (select length(replace(line,",",""))));
  if(len <= 5 and len >= 3) then
     while count<= len do
        set string = (select applicationProcess.split_str(line,",",len-(len-count)));
        set isAppId = (select string in (select appId from applicationProcess.applicationDomain));
        set isState = (select string in (select applicationState from applicationProcess.applicationStateDomain));
        if(isAppId = 1) then
            set applicationId = string;
            set cnt = cnt + 1;
        else if(isState = 1) then
             if(flag = 0) then
                set fromState = string;
                set flag = 1;
                set cnt = cnt + 1;
             else
                set toState = string;
                set flag = 0;
                set cnt = cnt + 1;
             end if;
        else 
              set remark = (select concat_ws(",",remark,string));
        end if;
        end if;
         set count = count + 1;
     End while;
     if(cnt = 3) then
        insert into applicationProcess.procedureResult(result,isResult) values ((select concat_ws(",",applicationId,fromState,toState,remark)),1);
     else
        insert into applicationProcess.procedureResult(result,isResult) values("",0);
     end if;
  else
     insert into applicationProcess.procedureResult(result,isResult) values("",0);
  End if;
END;

  |
delimiter ;
