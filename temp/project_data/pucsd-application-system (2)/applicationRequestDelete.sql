DROP TRIGGER IF EXISTS applicationProcess.trigger_deteteapplicationRequestByStaff;

delimiter |

CREATE TRIGGER applicationProcess.trigger_deteteapplicationRequestByStaff after insert on applicationProcess.aux_requestStateTransitions
FOR EACH ROW
BEGIN
  insert into applicationProcess.g(a,b,c,d) values(NEW.requestId,NEW.userId,1,"shree ganesh");
END;

 |
delimiter ;
