DROP TABLE IF EXISTS userPassword;
DROP TABLE IF EXISTS userforgetPassword;
DROP TABLE IF EXISTS applicationCodeBySystem;
DROP TABLE IF EXISTS getApplicationCode;
DROP TABLE IF EXISTS errorMessage;
/*--------------------------------------------------------------*/
/*this table have user and password record */

CREATE TABLE IF NOT EXISTS userPassword (
   userId varchar(15) NOT NULL,
   password text NOT NULL,
   Constraint pk_userIdDomain Primary Key(userId),
   Foreign Key (userId) References userIdDomain(userId)
   ON DELETE RESTRICT ON UPDATE CASCADE
);

/*--------------------------------------------------------------*/
/*after click on forget password click the values of this table is going into the table
  userId and generated applicatioCode by modpython */

CREATE TABLE IF NOT EXISTS applicationCodeBySystem (
   userId varchar(15) NOT NULL,
   applicationCode text NOT NULL,
   Constraint pk_applicationCodeBySystem Primary Key(userId),
   Foreign Key(userId) References userIdDomain(userId)
   ON DELETE RESTRICT ON UPDATE CASCADE
);

/*--------------------------------------------------------------*/
/* after insert the application code by student then it goes to the next process */
CREATE TABLE IF NOT EXISTS userforgetPassword (
   userId varchar(15) NOT NULL,
   applicationCode text NOT NULL,
   Constraint pk_userIdDomain Primary Key(userId),
   Foreign Key (userId) References userIdDomain(userId)
   ON DELETE RESTRICT ON UPDATE CASCADE
);

/*--------------------------------------------------------------*/
/* staff check for the student application code so he enter the student userId in that table */
CREATE TABLE IF NOT EXISTS getApplicationCode (
   userId varchar(15) NOT NULL,
   Constraint pk_getApplicationCode Primary Key(userId),
   Foreign Key (userId) References userIdDomain(userId)
   ON DELETE RESTRICT ON UPDATE CASCADE
);

/*--------------------------------------------------------------*/
/* after success of the otp the changepaasword is come then user enter the password and confirmed password goes into that table */
CREATE TABLE IF NOT EXISTS changePassword (
  userId varchar(15) NOT NULL,
  password text NOT NULL,
  newPassword text NOT NULL,
  Foreign Key (userId) References userIdDomain(userId)
  ON DELETE RESTRICT ON UPDATE CASCADE
);

