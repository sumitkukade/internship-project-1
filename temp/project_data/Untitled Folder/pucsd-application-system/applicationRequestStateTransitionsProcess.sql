DROP TRIGGER IF EXISTS applicationProcess.insertInRequestStateTransitions;

CREATE TABLE aux_studentApplicationCount (
  requestId bigint NOT NULL,
  rollNumber varchar(15) NOT NULL,
  appId varchar(5) NOT NULL,
  appCnt integer NOT NULL,
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(rollNumber) References studentDetailsDomain(rollNumber)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

delimiter |

CREATE TRIGGER applicationProcess.insertInRequestStateTransitions after insert on applicationProcess.applicationRequests
FOR EACH ROW
  BEGIN
    set @string = NEW.params;
    set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
    set @appcntId = (select applicationProcess.split_str(@string,",",@len-(@len-1)));
    set @startState = (select applicationProcess.split_str(@string,",",@len-(@len-2)));
    set @endState = (select applicationProcess.split_str(@string,",",@len-(@len-3)));
    set @validuserId = (select userId from applicationProcess.applicationRequests where appId = @appcntId order by userId limit 1);
    set @validState = (select @startState in (select toState from applicationProcess.aux_requestStateTransitions where userId = NEW.userId and appId = @appcntId));
    set @validRequestFromStudent = (select @startState in (select studentActionFrom from studentActionDomain));
    set @validRequestToStudent = (select @endState in (select studentActionTo from studentActionDomain));
    set @applicationSubmitStatus = (select studentActionTo from applicationProcess.studentActionDomain where studentActionTo in (select staffActionFrom from applicationProcess.staffActionDomain) order by studentActionTo asc limit 1);
    set @certificate = (select @startState in (select toState from aux_studentAndState where rollNumber=NEW.userId));
    set @appcnt = (select appcnt from applicationProcess.studentApplicationCount where appId = @appcntId and rollNumber = NEW.userId order by appcnt desc limit 1);
    set @applimit = (select appcnt from applicationProcess.applicationCntDomain where appId = @appcntId);
    set @studentApplyId = (select NEW.userId in (select rollNumber from applicationProcess.applicationForm));
    if(@validRequestFromStudent = 1 and @validRequestToStudent = 1 and @studentApplyId = 1) then
       set @duplicateState = (select NEW.userId in (select userId from aux_requestStateTransitions where userId = NEW.userId and fromState = (select applicationProcess.split_str(@string,",",@len-(@len-2))) and toState = @endState and appId = @appcntId));
       if(@duplicateState = 1) then
         insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgForState from userInputDatabase.messagesForUsersDomain where msgId=@startState));
       else
          if(@applimit = @appcnt) then
               set @appCntExists = (select @appcnt in (select appcnt from applicationProcess.aux_studentApplicationCount where rollNumber = NEW.userId and appId =@appcntId));
               insert into applicationProcess.aux_studentApplicationCount(requestId,rollNumber,appId,appcnt) values(NEW.requestId,NEW.userId,@appcntId,@appcnt);
               if(@appCntExists = 0) then 
                   insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=(select applicationState from applicationProcess.startAndfinalStateDomain order by applicationState limit 1)),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=(select applicationState from applicationProcess.startAndfinalStateDomain order by applicationState limit 1)));
              end if;
          else if(@startState = (select applicationState from startAndfinalStateDomain order by applicationState desc limit 1)) then
               insert into applicationProcess.aux_requestStateTransitions(requestId,fromState,toState,userId,appId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,@appcntId,NEW.requestArrivalTime,NEW.remark,@string);
               insert into applicationProcess.requestStateTransitions(requestId,fromState,toState,userId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,NEW.requestArrivalTime,NEW.remark,@string);
               insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select concat(@startState,",",@endState)));
         else if(@validState = 1 or @certificate = 1) then
              if(@endState = @applicationSubmitStatus) then
                insert into applicationProcess.studentApplicationQueue(requestId,rollnumber,appId,requestArrivalTime,fromState,toState) values(NEW.requestId,NEW.userId,NEW.appId,NOW(),@startState,@endState);
              insert into aux_studentAndState(requestId,rollNumber,fromState,toState,appId) values(NEW.requestId,NEW.userId,@startState,@endState,@appcntId);
              else if(@certificate = 1) then
                insert into aux_studentAndState(requestId,rollNumber,fromState,toState,appId) values(NEW.requestId,NEW.userId,@startState,@endState,@appcntId);
                insert into applicationProcess.studentApplicationCount(requestId,rollnumber,appId) values(NEW.requestId,NEW.userId,@applicationId);
                update applicationProcess.studentApplicationCount set appcnt = appcnt + 1 where rollnumber = NEW.userId and appId = @applicationId;
                delete from applicationProcess.applicationRequestByStaff;
              end if;
              end if;
              insert into applicationProcess.aux_requestStateTransitions(requestId,fromState,toState,userId,appId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,@appcntId,NEW.requestArrivalTime,NEW.remark,@string);
              insert into applicationProcess.requestStateTransitions(requestId,fromState,toState,userId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,NEW.requestArrivalTime,NEW.remark,@string);
               insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select concat(@startState,",",@endState)));
         else
               insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=@startState));
         end if;
         end if;
         end if;
       end if;
    else
           insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=@startState));

    end if;
  END;

  |
delimiter ;
