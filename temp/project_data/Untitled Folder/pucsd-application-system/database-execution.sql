DROP DATABASE IF EXISTS userInputDatabase;
DROP DATABASE IF EXISTS applicationProcess;

CREATE DATABASE IF NOT EXISTS userInputDatabase;
CREATE DATABASE IF NOT EXISTS applicationProcess;

use userInputDatabase;
SET group_concat_max_len=15000;
SOURCE user-input.sql;
SOURCE student.sql;

use applicationProcess;
SET group_concat_max_len=15000;
SOURCE split-str.sql;
SOURCE application-details.sql;
SOURCE userAndPasswordDetails.sql;
SOURCE form-detail.sql;
SOURCE application.sql;
SOURCE validation-string.sql;
SOURCE validation-application.sql;
SOURCE validation-requestState.sql;
SOURCE validation-applicationRequestId.sql;
SOURCE requeststate-string.sql;
SOURCE requeststate-updaterequestIdString.sql;
SOURCE application-request-fordelete.sql;
SOURCE application-request-forupdate.sql;
SOURCE applicationRequestProcess.sql;
SOURCE application-request-forapplicationupdate.sql;
SOURCE applicationRequestStateTransitionsProcess.sql;
SOURCE applicationRequestProcessByStaff.sql;

use userInputDatabase;
/*SOURCE test_16149.sql;
SOURCE test_16104.sql;
SOURCE test_16103.sql;
SOURCE test-staff.sql;
/*SOURCE test-staff1.sql;*/
use mysql
drop table if EXISTS StudentStatusnew;
create table StudentStatusnew(RollNo int,Ref_No varchar(20), Document varchar(50),status varchar(50));


select * from outputErrorMsgs order by requestId;
select * from outputResults;

