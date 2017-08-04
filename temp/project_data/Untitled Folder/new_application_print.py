import MySQLdb
import pdfkit
import datetime;
from mod_python import Session
from config_path import data
from validate import validate
flag=5
def index():
    fp=open(data.path+"/project_data/Newapplication.html","r")
    ap=fp.read()
    
    return ap;



def for_bonafied(Rollno):
         flg=0
         db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="userInputDatabase" )
   	 # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
  
       	 tabid="ApplicationRequests"
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,"applicationForm","APBN");"""%(str(Rollno)) 
      
         cursor.execute(ss)
       	 db.commit();
	 
         ss="""select fromState,toState from applicationProcess.requestStateTransitions where userId=%s;"""%(Rollno)
         cursor.execute(ss)
         val=cursor.fetchall()
         states=('','')      
         if len(val)==0:
             flg=1
             ss="""insert into inputRequests(requestTime,requestType,userId,tableId,params)    values (NOW(),"insert",%s,%s,"APBN,start,ApplicationInitiated,bonafide Application,apply for bonafide Application");"""
         
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
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationInitiated,ApplicationFormPartiallyFilled,bonafide Application,apply for bonafide Application");"""
 
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
        


         
         if states==('ApplicationInitiated','ApplicationFormPartiallyFilled') or flg==1:
           flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationInitiated,ApplicationFormFilled,bonafide Application,apply for bonafide Application");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
           
         
         #disconnect from server
    	 #db.close()

         
         doc="""<h1> your bonafied certificate:<br><br><br> <h1>"""
         fp=open(data.path+"/project_data/bonafied.html","r")
         fp=(fp.read());


         if states==('ApplicationInitiated','ApplicationFormFilled') or flg==1:
	   flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationFormPartiallyFilled,ApplicationFormPartiallyFilled,bonafide Application,apply for bonafide Application");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
           
          
         if states==('ApplicationFormPartiallyFilled','ApplicationFormPartiallyFilled') or flg==1:
	   flg=1
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationFormPartiallyFilled,ApplicationFormFilled,bonafide Application,apply for bonafide Application");"""
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();


         if states==('ApplicationFormPartiallyFilled','ApplicationFormFilled') or flg==1:
           flg=1
	   ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationFormFilled,ApplicationFormPartiallyFilled,bonafide Application,apply for bonafide Application");""" 

           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();


         

         if states==('ApplicationFormFilled','ApplicationFormPartiallyFilled') or flg==1:
           flg=1
	   ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APBN,ApplicationFormFilled,ApplicationFormFilled,bonafide Application,apply for bonafide Application");"""
           return "kk"
           cursor.execute(ss,(Rollno,tabid))
       	   db.commit();
         
         ss="""select * from bonafideApplicationForm where rollNumber=%s;"""%(Rollno)
    	 cursor.execute(ss)
       	 val=cursor.fetchall()
    	 if flg==0:
            return """<html>Allready applied..! <a href="http://localhost/myproject/project_data/student.py">OK</a></html>"""
         
	 year=int(str(val[0][10]).split('-')[0])
         doc+=fp%(val[0][1]+" "+val[0][2]+" "+val[0][3],int(val[0][0]),val[0][4],val[0][5],year,year+1,val[0][6],val[0][7],val[0][8],val[0][9]);
         doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\" value=\"ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
	 return doc

def pbonafied():
          
          fp=open(data.path+"/project_data/bonafied.html","r")
          fp=(fp.read());
          doc=fp%('d',12,'we','df');
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
           arrayid=["APBN,ApplicationFormFilled,ApplicationSubmitted,bonafide Application,apply for bonafide Application","APND,ApplicationFormFilled,ApplicationSubmitted,No Dues Application,apply for No Dues Application"
,"APFS,ApplicationFormFilled,ApplicationSubmitted,Fees Structure Application,apply for Fees Structure Application","APIB,ApplicationFormFilled,ApplicationSubmitted,International bonafide Application,apply for International bonafide Application"]
           
           psid=arrayid[f]
           ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,%s);"""
           cursor.execute(ss,(Rollno,tabid,psid))
       	   db.commit();

           okr=open(data.path+"/project_data/ok.html")
           okr=okr.read()
           
           return """<html><a href="http://localhost/myproject/project_data/student.py">OK</a></html>"""
def print_data(req):
     info=req.form
     name=info['doc']
     session = Session.Session(req);
     req.content_type="text/html"
     #req.write("ROLL NO:"+session['rno'])
     Rollno=session['rno'];
     session.cleanup()
     if name=="string:bonafied":
           global flag
           flag=0
           return for_bonafied(Rollno)
     if name=="string:no dues":
         flag=1;
	    
	 db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
	 db="userInputDatabase" )
   		 # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
         tabid="ApplicationRequests"
         ss="""insert into inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,start,ApplicationInitiated,NoDues Certificate,apply for NoDues certificate");"""
        
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit(); 
	 db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="applicationProcess" )
         # prepare a cursor object using cursor() method
    	 cursor = db.cursor()

         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationInitiated,ApplicationFormFilled,NoDues Certificate,apply for NoDues certificate");"""
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();
         
         #disconnect from server
    	 #db.close()
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationInitiated,ApplicationFormFilled,NoDues Certificate,apply for NoDues certificate");"""

         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();
         
           

         doc="""<h1> your nodues certificate:<br><br><br> <h1>"""
         fp=open(data.path+"/project_data/no_dues.html","r")
         fp=(fp.read());
         
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationFormPartiallyFilled,ApplicationFormPartiallyFilled,NoDues Certificate,apply for NoDues certificate");"""
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();


         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationFormPartiallyFilled,ApplicationFormFilled,NoDues Certificate,apply for NoDues certificate");"""
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();



         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationFormFilled,ApplicationFormPartiallyFilled,NoDues Certificate,apply for NoDues certificate");""" 

         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();




        
	 ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APND,ApplicationFormFilled,ApplicationFormFilled,NoDues Certificate,apply for NoDues certificate");"""

         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();

         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,"applicationForm","APND");"""%(str(Rollno)) 
  

         cursor.execute(ss)
       	 db.commit();
         ss="""select * from noDuesFormDateForm where rollNumber=%s;"""%(Rollno)
    	 cursor.execute(ss)
       	 val=cursor.fetchall()
    	 #disconnect from server
         #year=int(str(val[0][10]).split('-')[0])
         doc+=fp%(val[0][1]+" "+val[0][2]+" "+val[0][3]+" ",int(Rollno),val[0][4],)
        
         doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\" value=\"ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
	 return doc
         
     if name=="string:fees structure":
         flag=2
         db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="userInputDatabase" )
   		 # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
         tabid="ApplicationRequests"
         ss="""insert into inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,start,ApplicationInitiated,FeesStructure Certificate,apply for FeesStructure certificate");"""
        
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();


         db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="applicationProcess" )
         # prepare a cursor object using cursor() method
    	 cursor = db.cursor()

         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationInitiated,ApplicationFormFilled,FeesStructure Certificate,apply for FeesStructure certificate");"""
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();
         
         #disconnect from server
    	 #db.close()
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationInitiated,ApplicationFormFilled,FeesStructure Certificate,apply for FeesStructure certificate");"""

         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();
         
           

         doc="""<h1> your fees_structure certificate:<br><br><br> <h1>"""
         fp=open(data.path+"/project_data/fees_structure.html","r")
         fp1=open(data.path+"/project_data/feestructureformca.html","r")
         fp1=fp1.read()
         fp=(fp.read());
         
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationFormPartiallyFilled,ApplicationFormPartiallyFilled,FeesStructure Certificate,apply for FeesStructure certificate");"""
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();


         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationFormPartiallyFilled,ApplicationFormFilled,FeesStructure Certificate,apply for FeesStructure certificate");"""
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();



         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationFormFilled,ApplicationFormPartiallyFilled,FeesStructure Certificate,apply for FeesStructure certificate");""" 

         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();




        
	 ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APFS,ApplicationFormFilled,ApplicationFormFilled,FeesStructure Certificate,apply for FeesStructure certificate");"""

         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();

         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,"applicationForm","APFS");"""%(str(Rollno)) 
  

         cursor.execute(ss)
       	 db.commit();


 
         ss="""select * from applicationProcess.feesStructureForm where rollNumber=%s ;"""%(Rollno)

    	 cursor.execute(ss)
       	 val=cursor.fetchall()
    	 #disconnect from server
    	 
         if val[0][4]=='MCA':  
           doc+=fp1%(val[0][1]+" "+val[0][2]+" "+val[0][3],val[0][4],val[0][6],val[1][6],val[2][6],val[3][6],val[4][6],val[5][6],val[0][7],val[1][7],val[2][7],val[3][7],val[4][7],val[5][7],val[0][8],val[1][8],val[2][8],val[3][8],val[4][8],val[5][8],val[0][9],val[1][9],val[2][9],val[3][9],val[4][9],val[5][9])
         else:
		doc+=fp%(val[0][1]+" "+val[0][2]+" "+val[0][3],val[0][4],val[0][6],val[1][6],val[2][6],val[3][6],val[0][7],val[1][7],val[2][7],val[3][7],val[0][8],val[1][8],val[2][8],val[3][8],val[0][9],val[1][9],val[2][9],val[3][9])
         
         doc+="""<a href='http://localhost/myproject/project_data/new%20app/nn.html'> print pdf</a> <html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\" value=\"ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
	 return doc     
     if  name=="string:International student Bonafied":	
         flag=3
         db = MySQLdb.connect(
         host = "localhost",
         user=data.mysql_user,
    	 passwd=data.mysql_pswd,
         db = "userInputDatabase" )
         #prepare a curser object using cursor() method
         cursor = db.cursor()
 
         tabid="ApplicationRequests"
         ss="""insert into inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,start,ApplicationInitiated,InternationalStudent Bonafide Certificate,apply for bonafide certificate");"""
        
        
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();
 
         db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="applicationProcess" )
         # prepare a cursor object using cursor() method
    	 cursor = db.cursor()

         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationInitiated,ApplicationFormFilled,InternationalStudent Bonafide Certificate,apply for bonafide certificate");"""
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();
         #disconnect from server
    	 #db.close()
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationInitiated,ApplicationFormFilled,InternationalStudent Bonafide Certificate,apply for bonafide certificate");"""
      
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();
         
           

         doc="""<h1> your bonafide certificate:<br><br><br> <h1>"""
         fp=open(data.path+"/project_data/international_stud_bonafied.html","r")
         fp=fp.read()
       
         
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationFormPartiallyFilled,ApplicationFormPartiallyFilled,InternationalStudent Bonafide Certificate,apply for bonafide certificate");"""
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();
         

         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationFormPartiallyFilled,ApplicationFormFilled,InternationalStudent Bonafide Certificate,apply for bonafide certificate");"""
         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();



         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationFormFilled,ApplicationFormPartiallyFilled,InternationalStudent Bonafide Certificate,apply for bonafide certificate");""" 

         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();




        
	 ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,%s,"APIB,ApplicationFormFilled,ApplicationFormFilled,InternationalStudent Bonafide Certificate,apply for bonafide certificate");"""

         cursor.execute(ss,(Rollno,tabid))
       	 db.commit();
         
         ss="""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),"insert",%s,"applicationForm","APIB");"""%(str(Rollno)) 
         

         cursor.execute(ss)
       	 db.commit();
         ss = """select * from applicationProcess.interNationalBonafideApplicationForm where rollNumber=%s ;"""%(Rollno)
         cursor.execute(ss)
         val = cursor.fetchall()
         
         
         #disconnect from server
         #db.close()
         
         #year=int(str(val[0][10]).split('-')[0])

         if len(val)==0:
                ss = """select msg from userInputDatabase.outputErrorMsgs;"""
         	cursor.execute(ss)
         	val = cursor.fetchall()
                return """<h1>%s</h1>"""%(val[len(val)-1])
              
         doc+=fp%(val[0][1]+" "+val[0][2]+" "+val[0][3],val[0][1]+" "+val[0][2]+" "+val[0][3],val[0][8],val[0][9],int(val[0][10]),int(val[0][12]),int(val[0][15]),val[0][13],val[0][16],val[0][14],val[0][17],val[0][18],val[0][19],val[0][7],val[0][4],val[0][4],val[0][11]);
         doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\" value=\"ok\"><input type=\"button\" onclick=window.history.back() value=\"cancel\"></form></body></head></html>"""
         return doc


          
    

