
DROP TABLE IF EXISTS applicationProcess.applicationResult;
DROP PROCEDURE IF EXISTS applicationProcess.applicationString;

CREATE TABLE applicationProcess.applicationResult (
  result text,
  isResult boolean
);

delimiter |

CREATE PROCEDURE applicationProcess.applicationString(IN line text)
BEGIN
  declare len integer;
  declare count integer;
  declare cnt integer;
  declare string text;
  declare applicationId varchar(5);
  declare studentRollNumber varchar(15);
  declare isAppId integer;
  declare isrollNumber integer;
  set count = 1;
  set cnt = 0;
  set len = (select length(line)+1 - (select length(replace(line,",",""))));
  if(len = 1) then
        set isAppId = (select line in (select appId from applicationProcess.applicationDomain));
        set isrollNumber = (select line in(select rollNumber from applicationProcess.studentDetailsDomain));
        if(isrollNumber = 1) then
           set studentRollNumber = line;
           set cnt = cnt + 1;
        end if;
        if(isAppId = 1) then
            set applicationId = line;
            set cnt = cnt + 1;
        end if;
     if(cnt = 1) then
       if(isAppId = 1) then
        insert into applicationProcess.applicationResult(result,isResult) values (applicationId,1);
       else
         insert into applicationProcess.applicationResult(result,isResult) values (studentRollNumber,2);
       end if;

     else
        insert into applicationProcess.applicationResult(result,isResult) values("",0);
     end if;
  else
     insert into applicationProcess.applicationResult(result,isResult) values("",0);
  End if;
END;

  |
delimiter ;
