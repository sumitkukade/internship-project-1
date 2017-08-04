import MySQLdb
from config_path import data
def index():
         info=req.form;
         RollNo=info['rono'];	
       
         doc='';
         db = MySQLdb.connect(
    	 host="localhost",
    	 user=data.mysql_user,
    	 passwd=data.mysql_pswd,
    	 db="userInputDatabase")
   	 # prepare a cursor object using cursor() method
    	 cursor = db.cursor()
          

         fp=open(data.path+"/project_data/bonafied.html","r")
         fp=(fp.read())



	 ss="""select * from applicationProcess.bonafideApplicationForm where rollNumber=%s;"""%(Rollno)
    	 cursor.execute(ss)
       	 val=cursor.fetchall()
         return val

    	 year=int(str(val[0][10]).split('-')[0])
         doc+=fp%(val[0][1]+" "+val[0][2]+" "+val[0][3],int(val[0][0]),val[0][4],val[0][5],year,year+1,val[0][6],val[0][7],val[0][8],val[0][9]);
         doc+="""<html><head><body><form value="form" action="print_Application" method="post"><input type=\"submit\" value=\"Ok\"><input type=\"button\"  onclick=window.history.back() value=\"Cancel\"></form></body></head></html>"""
         return doc
