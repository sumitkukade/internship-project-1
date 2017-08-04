DROP TRIGGER IF EXISTS applicationProcess.triggerForUpdate;

/* this trigger for update the record as per paramete by student gives in inputRequests table */


delimiter |


CREATE TRIGGER applicationProcess.triggerForUpdate after insert on applicationProcess.aux_applicationRequestsUpdate
FOR EACH ROW
  BEGIN
    set @string = NEW.params;
    set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
    set @startState = (select applicationProcess.split_str(@string,",",@len-(@len-2)));
    set @newStartState = (select applicationProcess.split_str(@string,",",@len-(@len-4)));
    set @endState = (select applicationProcess.split_str(@string,",",@len-(@len-3)));
    set @newEndState = (select applicationProcess.split_str(@string,",",@len-(@len-5)));
    set @validStartState = (select @startState in (select fromState from requestStateTransitions where userId=NEW.userId or userId=@userId));
    set @validEndState = (select @endState in (select toState from requestStateTransitions where userId=NEW.userId or userId=@userId));
    set @requestId = (select requestId from applicationProcess.requestStateTransitions where fromState = @startState and toState = @endState order by requestId desc limit 1);
    set @tableIdx = (select tableIndex from userInputDatabase.tableIdDomain where tableId = (select tableId from userInputDatabase.inputRequests where requestId = @requestId));
    if(@validStartState = 1 and @validEndState = 1) then
        delete from applicationProcess.applicationRequests where requestId = @requestId;
        delete from applicationProcess.requestStateTransitions where requestId = @requestId;
        delete from userInputDatabase.outputResults where requestId = @requestId;
        delete from userInputDatabase.outputErrorMsgs where requestId = @requestId;
        set @string1 = (select concat_ws(",",NEW.appId,@newStartState,@newEndState));
        if(@tableIdx = 1) then
           insert into applicationProcess.applicationRequests(requestId,appId,userId,requestArrivalTime,remark,params) values(@requestId,@applicationId,NEW.userId,NOW(),(select applicationProcess.split_str(@string,",",@len-(@len-6))),@string1);
        else if(@tableIdx = 2) then
           insert into applicationProcess.applicationRequestByStaff(requestId,appId,userId,requestArrivalTime,remark,params) values(@requestId,@applicationId,NEW.userId,NOW(),(select applicationProcess.split_str(@string,",",@len-(@len-6))),@string1);
        end if;
        end if;
     else
        insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=@startState));
     end if;
  END;


  |
delimiter ;
