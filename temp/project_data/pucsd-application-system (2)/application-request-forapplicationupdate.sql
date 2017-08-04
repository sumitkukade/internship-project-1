DROP TRIGGER IF EXISTS applicationProcess.triggerForUpdate;

/* this trigger for update the record as per paramete by student gives in inputRequests table */

delimiter |


CREATE TRIGGER applicationProcess.triggerForapplicationIdUpdate after insert on applicationProcess.aux_applicationRequestsUpdateappId
FOR EACH ROW
  BEGIN
    set @string = NEW.params;
    set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
    set @startState = (select applicationProcess.split_str(@string,",",@len-(@len-2)));
    set @endState = (select applicationProcess.split_str(@string,",",@len-(@len-3)));
    set @validStartState = (select @startState in (select fromState from requestStateTransitions where userId=NEW.userId or userId=@userId));
    set @validEndState = (select @endState in (select toState from requestStateTransitions where userId=NEW.userId or userId=@userId));
    if(@validStartState = 1 and @validEndState = 1) then
        delete from applicationProcess.applicationRequests where requestId = NEW.requestId;
        delete from applicationProcess.requestStateTransitions where requestId = NEW.requestId;
        delete from userInputDatabase.outputResults where requestId = NEW.requestId;
        delete from userInputDatabase.outputErrorMsgs where requestId = NEW.requestId;
        insert into applicationProcess.applicationRequests(requestId,appId,userId,requestArrivalTime,remark,params) values(NEW.requestId,NEW.appId,NEW.userId,NOW(),NEW.remark,NEW.params);
     else
        insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=@startState));
     end if;
  END;

  |
delimiter ;
