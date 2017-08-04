import MySQLdb
import datetime;
from mod_python import Session
from config_path import data
import student
flag=5
Rollno=0
def index(req):
         session = Session.Session(req);
         Rollno=session['rno']
         session.save()
         session.cleanup()
         db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="applicationProcess" )
   	 # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
         #req.content_type="text/html"
         #req.write(str(studAct))

         ss=""" select rollNumber from internationalStudentInformationDomain;"""
         cursor.execute(ss)
         rnoarray=cursor.fetchall()
         rno=map(lambda x:x[0],rnoarray)
         if str(Rollno)in rno:
            fp=open(data.path+"/project_data/NewAppInter.html","r")
            ap=fp.read()
            return ap
         else:
            fp=open(data.path+"/project_data/Newapplication.html","r")
            ap=fp.read()
            return ap;

def for_bonafied(Rollno):
         flg=0
         doc='';
         db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="userInputDatabase")
   	 # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,"applicationForm","APBN");"""%(str(Rollno))
         cursor.execute(ss)
       	 db.commit();
       	 tabid="ApplicationRequests"
          
         ss="""select fromState,toState from applicationProcess.requestStateTransitions where userId=%s and params like %s;"""
         cursor.execute(ss,(Rollno,'APBN'+'%'))
         val=cursor.fetchall()
         
         states=('','')      
         if len(val)==0:
             flg=1
             ss="""insert into inputRequests(requestTime,requestType,userId,tableId,params)    values (NOW(),"insert",%s,%s,"APBN,start,ApplicationInitiated,Bonafide Certificate,apply for Bonafide Certificate");"""
         
             cursor.execute(ss,(Rollno,tabid))
             db.commit();
             	
         else:
           states=val[len(val)-1]

	 db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="applicationProcess" )
         # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
         
         if states==('start','ApplicationInitiated') or flg==1:
           flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationInitiated,ApplicationFormPartiallyFilled,Bonafide Certificate,apply for Bonafide Certificate");"""
 
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();

         if states==('ApplicationInitiated','ApplicationFormPartiallyFilled') or flg==1:
           flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationInitiated,ApplicationFormFilled,Bonafide Certificate,apply for Bonafide Certificate");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();

         

         fp=open(data.path+"/project_data/bonafied.html","r")
         fp=(fp.read())

         if states==('ApplicationInitiated','ApplicationFormFilled') or flg==1:
	   flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationFormPartiallyFilled,ApplicationFormPartiallyFilled,Bonafide Certificate,apply for Bonafide Certificate");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();

         if states==('ApplicationFormPartiallyFilled','ApplicationFormPartiallyFilled') or flg==1:
	   flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationFormPartiallyFilled,ApplicationFormFilled,Bonafide Certificate,apply for Bonafide Certificate");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();


         if states==('ApplicationFormPartiallyFilled','ApplicationFormFilled') or flg==1:
           flg=1
	   ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationFormFilled,ApplicationFormPartiallyFilled,Bonafide Certificate,apply for Bonafide Certificate");""" 

           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();



         if states==('ApplicationFormFilled','ApplicationFormPartiallyFilled') or flg==1:
           flg=1
	   ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationFormFilled,ApplicationFormFilled,Bonafide Certificate,apply for Bonafide Certificate");"""

           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();

	 ss="""select * from bonafideApplicationForm where rollNumber=%s;"""%(Rollno)
    	 cursor.execute(ss)
       	 val=cursor.fetchall()
         
         if states==('ApplicationFormFilled','ApplicationFormFilled') and flg==0:
            doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\"  value=\"Ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
	    return doc
     
    	 if flg==0 and states==('ApplicationFormFilled','ApplicationSubmitted'):
            return """<html>Allready applied..! <input type=\"button\" onclick=(window.history.back()) value=\"OK\">"""
         doc+="""<h1> your bonafied certificate:<br><br><br> <h1>"""       
	 year=int(str(val[0][10]).split('-')[0])
         doc+=fp%(val[0][1]+" "+val[0][2]+" "+val[0][3],int(val[0][0]),val[0][4],val[0][5],year,year+1,val[0][6],val[0][7],val[0][8],val[0][9]);
         doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\" value=\"Ok\"><input type=\"button\"  onclick=window.history.back() value=\"Cancel\"></form></body></head></html>"""
         return doc

def for_nodues(Rollno):
         flg=0
         doc='';
         db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="userInputDatabase" )
   	 # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
    
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,"applicationForm","APND");"""%(str(Rollno)) 
      
         cursor.execute(ss)
       	 db.commit();
  
       	 tabid="ApplicationRequests"
          
         ss="""select fromState,toState from applicationProcess.requestStateTransitions where userId=%s and params like %s;"""
         cursor.execute(ss,(Rollno,'APND'+'%'))
         val=cursor.fetchall()
         states=('','')      
         if len(val)==0:
             flg=1
             ss="""insert into inputRequests(requestTime,requestType,userId,tableId,params)    values (NOW(),"insert",%s,%s,"APND,start,ApplicationInitiated,No Dues Certificate,apply for No Dues Certificate");"""
         
             cursor.execute(ss,(Rollno,tabid))
             db.commit();
             
         else:
           states=val[len(val)-1]

         
 
	 db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="applicationProcess" )
         # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
         
         if states==('start','ApplicationInitiated') or flg==1:
           flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationInitiated,ApplicationFormPartiallyFilled,No Dues Certificate,apply for No Dues Certificate");"""
 
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
        


         
         if states==('ApplicationInitiated','ApplicationFormPartiallyFilled') or flg==1:
           flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationInitiated,ApplicationFormFilled,No Dues Certificate,apply for No Dues Certificate");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
           
         
         #disconnect from server
    	 #db.close()


         fp=open(data.path+"/project_data/no_dues.html","r")
         fp=(fp.read());


         if states==('ApplicationInitiated','ApplicationFormFilled') or flg==1:
	   flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationFormPartiallyFilled,ApplicationFormPartiallyFilled,No Dues Certificate,apply for No Dues Certificate");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
           
          
         if states==('ApplicationFormPartiallyFilled','ApplicationFormPartiallyFilled') or flg==1:
	   flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationFormPartiallyFilled,ApplicationFormFilled,No Dues Certificate,apply for No Dues Certificate");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();


         if states==('ApplicationFormPartiallyFilled','ApplicationFormFilled') or flg==1:
           flg=1
	   ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationFormFilled,ApplicationFormPartiallyFilled,No Dues Certificate,apply for No Dues Certificate");""" 

           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();


         

         if states==('ApplicationFormFilled','ApplicationFormPartiallyFilled') or flg==1:
           flg=1
	   ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationFormFilled,ApplicationFormFilled,No Dues Certificate,apply for No Dues Certificate");"""

           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
         
	 ss="""select * from noDuesFormDateForm where rollNumber=%s;"""%(Rollno)
    	 cursor.execute(ss)
       	 val=cursor.fetchall()
         
         if states==('ApplicationFormFilled','ApplicationFormFilled') and flg==0:
            doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\"  value=\"ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
	    return doc           
	 

    	 if flg==0 and states==('ApplicationFormFilled','ApplicationSubmitted'):
            return """<html>Allready applied..! <input type=\"button\" onclick=(window.history.back()) value=\"OK\">"""
         doc+="""<h1> your bonafied certificate:<br><br><br> <h1>"""       
	 #year=int(str(val[0][10]).split('-')[0])
         doc+=fp%(val[0][1]+" "+val[0][2]+" "+val[0][3]+" ",int(Rollno),val[0][4],)
         doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\" value=\"Ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
	 return doc

def for_feesstructure(Rollno):
         flg=0
         doc='';
         db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="userInputDatabase" )
   	 # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
    
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,"applicationForm","APFS");"""%(str(Rollno)) 
      
         cursor.execute(ss)
       	 db.commit();
  
       	 tabid="ApplicationRequests"
          
         ss="""select fromState,toState from applicationProcess.requestStateTransitions where userId=%s and params like %s;"""
         cursor.execute(ss,(Rollno,'APFS'+'%'))
         val=cursor.fetchall()
         states=('','')      
         if len(val)==0:
             flg=1
             ss="""insert into inputRequests(requestTime,requestType,userId,tableId,params)    values (NOW(),"insert",%s,%s,"APFS,start,ApplicationInitiated,Fee Structure Certificate For Bank,apply for Fee Structure Certificate For Bank");"""
         
             cursor.execute(ss,(Rollno,tabid))
             db.commit();
             
         else:
           states=val[len(val)-1]

         
 
	 db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="applicationProcess" )
         # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
         
         if states==('start','ApplicationInitiated') or flg==1:
           flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationInitiated,ApplicationFormPartiallyFilled,Fee Structure Certificate For Bank,apply for Fee Structure Certificate For Bank");"""
 
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
        


         
         if states==('ApplicationInitiated','ApplicationFormPartiallyFilled') or flg==1:
           flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationInitiated,ApplicationFormFilled,Fee Structure Certificate For Bank,apply for Fee Structure Certificate For Bank");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
           
         
         #disconnect from server
    	 #db.close()


         fp=open(data.path+"/project_data/fees_structure.html","r")
         fp1=open(data.path+"/project_data/feestructureformca.html","r")
         fp1=fp1.read()
         fp=(fp.read());



         if states==('ApplicationInitiated','ApplicationFormFilled') or flg==1:
	   flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationFormPartiallyFilled,ApplicationFormPartiallyFilled,Fee Structure Certificate For Bank,apply for Feees Structure Application");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
           
          
         if states==('ApplicationFormPartiallyFilled','ApplicationFormPartiallyFilled') or flg==1:
	   flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationFormPartiallyFilled,ApplicationFormFilled,Fee Structure Certificate For Bank,apply for Fee Structure Certificate For Bank");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();


         if states==('ApplicationFormPartiallyFilled','ApplicationFormFilled') or flg==1:
           flg=1
	   ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationFormFilled,ApplicationFormPartiallyFilled,Fee Structure Certificate For Bank,apply for Fee Structure Certificate For Bank");""" 

           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();


         

         if states==('ApplicationFormFilled','ApplicationFormPartiallyFilled') or flg==1:
           flg=1
	   ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationFormFilled,ApplicationFormFilled,Fee Structure Certificate For Bank,apply for FeesStructure Application");"""

           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
         
	 ss="""select * from applicationProcess.feesStructureForm where rollNumber=%s ;"""%(Rollno)
    	 cursor.execute(ss)
       	 val=cursor.fetchall()
         
         if states==('ApplicationFormFilled','ApplicationFormFilled') and flg==0:
            doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\"  value=\"ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
	    return doc           
	 

    	 if flg==0 and states==('ApplicationFormFilled','ApplicationSubmitted'):
            return """<html>Allready applied..! <input type=\"button\" onclick=(window.history.back()) value=\"OK\">"""
         doc+="""<h1> your bonafied certificate:<br><br><br> <h1>"""       
	 #year=int(str(val[0][10]).split('-')[0])
         if val[0][4]=='MCA':  
           doc+=fp1%(val[0][1]+" "+val[0][2]+" "+val[0][3],val[0][4],val[0][6],val[1][6],val[2][6],val[3][6],val[4][6],val[5][6],val[0][7],val[1][7],val[2][7],val[3][7],val[4][7],val[5][7],val[0][8],val[1][8],val[2][8],val[3][8],val[4][8],val[5][8],val[0][9],val[1][9],val[2][9],val[3][9],val[4][9],val[5][9])
         else:
		doc+=fp%(val[0][1]+" "+val[0][2]+" "+val[0][3],val[0][4],val[0][6],val[1][6],val[2][6],val[3][6],val[0][7],val[1][7],val[2][7],val[3][7],val[0][8],val[1][8],val[2][8],val[3][8],val[0][9],val[1][9],val[2][9],val[3][9])
         doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\" value=\"Ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
	 return doc


def for_inter_bonafied(Rollno):
         flg=0
         doc='';
         
         db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="userInputDatabase" )
   	 # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
                  
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,"applicationForm","APIB");""" 

         cursor.execute(ss,(Rollno))
       	 db.commit();
       	 tabid="ApplicationRequests"
          
         ss="""select fromState,toState from applicationProcess.requestStateTransitions where userId=%s and params like %s;"""
         cursor.execute(ss,(Rollno,'APIB'+'%'))
         val=cursor.fetchall()
         states=('','')      
         if len(val)==0:
             flg=1
             ss="""insert into inputRequests(requestTime,requestType,userId,tableId,params)    values (NOW(),"insert",%s,%s,"APIB,start,ApplicationInitiated,Bonafide Certificate,apply for Bonafide Certificate");"""
         
             cursor.execute(ss,(Rollno,tabid))
             db.commit();
             
         else:
           states=val[len(val)-1]

         
         
	 db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="applicationProcess" )
         # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
         
         if states==('start','ApplicationInitiated') or flg==1:
           flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationInitiated,ApplicationFormPartiallyFilled,Bonafide Certificate,apply for Bonafide Certificate");"""
 
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
        


         
         if states==('ApplicationInitiated','ApplicationFormPartiallyFilled') or flg==1:
           flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationInitiated,ApplicationFormFilled,Bonafide Certificate,apply for Bonafide Certificate");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
           
         
         #disconnect from server
    	 #db.close()

         
         fp=open(data.path+"/project_data/international_stud_bonafied.html","r")
         fp=(fp.read());


         if states==('ApplicationInitiated','ApplicationFormFilled') or flg==1:
	   flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationFormPartiallyFilled,ApplicationFormPartiallyFilled,Bonafide Certificate,apply for Bonafide Certificate");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
           
          
         if states==('ApplicationFormPartiallyFilled','ApplicationFormPartiallyFilled') or flg==1:
	   flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationFormPartiallyFilled,ApplicationFormFilled,Bonafide Certificate,apply for Bonafide Certificate");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();


         if states==('ApplicationFormPartiallyFilled','ApplicationFormFilled') or flg==1:
           flg=1
	   ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationFormFilled,ApplicationFormPartiallyFilled,Bonafide Certificate,apply for Bonafide Certificate");""" 

           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();


         

         if states==('ApplicationFormFilled','ApplicationFormPartiallyFilled') or flg==1:
           flg=1
	   ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationFormFilled,ApplicationFormFilled,Bonafide Certificate,apply for Bonafide Certificate");"""

           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
         
	 ss = """select * from applicationProcess.interNationalBonafideApplicationForm where rollNumber=%s ;"""%(Rollno)
    	 cursor.execute(ss)
       	 val=cursor.fetchall()
         
         if states==('ApplicationFormFilled','ApplicationFormFilled') and flg==0:
            doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\"  value=\"ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
	    return doc           
	 

    	 if flg==0 and states==('ApplicationFormFilled','ApplicationSubmitted'):
            return """<html>Allready applied..! <input type=\"button\" onclick=(window.history.back()) value=\"OK\">"""
         doc+="""<h1> your bonafied certificate:<br><br><br> <h1>"""       
	 #year=int(str(val[0][10]).split('-')[0])
         
         doc+=fp%(val[0][1]+" "+val[0][2]+" "+val[0][3],val[0][1]+" "+val[0][2]+" "+val[0][3],val[0][8],val[0][9],int(val[0][10]),int(val[0][12]),int(val[0][15]),val[0][13],val[0][16],val[0][14],val[0][17],val[0][18],val[0][19],val[0][7],val[0][4],val[0][4],val[0][11]);
         doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\" value=\"Ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
	 return doc



def print_Application(req):
           f=flag
	   session = Session.Session(req);
           Rollno=session['rno']
           tabid="ApplicationRequests"
           db = MySQLdb.connect(
    	   host="localhost",
    	   user=data.mysql_user,
    	   passwd=data.mysql_pswd,
    	   db="userInputDatabase" )
   	   # prepare a cursor object using cursor() method
    	   cursor = db.cursor()
           arrayid=["APBN,ApplicationFormFilled,ApplicationSubmitted,Bonafide Certificate,apply for Bonafide Certificate","APND,ApplicationFormFilled,ApplicationSubmitted,No Dues Certificate,apply for No Dues Certificate"
,"APFS,ApplicationFormFilled,ApplicationSubmitted,Fee Structure Certificate For Bank,apply for Fee Structure Certificate For Bank","APIB,ApplicationFormFilled,ApplicationSubmitted,International Bonafide Certificate,apply for International Bonafide Certificate"]
           
           psid=arrayid[f]
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,%s);"""
           cursor.execute(ss,(Rollno,tabid,psid))
       	   db.commit();

           #okr=open(data.path+"/project_data/ok.html")
           #okr=okr.
           #fp = open(data.path+"/project_data/try.html")
           #fp = fp.read()
           return "ok"

def print_data(req):
     info=req.form
     name=info['doc']
     session = Session.Session(req);
     req.content_type="text/html"
     #req.write("ROLL NO:"+session['rno'])
     Rollno=session['rno'];
     session.cleanup()
     if name=="string:Bonafied":
           global flag
           flag=0
           return for_bonafied(Rollno)
     if name=="string:No Dues":
         flag=1;
         return for_nodues(Rollno)
     if name=="string:Fees Structure":
         flag=2;
         return for_feesstructure(Rollno)
     if name=="string:International student Bonafied":
         flag=3;
         return for_inter_bonafied(Rollno)

