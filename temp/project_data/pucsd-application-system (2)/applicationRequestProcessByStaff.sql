DROP TRIGGER IF EXISTS applicationProcess.triggerApplicationRequestByStaff;

CREATE TABLE studentAppllicationQueueCnt (
  applicantCnt integer default 0
);

/*it check for studentApplicationQueue if student is requested for his application the staff do the application process. the all state are stored within its requestId */

delimiter |


CREATE TRIGGER applicationProcess.triggerApplicationRequestByStaff after insert on applicationRequestByStaff
FOR EACH ROW
  BEGIN
    set @string = NEW.params;
    set @studentUserId = (select rollnumber from applicationProcess.studentApplicationQueue where requestId = (select min(requestId) from applicationProcess.studentApplicationQueue));
    set @studentApplicationQueueLen = (select count(*) from applicationProcess.studentApplicationQueue);
    set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
    set @applicationId = (select applicationProcess.split_str(@string,",",@len-(@len-1)));
    set @startState = (select applicationProcess.split_str(@string,",",@len-(@len-2)));
    set @endState = (select applicationProcess.split_str(@string,",",@len-(@len-3)));
    set @applicationuserID = (select applicationProcess.split_str(@string,",",@len-(@len-4)));
    set @isUserID = (select @applicationuserID in (select rollNumber from applicationProcess.studentDetailsDomain where rollNumber = @applicationuserID));
    set @applicationSubmitStatus = (select studentActionTo from applicationProcess.studentActionDomain where studentActionTo in (select staffActionFrom from applicationProcess.staffActionDomain) order by studentActionTo asc limit 1);
    set @validState = (select @startState in (select toState from requestStateTransitions where userId = NEW.userId or userId = @studentUserId));
    set @validRequestFromStaff = (select @startState in (select staffActionFrom from staffActionDomain));
    set @validRequestToStaff = (select @endState in (select staffActionTo from staffActionDomain));
    set @applicationFormodification = (select @endState = (select applicationState from applicationProcess.modificationStateDomain order by applicationState limit 1));
    set @applicationFormodificationSucc = (select @endState  = (select applicationState from applicationProcess.modificationStateDomain order by applicationState limit 1,1));
    set @cntForTheModification = (select count(*) from applicationProcess.modificationInApplication);
    if(@validRequestFromStaff = 1 and @validRequestToStaff = 1) then
       set @duplicateState = (select NEW.userId in (select userId from aux_requestStateTransitions where userId = NEW.userId and fromState = (select applicationProcess.split_str(@string,",",@len-(@len-2))) and toState = @endState and appId = @applicationId));
       set @validState1 = (select @startState in (select toState from requestStateTransitions));
      if(@duplicateState = 1 and @studentApplicationQueueLen = 0 and @cntForTheModification = 0) then
        insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgForState from userInputDatabase.messagesForUsersDomain where msgId = @startState));
       else
           if(@validState = 1 or @validState1 = 1) then
               set @finishState = (select applicationState from applicationProcess.startAndfinalStateDomain order by applicationState limit 1);
               if(@studentApplicationQueueLen = 0 and @cntForTheModification = 0) then
                 insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from     userInputDatabase.messagesForUsersDomain where msgId=@endState),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=@endState));
                  delete from aux_studentAndState;
               else
                insert into applicationProcess.studentAppllicationQueueCnt(applicantCnt) values (applicantCnt + @studentApplicationQueueLen);
                set @applicantqueueCnt = (select applicantCnt from applicationProcess.studentAppllicationQueueCnt order by applicantCnt desc limit 1);
                set @statusDoneForStudent = (select rollnumber from applicationProcess.studentApplicationQueue where requestId in (select min(requestId) from applicationProcess.studentApplicationQueue where rollnumber in (select rollnumber from applicationProcess.studentApplicationQueue where rollnumber not in (select rollNumber from applicationProcess.aux_studentAndState where appId = NEW.appId and fromState = @startState and toState = @endState) and appId = NEW.appId)));
                set @duplcateStatus = (select @statusDoneForStudent in (select rollNumber from aux_studentAndState where fromState = @startState and toState = @endState and appId = NEW.appId));
                set @validStatusForStudent = (select @startState in (select toState from applicationProcess.aux_studentAndState where rollNumber=@statusDoneForStudent and appId = NEW.appId));
                   if(@duplicateState = 1) then
                       if(@applicationFormodification = 1 and @duplcateStatus = 0 and @validStatusForStudent = 1) then
                          delete from applicationProcess.studentApplicationQueue where rollnumber = @statusDoneForStudent and appId = NEW.appId;
                          insert into applicationProcess.modificationInApplication(requestId,appId,userId,requestArrivalTime,remark,params) values(NEW.requestId,NEW.appId,@statusDoneForStudent,NOW(),NEW.remark,NEW.params);
                          insert into aux_studentAndState(requestId,rollNumber,fromState,toState,appId) values(NEW.requestId,@statusDoneForStudent,@startState,@endState,NEW.appId);
                          insert into applicationProcess.requestStateTransitions(requestId,fromState,toState,userId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,NEW.requestArrivalTime,NEW.remark,@string);
                          insert into applicationProcess.aux_requestStateTransitions(requestId,fromState,toState,userId,appId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,@applicationId,NEW.requestArrivalTime,NEW.remark,@string);
                          insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select concat(@startState,",",@endState)));
                       else if(@applicationFormodificationSucc = 1 and @isUserID = 1) then
                           set @duplcateStatus = (select @applicationuserID in (select rollNumber from aux_studentAndState where fromState = @startState and toState = @endState and appId = NEW.appId));
                           set @validStatusForStudent = (select @startState in (select toState from applicationProcess.aux_studentAndState where rollNumber=@applicationuserID and appId = NEW.appId));
                         if(@validStatusForStudent = 1 and @duplcateStatus = 0) then
                           delete from applicationProcess.modificationInApplication where userId = @applicationuserID and appId = NEW.appId;
                           insert into applicationProcess.studentApplicationQueue(requestId,rollnumber,appId,requestArrivalTime,fromState,toState)values(NEW.requestId,@applicationuserID,NEW.appId,NOW(),@startState,@endState);
                           insert into applicationProcess.aux_studentAndState(requestId,rollNumber,fromState,toState,appId) values(NEW.requestId,@applicationuserID,@startState,@endState,NEW.appId);
                            insert into applicationProcess.requestStateTransitions(requestId,fromState,toState,userId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,NEW.requestArrivalTime,NEW.remark,@string);
                            insert into applicationProcess.aux_requestStateTransitions(requestId,fromState,toState,userId,appId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,@applicationId,NEW.requestArrivalTime,NEW.remark,@string);
                            insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select concat(@startState,",",@endState)));
                         else
                           insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from     userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=@startState));
                         end if;
                       else if(@duplcateStatus = 0 and @validStatusForStudent = 1) then 
                          insert into aux_studentAndState(requestId,rollNumber,fromState,toState,appId) values(NEW.requestId,@statusDoneForStudent,@startState,@endState,NEW.appId);
                          insert into applicationProcess.requestStateTransitions(requestId,fromState,toState,userId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,NEW.requestArrivalTime,NEW.remark,@string);
                          insert into applicationProcess.aux_requestStateTransitions(requestId,fromState,toState,userId,appId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,@applicationId,NEW.requestArrivalTime,NEW.remark,@string);
                          insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select concat(@startState,",",@endState)));
                       else
                          insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgForState from userInputDatabase.messagesForUsersDomain where msgId = @startState));
                       end if;
                       end if;
                       end if;
                   else
                     if(@applicantqueueCnt > 0 or @cntForTheModification > 0) then
                        if(@applicationFormodification = 1 and @duplcateStatus = 0 and @validStatusForStudent = 1) then
                           delete from applicationProcess.studentApplicationQueue where rollnumber = @statusDoneForStudent and appId = NEW.appId;
                           insert into aux_studentAndState(requestId,rollNumber,fromState,toState,appId) values(NEW.requestId,@statusDoneForStudent,@startState,@endState,NEW.appId);
                           insert into applicationProcess.requestStateTransitions(requestId,fromState,toState,userId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,NEW.requestArrivalTime,NEW.remark,@string);
                           insert into applicationProcess.aux_requestStateTransitions(requestId,fromState,toState,userId,appId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,@applicationId,NEW.requestArrivalTime,NEW.remark,@string);
                           insert into applicationProcess.modificationInApplication(requestId,appId,userId,requestArrivalTime,remark,params) values(NEW.requestId,NEW.appId,@statusDoneForStudent,NOW(),NEW.remark,NEW.params);
                           insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select concat(@startState,",",@endState)));
                        else if(@applicationFormodificationSucc = 1 and  @isUserID = 1) then
                           set @duplcateStatus = (select @applicationuserID in (select rollNumber from aux_studentAndState where fromState = @startState and toState = @endState and appId = NEW.appId));
                           set @validStatusForStudent = (select @startState in (select toState from applicationProcess.aux_studentAndState where rollNumber=@applicationuserID and appId = NEW.appId));
                         if(@validStatusForStudent = 1 and @duplcateStatus = 0) then
                           delete from applicationProcess.modificationInApplication where userId = @applicationuserID and appId = NEW.appId;
                           insert into applicationProcess.studentApplicationQueue(requestId,rollnumber,appId,requestArrivalTime,fromState,toState)values(NEW.requestId,@applicationuserID,NEW.appId,NOW(),@startState,@endState);
                           insert into applicationProcess.aux_studentAndState(requestId,rollNumber,fromState,toState,appId) values(NEW.requestId,@applicationuserID,@startState,@endState,NEW.appId);
                           insert into applicationProcess.requestStateTransitions(requestId,fromState,toState,userId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,NEW.requestArrivalTime,NEW.remark,@string);
                           insert into applicationProcess.aux_requestStateTransitions(requestId,fromState,toState,userId,appId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,@applicationId,NEW.requestArrivalTime,NEW.remark,@string);
                           insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select concat(@startState,",",@endState)));
                         else
                           insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from     userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=@startState));
                         end if;
                        else if(@duplcateStatus = 0 and @validStatusForStudent = 1) then
                            insert into aux_studentAndState(requestId,rollNumber,fromState,toState,appId) values(NEW.requestId,@statusDoneForStudent,@startState,@endState,NEW.appId);
                            insert into applicationProcess.requestStateTransitions(requestId,fromState,toState,userId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,NEW.requestArrivalTime,NEW.remark,@string);
                            insert into applicationProcess.aux_requestStateTransitions(requestId,fromState,toState,userId,appId,requestArrivalTime,remark,params) values(NEW.requestId,@startState,@endState,NEW.userId,@applicationId,NEW.requestArrivalTime,NEW.remark,@string);
                            insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select concat(@startState,",",@endState)));
                            delete from applicationProcess.studentAppllicationQueueCnt;
                        else
                            insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgForState from userInputDatabase.messagesForUsersDomain where msgId = @startState));
                        end if;
                        end if;
                        end if;
                     end if;
                   end if;
                   if(@endState = @finishState) then
                     set @requestFinishedSuccessfully = (select @startState = (select applicationState from applicationProcess.modificationStateDomain order by applicationState desc limit 1));
                     if(@requestFinishedSuccessfully = 1) then
                       insert into applicationProcess.studentApplicationCount(requestId,rollnumber,appId) values(NEW.requestId,@statusDoneForStudent,@applicationId);
                       update applicationProcess.studentApplicationCount set appcnt = appcnt + 1 where rollnumber = @statusDoneForStudent and appId = @applicationId;
                     end if;
                     delete from studentApplicationQueue where rollNumber = @statusDoneForStudent and appId = NEW.appId;
                     delete from aux_studentAndState where rollNumber = @studentUserId and appId = NEW.appId;
                     delete from aux_requestStateTransitions;
                     delete from applicationRequests where userId = @statusDoneForStudent and appId = NEW.appId;
                     delete from applicationForm where rollNumber = @statusDoneForStudent and appId = @applicationId;
                     delete from applicationProcess.studentAppllicationQueueCnt;
                     insert into applicationProcess.applicationFormDelete(rollNumber,requestId,appId) values(@studentUserId,NEW.requestId,@applicationId);
                   end if;
               end if;
           else
               insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=@startState));
           end if;
       end if;
    else
      insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NEW.requestArrivalTime,(select msgId from     userInputDatabase.messagesForUsersDomain where msgId=@startState),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=@startState));
    end if;
  END;


  |
delimiter ;
