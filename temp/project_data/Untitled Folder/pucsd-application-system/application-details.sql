DROP TABLE IF EXISTS courseDomain;
DROP TABLE IF EXISTS courceSemesterDomain;
DROP TABLE IF EXISTS reqeustTypeDomain;
DROP TABLE IF EXISTS tableIdDomain;
DROP TABLE IF EXISTS applicationDomain;
DROP TABLE IF EXISTS studentDetailsDomain;


/* ---------------------------------------------------------  */

/* courseId and year */

CREATE TABLE IF NOT EXISTS courseDomain (
  courseId varchar(3) NOT NULL,
  year varchar(1) NOT NULL,
  Constraint pk_courseDomain Primary Key(courseId,year)
);

/* ---------------------------------------------------------  */

/*courseId with semester */

CREATE TABLE IF NOT EXISTS courseSemesterDomain (
  courseId varchar(3) NOT NULL,
  year varchar(1) NOT NULL,
  semId varchar(1) NOT NULL,
  Constraint pk_courseSemesterDomain Primary Key(courseId,semId),
  Foreign Key(courseId,year) References courseDomain(courseId,year)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/* ---------------------------------------------------------  */

/* feesStructure for maharashtrian Student */

CREATE TABLE IF NOT EXISTS feesStructureDomain (
  category varchar(5) Not NULL,
  courseId varchar(3) NOT NULL,
  semId varchar(1) NOT NULL,
  tutionFee integer NOT NULL,
  labFee integer NOT NULL,
  otherFee integer NOT NULL,
  Constraint pk_feesStructureDomain Primary Key(category,courseId,semId),
  Foreign Key(courseId,semId) References courseSemesterDomain(courseId,semId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/* ---------------------------------------------------------  */

/* feesStructure for non-maharashtrian Student */

CREATE TABLE IF NOT EXISTS feesStructureNonMaharashtrianDomain (
  category varchar(5) Not NULL,
  courseId varchar(3) NOT NULL,
  semId varchar(1) NOT NULL,
  tutionFee integer NOT NULL,
  labFee integer NOT NULL,
  otherFee integer NOT NULL,
  Constraint pk_feesStructureOmsStudentDomain Primary Key(category,courseId,semId),
  Foreign Key(courseId,semId) References courseSemesterDomain(courseId,semId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/* ---------------------------------------------------------  */

/* feesStructure for international Student */

CREATE TABLE IF NOT EXISTS feesStructureForInternationalStudentDomain (
  category varchar(5) Not NULL,
  courseId varchar(3) NOT NULL,
  semId varchar(1) NOT NULL,
  tutionFee integer NOT NULL,
  labFee integer NOT NULL,
  otherFee integer NOT NULL,
  Constraint pk_feesStructureForInternationalStudentDomain Primary Key(category,courseId,semId),
  Foreign Key(courseId,semId) References courseSemesterDomain(courseId,semId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/* ---------------------------------------------------------  */
/* applicationId and with its index and desc */

CREATE TABLE IF NOT EXISTS applicationDomain (
  appId varchar(5) NOT NULL,
  appindex varchar(1) NOT NULL,
  appDesc text NOT NULL,
  Constraint pk_applicationDomain Primary Key(appId,appindex)
);

/* ---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS applicationCntDomain (
  appId varchar(5) NOT NULL,
  appcnt integer NOT NULL,
  Constraint pk_applicationCntDomain Primary Key(appId,appcnt)
);

/* ---------------------------------------------------------  */

/* country name */

CREATE TABLE IF NOT EXISTS countryDomain (
  countryId varchar(2) NOT NULL,
  countryName text NOT NULL,
  Constraint pk_countryDomain Primary Key(countryId)
);

/* ---------------------------------------------------------  */
/* stateName */

CREATE TABLE IF NOT EXISTS stateDomain (
  stateId int NOT NULL,
  stateName varchar(40) NOT NULL,
  Constraint pk_stateDomain Primary Key(stateId)
);

/* ---------------------------------------------------------  */

/* country and state name */

CREATE TABLE IF NOT EXISTS countryStateDomain (
  countryId varchar(2) NOT NULL,
  stateId int NOT NULL,
  Constraint pk_countryStateCityDomain Primary Key(countryId,stateId),
  Foreign key (countryId) References countryDomain(countryId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign key (stateId) References stateDomain(stateId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/* ---------------------------------------------------------  */

/* city name */

CREATE TABLE IF NOT EXISTS cityDomain (
  cityId int NOT NULL,
  cityName varchar(50) NOT NULL,
  Constraint pk_cityDomain Primary Key(cityId)
);

/* ---------------------------------------------------------  */

/* state with city */

CREATE TABLE IF NOT EXISTS stateCityDomain (
  cityId int NOT NULL,
  stateId int NOT NULL,
  Constraint pk_countryStateCityDomain Primary Key(cityId,stateId),
  Foreign Key (stateId) References countryStateDomain(stateId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (cityId) References cityDomain(cityId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/* ---------------------------------------------------------  */

/* userId of applicationProcess*/

CREATE TABLE IF NOT EXISTS userIdDomain (
  userId varchar(15),
  Constraint pk_userIdDomain Primary Key(userId)
);

/* ---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS studentDetailsDomain (
  rollNumber varchar(15) NOT NULL,
  courseId varchar(3) NOT NULL,
  semId varchar(1) NOT NULL,
  category varchar(5) NOT NULL,
  fname text NOT NULL,
  mname text,
  lname text NOT NULL,
  email text NOT NULL,
  dateOfBirth date NOT NULL,
  contactNo varchar(10) NOT NULL,
  gender varchar(1) NOT NULL,
  domicile boolean NOT NULL,
  adderessLine1 varchar(50) NOT NULL,
  adderessLine2 varchar(50) NOT NULL,
  adderessLine3 varchar(50) NOT NULL,
  cityId int NOT NULL,
  stateId int NOT NULL,
  countryId varchar(2) NOT NULL,
  Constraint pk_studentDetails Primary Key(rollNumber),
  Foreign Key (stateId,cityId) References stateCityDomain(stateId,cityId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (rollNumber) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (countryId) References countryDomain(countryId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (category) References feesStructureDomain(category)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (courseId) References courseDomain(courseId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/* ---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS internationalStudentInformationDomain (
  rollNumber varchar(15) NOT NULL,
  nationality text NOT NULL,
  studentAddrInCity text NOT NULL,
  dateOfFirstAdmsn date NOT NULL,
  passportNo text NOT NULL,
  issuedOn date NOT NULL,
  passportValidTill date NOT NULL,
  visaNo text NOT NULL,
  visaType text NOT NULL,
  visaIssuedOn date NOT NULL,
  visaValidTill date NOT NULL,
  stayVisaUpTo integer NOT NULL,
  regularOrBacklog text,
  examDate date,
  resultDate  date,
  Constraint pk_internationalStudentInformationDomain Primary Key(rollNumber),
  Foreign Key(rollNumber) References studentDetailsDomain(rollNumber)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/* ---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS staffDetailsDomain (
  staffId varchar(15),
  qualification text,
  address text,
  Constraint pk_statffDetailsDomain Primary Key(staffId),
  Foreign Key (staffId) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/* ---------------------------------------------------------  */

/* all state eg. start */

CREATE TABLE IF NOT EXISTS applicationStateDomain (
  applicationState varchar(30) NOT NULL,
  Constraint pk_applicationState Primary Key(applicationState)
);

/* ---------------------------------------------------------  */

/* have two state start and final */

CREATE TABLE IF NOT EXISTS startAndfinalStateDomain (
  applicationState varchar(30) NOT NULL,
  Constraint pk_startAndfinalStateDomain Primary Key(applicationState),
  Foreign key(applicationState) References applicationStateDomain(applicationState)
  ON DELETE RESTRICT ON UPDATE CASCADE
);
/* ---------------------------------------------------------  */

/*
eg.  start,ApplicationInitiated */

CREATE TABLE IF NOT EXISTS stateChangeDomain
(
  fromState varchar(30),
  toState varchar(30),
  Constraint pk_stateChangeDomain Primary Key(fromState,toState),
  Foreign key(fromState) References applicationStateDomain(applicationState)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign key(toState) References applicationStateDomain(applicationState)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */
/* staff Action 
eg. ApplicationSubmitted,requestArrivedInOffice */

CREATE TABLE IF NOT EXISTS staffActionDomain (
  staffActionFrom varchar(30),
  staffActionTo varchar(30),
  Constraint pk_staffActionDomain Primary Key(staffActionFrom,staffActionTo),
  Foreign Key (staffActionFrom,staffActionTo) References stateChangeDomain(fromState,toState)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

/* student Action
eg.  start,ApplicationInitiated
*/
CREATE TABLE IF NOT EXISTS studentActionDomain (
  studentActionFrom varchar(30),
  studentActionTo varchar(30),
  Constraint pk_studentActionDomain Primary Key(studentActionFrom,studentActionTo),
  Foreign Key (studentActionFrom,studentActionTo) References stateChangeDomain(fromState,toState)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

/*requestId */

CREATE TABLE IF NOT EXISTS requestindex (
   requestId bigint NOT NULL,
   Constraint pk_requestindex Primary Key(requestId)
);

/*---------------------------------------------------------  */

/* this table for the when student request for certificate so he can know the his certificate is availble or not */

CREATE TABLE IF NOT EXISTS aux_studentAndState (
  requestId bigint NOT NULL,
  rollNumber varchar(15) NOT NULL,
  fromState varchar(30) NOT NULL,
  toState varchar(30) NOT NULL,
  appId varchar(5) NOT NULL,
  Constraint pk_aux_studentAndState Primary Key(requestId,rollNumber,fromState,toState,appId),
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(rollNumber) References studentDetailsDomain(rollNumber)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(fromState,toState) References stateChangeDomain(fromState,toState)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

/* this table for only student so he can insert his current state and proceed */

CREATE TABLE IF NOT EXISTS applicationRequests (
  requestId bigInt NOT NULL,
  appId varchar(5) NOT NULL,
  userId varchar(15) NOT NULL,
  requestArrivalTime timestamp NOT NULL,
  remark text,
  params text,
  applicationPdf blob,
  Constraint pk_applicationRequests Primary Key(requestId),
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(userId) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

/* this table for only student so he can delete his  state and proceed */

CREATE TABLE IF NOT EXISTS aux_applicationRequestsDelete (
  requestId bigInt NOT NULL,
  appId varchar(5) NOT NULL,
  userId varchar(15) NOT NULL,
  requestArrivalTime timestamp NOT NULL,
  remark text,
  params text,
  applicationPdf blob,
  Constraint pk_aux_applicationRequestsDelete Primary Key(requestId),
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(userId) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

/* this table for only student so he can update his  state and proceed */

CREATE TABLE IF NOT EXISTS aux_applicationRequestsUpdate (
  requestId bigInt NOT NULL,
  appId varchar(5) NOT NULL,
  userId varchar(15) NOT NULL,
  requestArrivalTime timestamp NOT NULL,
  remark text,
  params text,
  Constraint pk_aux_applicationRequestsUpdate Primary Key(requestId),
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(userId) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS aux_applicationRequestsUpdateappId (
  requestId bigInt NOT NULL,
  appId varchar(5) NOT NULL,
  userId varchar(15) NOT NULL,
  requestArrivalTime timestamp NOT NULL,
  remark text,
  params text,
  applicationPdf blob,
  Constraint pk_aux_applicationRequestsUpdateappId Primary Key(requestId,appId),
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(userId) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS aux_applicationRequestsUpdateRequestId (
  requestId bigInt NOT NULL,
  appId varchar(5) NOT NULL,
  userId varchar(15) NOT NULL,
  requestArrivalTime timestamp NOT NULL,
  remark text,
  params text,
  applicationPdf blob,
  Constraint pk_aux_applicationRequestsUpdateRequestId Primary Key(requestId,appId),
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(userId) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

/* this is for when application process is finish then all records from that table deletes and new record is inserted it helps for finding the duplicate state */

CREATE TABLE IF NOT EXISTS aux_requestStateTransitions (
  requestId bigInt NOT NULL,
  fromState varchar(30) NOT NULL,
  toState varchar(30) NOT NULL,
  userId varchar(15) NOT NULL,
  appId varchar(5) NOT NULL,
  requestArrivalTime timestamp NOT NULL,
  remark text,
  params text,
  Constraint pk_aux_requestStateTransitions Primary Key(requestId,fromState,toState,userId),
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(fromState,toState) References stateChangeDomain(fromState,toState)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(userId) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

/* here all requstId and within its request State */

CREATE TABLE IF NOT EXISTS requestStateTransitions (
  requestId bigInt NOT NULL,
  fromState varchar(30) NOT NULL,
  toState varchar(30) NOT NULL,
  userId varchar(15) NOT NULL,
  requestArrivalTime timestamp NOT NULL,
  remark text,
  params text,
  Constraint pk_requestStateTransitions Primary Key(requestId,fromState,toState,userId),
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(fromState,toState) References stateChangeDomain(fromState,toState)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(userId) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

/* it is like queue for application form */

CREATE TABLE IF NOT EXISTS studentApplicationQueue (
  requestId bigInt NOT NULL,
  rollnumber varchar(15) NOT NULL,
  appId varchar(5) NOT NULL,
  requestArrivalTime timestamp NOT NULL,
  fromState varchar(30) NOT NULL,
  toState varchar(30) NOT NULL,
  Constraint pk_studentApplicationQueue Primary Key(requestId,rollnumber,appId,fromState,toState,requestArrivalTime),
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(rollnumber) References studentDetailsDomain(rollnumber)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

/*applcation process by staff */

CREATE TABLE IF NOT EXISTS applicationRequestByStaff (
  requestId bigInt NOT NULL,
  appId varchar(5) NOT NULL,
  userId varchar(15) NOT NULL,
  requestArrivalTime timestamp NOT NULL,
  remark text,
  params text,
  Constraint pk_applicationRequestByStaff Primary Key(requestId),
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(userId) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

CREATE TABLE IF NOT EXISTS studentApplicationCount (
  requestId bigInt NOT NULL,
  rollNumber varchar(15) NOT NULL,
  appId varchar(5) NOT NULL,
  appcnt integer default 0,
  Constraint pk_studentApplicationCount primary key(requestId,rollNumber,appId,appcnt),
  Foreign Key(requestId) References requestindex(requestId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(rollNumber) References studentDetailsDomain(rollNumber)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key(appId) References applicationDomain(appId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*---------------------------------------------------------  */

