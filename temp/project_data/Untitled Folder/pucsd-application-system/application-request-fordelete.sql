DROP TRIGGER IF EXISTS applicationProcess.triggerForDelete;

/* this trigger for delete the record as per paramete by student gives in inputRequests table */

delimiter |

CREATE TRIGGER applicationProcess.triggerForDelete after insert on applicationProcess.aux_applicationRequestsDelete
FOR EACH ROW
  BEGIN
    set @string = NEW.params;
    set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
    set @startState = (select applicationProcess.split_str(@string,",",@len-(@len-2)));
    set @endState = (select applicationProcess.split_str(@string,",",@len-(@len-3)));
    set @validStartState = (select @startState in (select fromState from requestStateTransitions where userId=NEW.userId or userId=@userId));
    set @validEndState = (select @endState in (select toState from requestStateTransitions where userId=NEW.userId or userId=@userId));
    set @requestId = (select requestId from applicationProcess.requestStateTransitions where fromState = @startState and toState = @endState order by requestId desc limit 1);
    if(@validStartState = 1 and @validEndState = 1) then
        delete from applicationProcess.applicationRequests where requestId = @requestId;
        delete from applicationProcess.aux_requestStateTransitions where requestId = @requestId;
        delete from applicationProcess.aux_studentAndState where fromState = @startState and toState = @endState;
        delete from applicationProcess.requestStateTransitions where requestId = @requestId;
        delete from userInputDatabase.outputResults where requestId = @requestId;
        delete from userInputDatabase.outputErrorMsgs where requestId = @requestId;
     else
        insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=@startState));
     end if;
  END;



  |
delimiter ;
