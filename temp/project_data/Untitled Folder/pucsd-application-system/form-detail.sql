
/*--------------Bonafide field-----------*/

/* student insert in table the trigger fired. if valid application the it store into the corroseponding table*/

CREATE TABLE applicationForm (
  rollNumber varchar(15) NOT NULL,
  requestId bigint NOT NULL,
  appId varchar(5) NOT NuLL,
  Foreign Key(rollNumber) References studentDetailsDomain(rollNumber)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE

);
/*--------------------------------------------------------------------*/

/* if application for bonafied the all information of the student store in that table by the trigger */

CREATE TABLE bonafideApplicationForm (
  rollNumber varchar(15) NOT NULL,
  fname text NOT NULL,
  mname text,
  lname text NOT NULL,
  CourseName varchar(3) NOT NULL,
  year varchar(1) NOT NULL,
  adderessLine1 varchar(50) NOT NULL,
  adderessLine2 varchar(50) NOT NULL,
  adderessLine3 varchar(50) NOT NULL,
  dateOfBirth date NOT NULL,
  currDate date NOT NULL
);

/*--------------------------------------------------------------------*/

/* if application for interNationalbonafied the all information of the student store in that table by the trigger */

CREATE TABLE interNationalBonafideApplicationForm (
  rollNumber varchar(15) NOT NULL,
  fname text NOT NULL,
  mname text,
  lname text NOT NULL,
  courseName varchar(3) NOT NULL,
  semId varchar(1) NOT NULL,
  acadmiYear varchar(1) NOT NULL,
  dateOfFirst date NOT NULL,
  nationality text NOT NULL,
  studentAddrInCity text NOT NULL,
  contactNo varchar(10) NOT NULL,
  currDate date NOT NULL,
  passportNo text NOT NULL,
  issuedOn date NOT NULL,
  passportValidTill date NOT NULL,
  visaNo text NOT NULL,
  visaType text NOT NULL,
  visaIssuedOn date NOT NULL,
  visaValidTill date NOT NULL,
  stayVisaUpTo integer NOT NULL
);

/*--------------------------------------------------------------------*/

/* if application for noDuesFormDateForm the all information of the student store in that table by the trigger */

CREATE TABLE noDuesFormDateForm (
  rollNumber varchar(15) NOT NULL,
  fname text NOT NULL,
  mname text,
  lname text NOT NULL,
  CourseName varchar(3) NOT NULL,
  gender varchar(1) NOT NULL
);

/*--------------------------------------------------------------------*/

/* if application for feesStructureForm the all information of the student store in that table by the trigger */

CREATE TABLE feesStructureForm (
   rollNumber varchar(15) NOT NULL,
   fname text NOT NULL,
   mname text,
   lname text NOT NULL,
   courseId varchar(3) NOT NULL,
   semId varchar(1) NOT NULL,
   tutionFee integer NOT NULL,
   labFee integer NOT NULL,
   otherFee integer NOT NULL,
   Total integer NOT NULL,
   currdate date NOT NULL
);

/* this is update purpose */

CREATE TABLE IF NOT EXISTS aux_applicationForm (
  rollNumber varchar(15) NOT NULL,
  requestId bigint NOT NULL,
  applicationDesc text NOT NULL,
  appId varchar(5) NOT NULL,
  Foreign Key(rollNumber) References studentDetailsDomain(rollNumber)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/* this is for delete purpose */

CREATE TABLE IF NOT EXISTS applicationFormDelete (
  rollNumber varchar(15) NOT NULL,
  requestId bigint NOT NULL,
  appId varchar(5) NOT NULL,
  Foreign Key(rollNumber) References studentDetailsDomain(rollNumber)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);


/* this PROCEDURE for feesStructure insertion */

delimiter |


CREATE PROCEDURE applicationProcess.insertInFeeStructure(IN rollnumber varchar(15), IN fname text,IN mname text,IN lname text,IN course varchar(5),IN studentDomain int,IN categoryId varchar(5))

BEGIN
  declare count int;
  IF course = (select distinct courseId from courseDomain order by courseId asc limit 1)  THEN
    set count = 1;
    while count <= 6 do
      if(studentDomain = 1) then
         insert into feesStructureForm(rollNumber,fname,mname,lname,courseId,semId,tutionFee,labFee,otherFee,Total,currdate) values(rollnumber,fname,mname,lname,course,count,(select tutionFee from feesStructureForInternationalStudentDomain where courseId=course and semId = count and category = categoryId),(select labFee from feesStructureForInternationalStudentDomain where courseId=course and semId = count and category = categoryId),(select otherFee from feesStructureForInternationalStudentDomain where courseId=course and semId = count and category = categoryId),(select tutionFee+labFee+otherFee from feesStructureForInternationalStudentDomain where courseId=course and semId = count and category = categoryId),NOW());
      else if(studentDomain = 2) then
         insert into feesStructureForm(rollNumber,fname,mname,lname,courseId,semId,tutionFee,labFee,otherFee,Total,currdate) values(rollnumber,fname,mname,lname,course,count,(select tutionFee from feesStructureNonMaharashtrianDomain where courseId=course and semId = count and category = categoryId),(select labFee from feesStructureNonMaharashtrianDomain where courseId=course and semId = count and category = categoryId),(select otherFee from feesStructureNonMaharashtrianDomain where courseId=course and semId = count and category = categoryId),(select tutionFee+labFee+otherFee from feesStructureNonMaharashtrianDomain where courseId=course and semId = count and category = categoryId),NOW());
      else
         insert into feesStructureForm(rollNumber,fname,mname,lname,courseId,semId,tutionFee,labFee,otherFee,Total,currdate) values(rollnumber,fname,mname,lname,course,count,(select tutionFee from feesStructureDomain where courseId=course and semId = count and category = categoryId),(select labFee from feesStructureDomain where courseId=course and semId = count and category = categoryId),(select otherFee from feesStructureDomain where courseId=course and semId = count and category = categoryId),(select tutionFee+labFee+otherFee from feesStructureDomain where courseId=course and semId = count and category = categoryId),NOW());
      end if;
      end if;
       set count = count + 1;
    end while;
  END IF;
  IF course = (select distinct courseId from courseDomain order by courseId desc limit 1)  THEN
    set count = 1;
    while count <= 4 do
      if(studentDomain = 1) then
         insert into feesStructureForm(rollNumber,fname,mname,lname,courseId,semId,tutionFee,labFee,otherFee,Total,currdate) values(rollnumber,fname,mname,lname,course,count,(select tutionFee from feesStructureForInternationalStudentDomain where courseId=course and semId = count and category = categoryId),(select labFee from feesStructureForInternationalStudentDomain where courseId=course and semId = count and category = categoryId),(select otherFee from feesStructureForInternationalStudentDomain where courseId=course and semId = count and category = categoryId),(select tutionFee+labFee+otherFee from feesStructureForInternationalStudentDomain where courseId=course and semId = count and category = categoryId),NOW());
      else if(studentDomain = 2) then
         insert into feesStructureForm(rollNumber,fname,mname,lname,courseId,semId,tutionFee,labFee,otherFee,Total,currdate) values(rollnumber,fname,mname,lname,course,count,(select tutionFee from feesStructureNonMaharashtrianDomain where courseId=course and semId = count and category = categoryId),(select labFee from feesStructureNonMaharashtrianDomain where courseId=course and semId = count and category = categoryId),(select otherFee from feesStructureNonMaharashtrianDomain where courseId=course and semId = count and category = categoryId),(select tutionFee+labFee+otherFee from feesStructureNonMaharashtrianDomain where courseId=course and semId = count and category = categoryId),NOW());
      else
         insert into feesStructureForm(rollNumber,fname,mname,lname,courseId,semId,tutionFee,labFee,otherFee,Total,currdate) values(rollnumber,fname,mname,lname,course,count,(select tutionFee from feesStructureDomain where courseId=course and semId = count and category = categoryId),(select labFee from feesStructureDomain where courseId=course and semId = count and category = categoryId),(select otherFee from feesStructureDomain where courseId=course and semId = count and category = categoryId),(select tutionFee+labFee+otherFee from feesStructureDomain where courseId=course and semId = count and category = categoryId),NOW());
      end if;
      end if;
       set count = count + 1;
    end while;
  END IF;

END;

/* By that trigger all applicationform result store corrosepodint with that table */

CREATE TRIGGER applicationProcess.triggerForFormDetails after insert on applicationProcess.applicationForm
FOR EACH ROW
  BEGIN
    set @appIndex = (select appIndex from applicationDomain where appId = NEW.appId);
    set @fname  = (select fname from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @mname = (select mname from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @lname  = (select lname from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @courseName = (select courseId from applicationProcess.studentDetailsDomain where rollNumber=NEW.rollNumber);
    set @semId = (select semId from applicationProcess.studentDetailsDomain where rollNumber=NEW.rollNumber);
    set @year = (select year from applicationProcess.courseSemesterDomain where courseId = @courseName and semId = @semId);
    set @DOB = (select dateOfBirth from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @internationalStudent = (select NEW.rollNumber in (select rollNumber from internationalStudentInformationDomain));
    set @domicile = (select domicile from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @category = (select category from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @isinternationalStudent = (select NEW.rollNumber in (select rollNumber from internationalStudentInformationDomain));
    if(@appIndex = 1) then
      if(@isinternationalStudent = 0) then
        insert into applicationProcess.bonafideApplicationForm(rollNumber,fname,mname,lname,courseName,year,adderessLine1,adderessLine2,adderessLine3,dateOfBirth,currDate) values(NEW.rollNumber,@fname,@mname,@lname,@courseName,@year,(select adderessLine1 from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber),(select adderessLine2 from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber),(select adderessLine3 from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber),@DOB,NOW());
      else
       delete from applicationProcess.applicationForm where rollNumber = NEW.rollNumber;
       insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId="ERR"),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId="ERR"));
      end if;
    else if(@appIndex = 2) then
      if(@isinternationalStudent = 1) then
      insert into applicationProcess.interNationalBonafideApplicationForm(rollNumber,fname,mname,lname,courseName,semId,acadmiYear,dateOfFirst,nationality,studentAddrInCity,contactNo,currDate,passportNo,issuedOn,passportValidTill,visaNo,visaType,visaIssuedOn,visaValidTill,stayVisaUpTo) values(NEW.rollNumber,@fname,@mname,@lname,@courseName,@semId,@year,(select dateOfFirstAdmsn from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select nationality from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select studentAddrInCity from internationalStudentInformationDomain where rollNumber = NEW.rollNumber),(select contactNo from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber),NOW(),(select passportNo from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select issuedOn from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select passportValidTill from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select visaNo from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select visaType from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select visaIssuedOn from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select visaValidTill from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select stayVisaUpTo from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber));
      else
       delete from applicationProcess.applicationForm where rollNumber = NEW.rollNumber;
       insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId="ERR"),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId="ERR"));
      end if;
    else if(@appIndex = 3) then
       if(@domicile = 0) then
          if(@internationalStudent = 1) then
             call insertInFeeStructure(NEW.rollNumber,@fname,@mname,@lname,@courseName,1,"OPEN");
          else
             call insertInFeeStructure(NEW.rollNumber,@fname,@mname,@lname,@courseName,2,"OPEN");
          end if;
       else
          call insertInFeeStructure(NEW.rollNumber,@fname,@mname,@lname,@courseName,0,@category);
       end if;
    else if(@appIndex = 4) then
      insert into applicationProcess.noDuesFormDateForm(rollNumber,fname,mname,lname,CourseName,gender) values(NEW.rollNumber,@fname,@mname,@lname,@CourseName,(select gender from studentDetailsDomain where rollNumber = NEW.rollNumber));
    end if;
    end if;
    end if;
    end if;
  END;

CREATE TRIGGER applicationProcess.triggerFormDetails after update on applicationProcess.applicationForm
FOR EACH ROW
  BEGIN
    set @appIndex = (select appIndex from applicationDomain where appId = NEW.appId);
    set @fname  = (select fname from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @mname = (select mname from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @lname  = (select lname from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @courseName = (select courseId from applicationProcess.studentDetailsDomain where rollNumber=NEW.rollNumber);
    set @semId = (select semId from applicationProcess.studentDetailsDomain where rollNumber=NEW.rollNumber);
    set @year = (select year from applicationProcess.courseSemesterDomain where courseId = @courseName and semId = @semId);
    set @DOB = (select dateOfBirth from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @internationalStudent = (select NEW.rollNumber in (select rollNumber from internationalStudentInformationDomain));
    set @domicile = (select domicile from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @category = (select category from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber);
    set @isinternationalStudent = (select NEW.rollNumber in (select rollNumber from internationalStudentInformationDomain));
    if(@appIndex = 1) then
      if(@isinternationalStudent = 0) then
        delete from applicationProcess.noDuesFormDateForm where rollNumber = NEW.rollNumber;
        delete from applicationProcess.interNationalBonafideApplicationForm where rollNumber = NEW.rollNumber;
        delete from applicationProcess.feesStructureForm where rollNumber = NEW.rollNumber;
        insert into applicationProcess.bonafideApplicationForm(rollNumber,fname,mname,lname,courseName,year,adderessLine1,adderessLine2,adderessLine3,dateOfBirth,currDate) values(NEW.rollNumber,@fname,@mname,@lname,@courseName,@year,(select adderessLine1 from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber),(select adderessLine2 from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber),(select adderessLine3 from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber),@DOB,NOW());
      else
       insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId="ERR"),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId="ERR"));
      end if;
    else if(@appIndex = 2) then
      if(@isinternationalStudent = 1) then
        delete from applicationProcess.noDuesFormDateForm where rollNumber = NEW.rollNumber;
        delete from applicationProcess.bonafideApplicationForm where rollNumber = NEW.rollNumber;
        delete from applicationProcess.feesStructureForm where rollNumber = NEW.rollNumber;
      insert into applicationProcess.interNationalBonafideApplicationForm(rollNumber,fname,mname,lname,courseName,semId,acadmiYear,dateOfFirst,nationality,studentAddrInCity,contactNo,currDate,passportNo,issuedOn,passportValidTill,visaNo,visaType,visaIssuedOn,visaValidTill,stayVisaUpTo) values(NEW.rollNumber,@fname,@mname,@lname,@courseName,@semId,@year,(select dateOfFirstAdmsn from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select nationality from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select studentAddrInCity from internationalStudentInformationDomain where rollNumber = NEW.rollNumber),(select contactNo from applicationProcess.studentDetailsDomain where rollNumber = NEW.rollNumber),NOW(),(select passportNo from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select issuedOn from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select passportValidTill from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select visaNo from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select visaType from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select visaIssuedOn from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select visaValidTill from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber),(select stayVisaUpTo from applicationProcess.internationalStudentInformationDomain where rollNumber=NEW.rollNumber));
      else
      insert into userInputDatabase.outputErrorMsgs(requestId,timet,msgId,msg) values(NEW.requestId,NOW(),(select msgId from userInputDatabase.messagesForUsersDomain where msgId="ERR"),(select msgAboutUserAuthentication from userInputDatabase.messagesForUsersDomain where msgId="ERR"));
      end if;
    else if(@appIndex = 3) then
       delete from applicationProcess.noDuesFormDateForm where rollNumber = NEW.rollNumber;
       delete from applicationProcess.interNationalBonafideApplicationForm where rollNumber = NEW.rollNumber;
       delete from applicationProcess.bonafideApplicationForm where rollNumber = NEW.rollNumber;
       if(@domicile = 0) then
          if(@internationalStudent = 1) then
             call insertInFeeStructure(NEW.rollNumber,@fname,@mname,@lname,@courseName,1,"OPEN");
          else
             call insertInFeeStructure(NEW.rollNumber,@fname,@mname,@lname,@courseName,2,"OPEN");
          end if;
       else
          call insertInFeeStructure(NEW.rollNumber,@fname,@mname,@lname,@courseName,0,@category);
       end if;
    else if(@appIndex = 4) then
       delete from applicationProcess.feesStructureForm where rollNumber = NEW.rollNumber;
       delete from applicationProcess.interNationalBonafideApplicationForm where rollNumber = NEW.rollNumber;
       delete from applicationProcess.bonafideApplicationForm where rollNumber = NEW.rollNumber;
      insert into applicationProcess.noDuesFormDateForm(rollNumber,fname,mname,lname,CourseName,gender) values(NEW.rollNumber,@fname,@mname,@lname,@CourseName,(select gender from studentDetailsDomain where rollNumber = NEW.rollNumber));
    end if;
    end if;
    end if;
    end if;
  END;

CREATE TRIGGER applicationProcess.triggerdeleteApplicationForm after insert on applicationProcess.applicationFormDelete
FOR EACH ROW
  BEGIN
     set @requestId = (select requestId from applicationProcess.applicationForm where rollNumber = NEW.rollNumber and appId = NEW.appId);
     set @appidx = (select appindex from applicationProcess.applicationDomain where appId = NEW.appId);
     delete from applicationProcess.applicationForm where requestId = @requestId;
     if(@appidx = 1) then
        delete from applicationProcess.bonafideApplicationForm where rollNumber = NEW.rollNumber;
     else if(@appidx = 2) then
        delete from applicationProcess.interNationalBonafideApplicationForm;
     else if(@appidx = 3) then
        delete from applicationProcess.feesStructureForm;
     else if(@appidx = 4) then
        delete from applicationProcess.noDuesFormDateForm where rollNumber = NEW.rollNumber;
     end if;
     end if;
     end if;
     end if;

  END;

 |
delimiter ;


