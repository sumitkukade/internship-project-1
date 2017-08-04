LOAD DATA LOCAL INFILE 'courseDomain.csv' INTO TABLE courseDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'courseSemesterDomain.csv' INTO TABLE courseSemesterDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'feesStructureDomain.csv' INTO TABLE feesStructureDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'feesStructureNonMaharashtrianDomain.csv' INTO TABLE feesStructureNonMaharashtrianDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'feesStructureForInternationalStudentDomain.csv' INTO TABLE feesStructureForInternationalStudentDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'countryDomain.csv' INTO TABLE countryDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'stateDomain.csv' INTO TABLE stateDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'countryStateDomain.csv' INTO TABLE countryStateDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'cityDomain.csv' INTO TABLE cityDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'stateCityDomain.csv' INTO TABLE stateCityDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'applicationDomain.csv' INTO TABLE applicationDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'applicationCntDomain.csv' INTO TABLE applicationCntDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'userIdDomain.csv' INTO TABLE userIdDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'userPassword.csv' INTO TABLE userPassword FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'studentDetailsDomain.csv' INTO TABLE studentDetailsDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'internationalStudentInformationDomain.csv' INTO TABLE internationalStudentInformationDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'staffDetailsDomain.csv' INTO TABLE staffDetailsDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'applicationStateDomain.csv' INTO TABLE applicationStateDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'startAndfinalStateDomain.csv' INTO TABLE startAndfinalStateDomain  FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'stateChangeDomain.csv' INTO TABLE stateChangeDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'staffActionDomain.csv' INTO TABLE staffActionDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE 'studentActionDomain.csv' INTO TABLE studentActionDomain FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

/*LOAD DATA LOCAL INFILE 'nums.csv' INTO TABLE temp2 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

SELECT DISTINCT cityId INTO OUTFILE '/home/reshma/sresult.txt'  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'    LINES TERMINATED BY '\n' FROM stateCityDomain;*/

/*select city.cityId,state.stateId from stateDomain as state,(select c.cityId,sc.stateId  from cityDomain as c,stateCityDomain as sc where c.cityName = sc.cityId) as city where city.stateId = state.stateName;
*/
/*create table cityStateDomain(cityId int,stateId int); 
insert into cityStateDomain(cityId,stateId) (select distinct city.cityId,state.stateId from stateDomain as state,(select c.cityId,sc.stateId  from cityDomain as c,stateCityDomain as sc where c.cityName = sc.cityId) as city where city.stateId = state.stateName);
*/

/* select distinct userId,max(requestId)  from (select * from applicationProcess.requestStateTransitions where userId in (select rollNumber from applicationProcess.studentDetailsDomain)) as u group by userId;*/

