DROP TABLE IF EXISTS requestTypeDomain;
DROP TABLE IF EXISTS tableIdDomain;
DROP TABLE IF EXISTS messagesForUsersDomain;
DROP TABLE IF EXISTS inputRequests;
DROP TABLE IF EXISTS outputErrorMsgs;
DROP TABLE IF EXISTS outputResults;

/*-------------------------------------------------------------------*/

/* /insert/update/delete/select */

CREATE TABLE IF NOT EXISTS requestTypeDomain (
  requestTypeId varchar(1) NOT NULL,
  requestType varchar(6) NOT NULL,
  Constraint pk_requestTypeDomain Primary Key(requestType)
);

/*-------------------------------------------------------------------*/

/* this table have table name that user want perform above action in it.
-applicationForm table for student so he can insert his rollNumber and application and other detail so it gives result of application in corroseponding application table
-applicationRequestByStaff table for staff so staff can perform application form processs.that table contain state
-applicationRequest table for student he can insert his state from it the execute the application proceess.this table for state.
-requestStateTransitions table for which task is done
*/

CREATE TABLE IF NOT EXISTS tableIdDomain (
   tableId varchar(50) NOT NULL,
   tableIndex integer NOT NULL,
   Constraint pk_tableIdDomain Primary Key(tableId,tableIndex)
);

/*-------------------------------------------------------------------*/


CREATE TABLE IF NOT EXISTS messagesForUsersDomain (
   msgId varchar(35) NOT NULL,
   msgForAcomplish text NOT NULL,
   msgAboutUserAuthentication text NOT NULL,
   msgForState text NOT NULL,
   Constraint pk_messagesForUsersDomain Primary Key(msgId)
);

/*-------------------------------------------------------------------*/

/* all user are perform action from that table
eg. requestId is auto increment
    requestTime is taken by system eg. NOW()
    requestType /insert/update/delete/select
    userId either student or staff
    tableid gives tableName so parameter can inserted in that table
    params table field
*/


CREATE TABLE inputRequests (
  requestId bigint primary key auto_increment,
  requestTime timestamp NOT NULL,
  requestType varchar(6) NOT NULL,
  userId long NOT NULL,
  tableId varchar(50) NOT NULL,
  params text,
  Foreign Key (tableId) References tableIdDomain(tableId)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  Foreign Key (requestType) References requestTypeDomain(requestType)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*-------------------------------------------------------------------*/

/*all errMsg in it */

CREATE TABLE outputErrorMsgs (
  requestId bigint,
  timet timestamp,
  msgId varchar(30),
  msg text,
  Constraint pk_outputErrorMsgs Primary Key(requestId,timet),
  Foreign Key (msgId) References messagesForUsersDomain(msgId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

/*-------------------------------------------------------------------*/

/* all result of the state and select queries in it */

CREATE TABLE outputResults (
  requestId bigint,
  timet timestamp,
  output longtext,
  Constraint pk_outputResults Primary Key(requestId,timet)
);
