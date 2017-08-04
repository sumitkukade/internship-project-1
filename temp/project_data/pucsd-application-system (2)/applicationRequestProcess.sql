DROP TRIGGER IF EXISTS userInputDatabase.insertInApplicationRequest;

/* After insert on inputRequests so action by the requestType and tableId. By the parameter field record is inserted into the corrosepoding table if record is invalid then it inserted into outputErrorMsgs table and result in outputResults table */

 create table g(a text,b text,c text,d text);

delimiter |


CREATE TRIGGER userInputDatabase.insertInApplicationRequest after insert on userInputDatabase.inputRequests
FOR EACH ROW
  BEGIN
    insert into applicationProcess.requestindex(requestId) values(NEW.requestId);
    set @tableId  = (select tableIndex from tableIdDomain where tableId = NEW.tableId);
    set @requestType = (select requestTypeId from userInputDatabase.requestTypeDomain where requestType =NEW.requestType);
    set @staffuserId  = (select NEW.userId in (select staffId from applicationProcess.staffDetailsDomain));
    set @studentuserId  = (select NEW.userId in (select rollNumber from applicationProcess.studentDetailsDomain));
    set @userIdExists = (select NEW.userId in (select userId from applicationProcess.userIdDomain));
    if(@requestType = 1) then
        if(@tableId = 1 or @tableId = 2) then
            delete from applicationProcess.procedureResult;
            call applicationProcess.validatingString(NEW.params);
            set @isValidString = (select isResult from applicationProcess.procedureResult);
            delete from applicationProcess.requestIdStringResult;
            call applicationProcess.validateApplicationForModification(NEW.params);
            set @ismodificationString = (select isResult from applicationProcess.requestIdStringResult);
            if(@ismodificationString = 2 and @tableId = 2 and @staffuserId = 1) then
              set @modificationString = (select result from applicationProcess.requestIdStringResult);
              set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
              set @fromState = (select applicationProcess.split_str(@string,",",@len-(@len-2)));
              set @toState = (select applicationProcess.split_str(@string,",",@len-(@len-3)));
              set @applicationId = (select applicationProcess.split_str(@string,",",@len-(@len-1)));
              insert into applicationProcess.applicationRequestByStaff(requestId,appId,userId,requestArrivalTime,remark,params) values(NEW.requestId,@applicationId,NEW.userId,NOW(),(select applicationProcess.split_str(@string,",",@len-(@len-5))),@modificationString);
            else if(@isValidString = 1) then
                set @string = (select result from applicationProcess.procedureResult);
                set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
                set @fromState = (select applicationProcess.split_str(@string,",",@len-(@len-2)));
                set @toState = (select applicationProcess.split_str(@string,",",@len-(@len-3)));
                set @applicationId = (select applicationProcess.split_str(@string,",",@len-(@len-1)));
                if(@staffuserId = 1 and @tableId = 2) then
                    insert into applicationProcess.applicationRequestByStaff(requestId,appId,userId,requestArrivalTime,remark,params) values(NEW.requestId,@applicationId,NEW.userId,NOW(),(select applicationProcess.split_str(@string,",",@len-(@len-4))),@string);
                else if(@studentuserId = 1 and @tableId = 1) then
                    insert into applicationProcess.applicationRequests(requestId,appId,userId,requestArrivalTime,remark,params) values(NEW.requestId,@applicationId,NEW.userId,NOW(),(select applicationProcess.split_str(@string,",",@len-(@len-4))),@string);
                else
                    insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
                end if;
                end if;
            else
               insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
            end if;
            end if;
        else if(@tableId = 3 and @studentuserId = 1 ) then
          set @string = NEW.params;
          set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
          set @appIndex  = (select @string in (select appId from applicationProcess.applicationDomain));
          if(@appIndex = 1) then
             insert into applicationProcess.applicationForm(rollNumber,requestId,appId) values(NEW.userId,NEW.requestId,@string);
          else
             insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
          end if;
       else if(@tableId = 5 and @userIdExists = 1) then
         set @string = NEW.params;
         set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
         if(@len = 1) then
            insert into applicationProcess.applicationCodeBySystem(userId,applicationCode) values(NEW.userId,@string);
         else
            insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
         end if;
       else if(@tableId = 6 and @userIdExists = 1) then
         set @string = NEW.params;
         set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
         if(@len = 1) then
            insert into applicationProcess.userforgetPassword(userId,applicationCode) values(NEW.userId,@string);
         else
          insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
         end if;
       else if(@tableId = 7 and @staffuserId = 1) then
          set @string = NEW.params;
          set @validauserId = (select @string in (select rollNumber from applicationProcess.studentDetailsDomain));
          if(@validauserId = 1 and @len = 1) then
            insert into applicationProcess.getApplicationCode(userId) values(@string);
          else
            insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
          end if;
       else if(@tableId = 8 and @studentuserId = 1) then
          set @string = NEW.params;
          set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
          set @password = (select applicationProcess.split_str(@string,",",@len-(@len-1)));
          set @newpassword = (select applicationProcess.split_str(@string,",",@len-(@len-2)));
          if(@len = 2) then
            insert into applicationProcess.changePassword(userId,password,newPassword) values(NEW.userId,@password,@newPassword);
          else
            insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
          end if;
       else if(@tableId = 9 and @userIdExists = 1) then
          set @string = NEW.params;
          set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
          insert into applicationProcess.userPassword(userId,password) values(NEW.userId,@string);
       else
          insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));

        end if;
        end if;
        end if;
        end if;
        end if;
        end if;
        end if;
    else if(@requestType = 2) then
       delete from applicationProcess.procedureResult;
       call applicationProcess.validatingString(NEW.params);
       set @isValidString = (select isResult from applicationProcess.procedureResult); 
       delete from applicationProcess.applicationResult;
       call applicationProcess.applicationString(NEW.params);
       set @deleteString = (select isResult from applicationProcess.applicationResult);
       set @applicationId = (select result from applicationProcess.applicationResult);
       set @string = NEW.params;
       set @len  = (select length(@string)+1 - (select length(replace(@string,",",""))));
       delete from applicationProcess.applicationRequestResult;
       call applicationProcess.applicationRequestIdvalidation(@string);
       set @validAction = (select isResult from applicationProcess.applicationRequestResult);
       set @validString = (select result from applicationProcess.applicationRequestResult);
       set @rqstID = (select applicationProcess.split_str(@validString,",",@len-(@len-1)));
       set @validRequestId = (select @string in (select requestId from inputRequests));
       set @validRequestId1 = (select @rqstID in (select requestId from inputRequests));
       if(@validRequestId = 1 or @validRequestId1 = 1) then
           set @userIdExistsInapplicationForm = (select NEW.userId in (select rollNumber from applicationProcess.applicationForm where requestId = @string));
           set @userIdExistsInapplicationRequests = (select NEW.userId in (select userId from applicationProcess.applicationRequests where requestId = @string));
           set @userIdExistsInapplicationRequestByStaff = (select NEW.userId in (select userId from applicationProcess.applicationRequestByStaff where requestId = @string));
           set @appID = (select applicationProcess.split_str(@validString,",",@len-(@len-2)));
           set @appIDForapplicationForm = (select @appID in (select appId from applicationProcess.applicationForm where requestId = @rqstID and appId = @appID));
           set @appIDForapplicationRequest = (select @appID in (select appId from applicationProcess.applicationRequests where requestId = @rqstID and appId = @appID));
           set @appIDForapplicationRequestByStaff = (select @appID in (select appId from applicationProcess.applicationRequestByStaff where requestId = @rqstID and appId = @appID));
         if(@userIdExistsInapplicationForm = 1 and @tableId = 3 and @studentuserId = 1) then
              if(@len = 1) then
                  set @appID = (select appId from applicationProcess.applicationForm where requestId = @string);
                  delete from applicationProcess.applicationForm where requestId = @string;
                  insert into applicationProcess.applicationFormDelete(requestId,rollNumber,appId) values(NEW.requestId,NEW.userId,@appID);
              else if(@len = 2 and @validAction = 1 and @appIDForapplicationForm = 1) then
                  delete from applicationProcess.applicationForm where requestId = @rqstID and appId = @appID;
                  insert into applicationProcess.applicationFormDelete(requestId,rollNumber,appId) values(@rqstID,NEW.userId,@appID);
              else
                 insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
              end if;
              end if;
         else if(@userIdExistsInapplicationRequests = 1 and @tableId = 1 and @studentuserId = 1) then
              if(@len = 1) then
                  delete from applicationProcess.applicationRequests where requestId = @string;
                  delete from applicationProcess.requestStateTransitions where requestId = @string;
                  delete from userInputDatabase.outputResults where requestId = @string;
                  delete from userInputDatabase.outputErrorMsgs where requestId = @string;
              else if(@len = 2 and @validAction = 1 and @appIDForapplicationRequest = 1) then
                  delete from applicationProcess.applicationRequests where requestId = @rqstID and appId = @appID;
                  delete from applicationProcess.requestStateTransitions where requestId = @rqstID;
                  delete from userInputDatabase.outputResults where requestId = @rqstID;
                  delete from userInputDatabase.outputErrorMsgs where requestId = @rqstID;
              else
                  insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
              end if;
              end if;
         else if(@userIdExistsInapplicationRequestByStaff = 1 and @tableId = 2 and @staffuserId = 1) then
              if(@len = 1) then
                 delete from applicationProcess.applicationRequestByStaff where requestId = @string;
                 delete from applicationProcess.requestStateTransitions where requestId = @string;
                 delete from userInputDatabase.outputResults where requestId = @string;
                 delete from userInputDatabase.outputErrorMsgs where requestId = @string;
              else if(@len = 2 and @validAction = 1 and @appIDForapplicationRequestByStaff = 1) then
                  delete from applicationProcess.applicationRequestByStaff where requestId = @rqstID and appId = @appID;
                  delete from applicationProcess.requestStateTransitions where requestId = @rqstID;
                  delete from userInputDatabase.outputResults where requestId = @rqstID;
                  delete from userInputDatabase.outputErrorMsgs where requestId = @rqstID;
              else
                  insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
              end if;
              end if;
         else
              insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
         end if;
         end if;
         end if;
       else if(@deleteString = 1) then
          if(@tableId = 3 and @studentuserId = 1) then
             delete from applicationProcess.applicationForm where rollNumber=NEW.userId  and appId = @applicationId;
             insert into applicationProcess.applicationFormDelete(requestId,rollNumber,appId) values(NEW.requestId,NEW.userId,@applicationId);
          else if(@tableId = 1 and @studentuserId = 1) then
             delete from applicationProcess.applicationRequests where  appId = @applicationId;
             delete from applicationProcess.requestStateTransitions where userId in (select userId from applicationProcess.applicationRequests where appId = @applicationId and userId = NEW.userId);
          else if(@tableId = 2 and @staffuserId = 1) then
             delete from applicationProcess.applicationRequestByStaff where appId = @applicationId;
             delete from applicationProcess.requestStateTransitions where userId in (select userId from applicationProcess.applicationRequestByStaff where appId = @applicationId and userId = NEW.userId);
          else
             insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
          end if;
          end if;
          end if;
       else if(@isValidString = 1 and (@tableId = 1 or @tableId = 2)) then
           set @string = (select result from applicationProcess.procedureResult); 
           set @appId = (select applicationProcess.split_str(@string,",",@len-(@len-1)));
              insert into applicationProcess.aux_applicationRequestsDelete(requestId,appId,userId,requestArrivalTime,remark,params) values(NEW.requestId,@appId,NEW.userId,NOW(),(select applicationProcess.split_str(@string,",",@len-(@len-4))),@string);
       else
           insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
       end if;
       end if;
       end if;
    else if(@requestType = 3) then
       set @string = NEW.params;
       set @len = (select length(@string)+1 - (select length(replace(@string,",",""))));
       delete from applicationProcess.applicationRequestResult;
       call applicationProcess.applicationRequestIdupdatation(@string);
       set @validAction = (select isResult from applicationProcess.applicationRequestResult);
       set @validString = (select result from applicationProcess.applicationRequestResult);
       set @rqstID = (select applicationProcess.split_str(@validString,",",@len-(@len-1)));
       set @userIdExistsInapplicationForm = (select NEW.userId in (select rollNumber from applicationProcess.applicationForm where requestId = @rqstID));
       set @userIdExistsInapplicationRequests = (select NEW.userId in (select userId from applicationProcess.applicationRequests where requestId = @rqstID));
       set @userIdExistsInapplicationRequestByStaff = (select NEW.userId in (select userId from applicationProcess.applicationRequestByStaff where requestId = @rqstID));
       if(@len = 2 and @tableId = 3 and @studentuserId = 1) then
          set @oldAppId = (select applicationProcess.split_str(@string,",",@len-(@len-1)));
          set @newAppId = (select applicationProcess.split_str(@string,",",@len-(@len-2)));
          set @oldAppIdExists = (select @oldAppId in (select appId from applicationProcess.applicationDomain));
          set @newAppIdExists = (select @newAppId in (select appId from applicationProcess.applicationDomain));
          if(@oldAppIdExists = 1 and @newAppIdExists = 1) then
             update applicationProcess.applicationForm set appId = @newAppId where appId = @oldAppId and rollNumber = NEW.userId;
          else
           insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
          end if;
       else if(@len = 3 and @validAction = 1) then
          set @oldAppId = (select applicationProcess.split_str(@validString,",",@len-(@len-2)));
          set @newAppId = (select applicationProcess.split_str(@validString,",",@len-(@len-3)));
          set @appIDForapplicationForm = (select @oldAppId in (select appId from applicationProcess.applicationForm where requestId = @rqstID and appId = @oldAppId));
          set @appIDForapplicationRequest = (select @oldAppId in (select appId from applicationProcess.applicationRequests where requestId = @rqstID and appId = @oldAppId));
          set @appIDForapplicationRequestByStaff = (select @oldAppId in (select appId from applicationProcess.applicationRequestByStaff where requestId = @rqstID and appId = @oldAppId));
          if(@userIdExistsInapplicationForm = 1 and @tableId = 3 and @studentuserId = 1 and @appIDForapplicationForm = 1) then
             update applicationProcess.applicationForm set appId = @newAppId where appId = @oldAppId and requestId = @rqstID;
          else if(@userIdExistsInapplicationRequests = 1 and @tableId = 1 and @studentuserId = 1 and @appIDForapplicationRequest = 1) then
             set @remark = (select remark from applicationProcess.applicationRequests where requestId = @rqstID);
             set @params = (select params from applicationProcess.applicationRequests where requestId = @rqstID);
             insert into applicationProcess.aux_applicationRequestsUpdateappId(requestId,appId,userId,requestArrivalTime,remark,params) values(@rqstID,@newAppId,NEW.userId,NOW(),@remark,@params);
          else if(@userIdExistsInapplicationRequestByStaff = 1 and @tableId = 1 and @staffuserId = 1 and @appIDForapplicationRequestByStaff = 1) then
             set @remark = (select remark from applicationProcess.applicationRequestByStaff where requestId = @rqstID);
             set @params = (select params from applicationProcess.applicationRequestByStaff where requestId = @rqstID);
             insert into applicationProcess.aux_applicationRequestsUpdateappId(requestId,appId,userId,requestArrivalTime,remark,params) values(@rqstID,@newAppId,NEW.userId,NOW(),@remark,@params);
          end if;
          end if;
          end if;
       else if(@len >= 5 and (@tableId = 1 or @tableId = 2)) then
          delete from applicationProcess.requestStringResult;
          call applicationProcess.validateUpdatedString(@string);
          set @isResult = (select isResult from applicationProcess.requestStringResult);
          set @result = (select  result from applicationProcess.requestStringResult);
          if(@isResult = 1) then
            set @appId = (select applicationProcess.split_str(@result,",",@len-(@len-1)));
            insert into applicationProcess.aux_applicationRequestsUpdate(requestId,appId,userId,requestArrivalTime,remark,params) values(NEW.requestId,@appId,NEW.userId,NOW(),(select applicationProcess.split_str(@result,",",@len-(@len-6))),@result);
          else
            insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
          end if;
       else
          insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
       end if;
       end if;
       end if;
    else if(@requestType = 4) then
       set @string = NEW.params;
       set @len = (select length(@string)+1 - (select length(replace(@string,",",""))));
       if(@studentuserId = 1) then
          set @applicationId = (select appId from applicationProcess.applicationDomain where appId = @string);
          set @validrqstId = (select @string in (select requestId from userInputDatabase.inputRequests where requestId = @string));
          set @userIdExistsInapplicationForm = (select NEW.userId in (select rollNumber from applicationProcess.applicationForm where requestId = @rqstID));
          set @userIdExistsInapplicationRequests = (select NEW.userId in (select userId from applicationProcess.applicationRequests where requestId = @rqstID));
          set @userIdExistsInapplicationRequestByStaff = (select NEW.userId in (select userId from applicationProcess.applicationRequestByStaff where requestId = @rqstID));
          set @userIdExistsInapplicationRequestStateTransitions = (select NEW.userId in (select userId from applicationProcess.requestStateTransitions where requestId = @rqstID));
          if(@tableId = 1 and  @len = 1) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",appId," ",userId," ",requestArrivalTime," ",remark," ",params," ") separator " ") from applicationProcess.applicationRequests where userId =NEW.userId and appId =@applicationId));
          else if(@tableId = 1 and  @len = 1 and @validrqstId = 1 and @userIdExistsInapplicationRequests = 1) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",appId," ",userId," ",requestArrivalTime," ",remark," ",params," ") separator " ") from applicationProcess.applicationRequests where requestId = @string));
          else if(@tableId = 3 and @len = 1) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(rollNumber," ",requestId," ",appId) separator " ") from applicationProcess.applicationForm where rollNumber = NEW.userId and appId = @applicationId));
          else if(@tableId = 3 and @len = 1 and @validrqstId = 1 and @userIdExistsInapplicationForm = 1) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(rollNumber," ",requestId," ",appId) separator " ") from applicationProcess.applicationForm where requestId = @string));
          else if(@tableId = 1) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",appId," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.applicationRequests where userId = NEW.userId));
          else if(@tableId = 4) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",fromState," ",toState," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.requestStateTransitions  where userId = NEW.userId));
          else if(@tableId = 4 and @validrqstId = 1 and @len = 1 and @userIdExistsInapplicationRequestStateTransitions = 1) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",fromState," ",toState," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.requestStateTransitions  where requestId = @string and userId = NEW.userId));
          else
            insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
          end if;
          end if;
          end if;
          end if;
          end if;
          end if;
          end if;
       else if(@staffuserId = 1) then
         set @staffstring = NEW.params;
         set @validrqstId = (select @staffstring in (select requestId from userInputDatabase.inputRequests where requestId = @staffstring));
         if(@len = 2) then
           delete from applicationProcess.requestResult;
           call applicationProcess.requestString(NEW.params);
           set @validString = (select isResult from applicationProcess.requestResult);
           set @string = (select result from applicationProcess.requestResult);
           set @userName = (select applicationProcess.split_str(@string,",",@len-(@len-1)));
           set @applicationId = (select applicationProcess.split_str(@string,",",@len-(@len-2)));
           if(@validString = 1) then
             if(@tableId = 3) then
               insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(rollNumber," ",requestId," ",appId) separator " ") from applicationProcess.applicationForm where rollNumber = @userName and appId = @applicationId));
             else if(@tableId = 1) then
               insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",appId," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.applicationRequests where userId = @userName and appId =@applicationId));
             else
               insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
             end if;
             end if;
           else
            insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
           end if;
         else if(@len = 1) then
            delete from applicationProcess.applicationResult;
            call applicationProcess.applicationString(NEW.params);
            set @requestString = (select isResult from applicationProcess.applicationResult);
            if(@requestString = 1) then
              set @applicationId = (select result from applicationProcess.applicationResult);
              if(@tableId = 2) then
                 insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",appId," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.applicationRequestByStaff where appId =@applicationId));
              else if(@tableId = 1) then
                 insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",appId," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.applicationRequests where appId =@applicationId));
              else if(@tableId = 3) then
                insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(rollNumber," ",requestId," ",appId) separator " ") from applicationProcess.applicationForm where appId = @applicationId));
              else
                insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
              end if;
              end if;
              end if;
            else if(@requestString = 2) then
              set @userName = (select result from applicationProcess.applicationResult);
              if(@tableId = 1) then
                 insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",appId," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.applicationRequests where userId=@userName));
              else if(@tableId = 3) then
                insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(rollNumber," ",requestId," ",appId) separator " ") from applicationProcess.applicationForm where userId = @userName));
              else if(@tableId = 4) then
                insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",fromState," ",toState," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.requestStateTransitions  where userId = @userName));
              else
                insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
              end if;
              end if;
              end if;
            end if;
            end if;
         else if(@tableId = 4 and @staffuserId = 1) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",fromState," ",toState," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.requestStateTransitions));
         else if(@tableId = 4 and @staffuserId = 1 and @validrqstId = 1 and @userIdExistsInapplicationRequestStateTransitions = 1) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",fromState," ",toState," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.requestStateTransitions where requestId = @staffstring));
         else if(@tableId = 2 and @staffuserId = 1) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",appId," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.applicationRequestByStaff where userId = NEW.userId));
         else if(@tableId = 2 and @staffuserId = 1 and @validrqstId = 1 and @userIdExistsInapplicationRequestByStaff = 1) then
             insert into userInputDatabase.outputResults(requestId,timet,output) values(NEW.requestId,NOW(),(select group_concat(concat(requestId," ",appId," ",userId," ",requestArrivalTime," ",remark," ",params) separator " ") from applicationProcess.applicationRequestByStaff where userId = NEW.userId and validrqstId = 1));
         else
           insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
         end if;
         end if;
         end if;
         end if;
         end if;
         end if;
       end if;
       end if;
    else
      insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId),(select msgForAcomplish from userInputDatabase.messagesForUsersDomain where msgId=NEW.tableId));
    end if;
    end if;
    end if;
    end if;
  END;

  |
delimiter ;
