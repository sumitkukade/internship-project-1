import MySQLdb
from mod_python import Session
from config_path import data
def index(req):
    
    
    session = Session.Session(req)
    info = req.form
    rollno=info['number']	
    session['rno']=rollno
    session.save()
    session.cleanup()
    req.content_type = 'text/html'
    req.write('rollno: %s\n' % session['rno'])
    crpn=""
    db = MySQLdb.connect(
    host="localhost",
    user=data.mysql_user,
    passwd=data.mysql_pswd,
    db="mysql" )
    # prepare a cursor object using cursor() method
    cursor = db.cursor()
    # prepare a cursor object using cursor() method
    cursor = db.cursor()
  
    query="""DROP TABLE IF EXISTS StudentStatus;""";
    cursor.execute(query);
    table="""create table StudentStatus (RollNo int,Document varchar(50),StatusFrom varchar(50),StatusTo varchar(50));""";
    cursor.execute(table);
   
    ss="""select appDesc from applicationProcess.applicationDomain """
    cursor.execute(ss);
    val=cursor.fetchall()
    appname=map(lambda x:x[0],val)
    
    
    ss="""select appId from applicationProcess.applicationDomain """
    cursor.execute(ss);
    val=cursor.fetchall()
    appid=map(lambda x:x[0],val)
    
    
    appl=['Bonafide Certificate','Fee Structure Certificate For Bank','international bonafide application','No Dues Certificate']

   
    for i in range(0,len(appid)):
       ss="""select params from applicationProcess.requestStateTransitions where userId=%s and params like %s"""
       cursor.execute(ss,(rollno,appid[i]+'%'));
       val=cursor.fetchall()
       
       if len(val)!=0:  
                stsfm=str(val[len(val)-1]).split(',')[1]
                ststo=str(val[len(val)-1]).split(',')[2]
               
                if ststo=='ApplicationSubmitted':
                              	
                         
                              ss="""select fromState,toState from applicationProcess.aux_studentAndState where rollNumber=%s and appId=%s   order by requestId desc limit 1 ;"""
                              cursor.execute(ss,(rollno,appid[i]));   
                              re=cursor.fetchall()
                              re=map(lambda x:x,re)
                              
                              if len(re)!=0:
                   
                                      ss="""insert into StudentStatus values(%s,%s,%s,%s)"""
                                      cursor.execute(ss,(rollno,appname[i],str(re[0][0]),re[0][1]))
                                      db.commit();
                                
                else:
                
                  ss="""insert into StudentStatus values(%s,%s,%s,%s)"""
                  cursor.execute(ss,(rollno,appname[i],stsfm,ststo));

       db.commit();
          
    cursor.execute(""" select * from applicationProcess.applicationForm;""");
    val=cursor.fetchall()
  
    
    cursor.execute(""" select * from StudentStatus;""");
    val=cursor.fetchall()
            

    names = list(map(lambda x: x[0], cursor.description))
    db.close() 
    fp1=open(data.path+"/project_data/json.txt","w");
    fp1.write("[");
    for i in range(0,len(val)):
        fp1.write("{");
    	for n in range(0,len(names)):
		fp1.write("\""+str(names[n])+"\":");
		if str(val[i][n]).isdigit():
                	fp1.write(str(val[i][n]));
		else:
	                fp1.write("\""+str(val[i][n])+"\"");
		
		if not n==len(names)-1:
		  fp1.write(",\n");
	if not i==len(val)-1:
        	fp1.write("},\n");
	else:
		fp1.write("}	\n");
		

    fp1.write("]");
   
     
    #crp=open(data.path+"/project_data/sample.html","r");
    #crpn+=crp.read()
    db = MySQLdb.connect(
    host="localhost",
    user=data.mysql_user,
    passwd=data.mysql_pswd,
    db="userInputDatabase" )
    # prepare a cursor object using cursor() method
    cursor = db.cursor()
    ss="""select output from outputResults;"""
    cursor.execute(ss)
    apsts=cursor.fetchall()
    req.content_type="text/html"
    
    db = MySQLdb.connect(
    host="localhost",
    user=data.mysql_user,
    passwd=data.mysql_pswd,
    db="mysql" )
    db.close()
    crpn=open(data.path+"/project_data/student.html","r");
    crpn=crpn.read()
    for i in names:
		crpn+=" <label style=\"padding-left:40px;\">%s<label>"%(i)
    crpn+="<br>"
    for i in names:
	crpn+="<input ng-model=\"ch.%s\" style=\"width:120px;\">"%(i) 
    crpn+="<table border=1>"
    
    for i in names:
      crpn+="<th style=\"width:80px;\">%s </th>"%(i)    
    crpn+="<tr ng-repeat=\"chrp in chiarperson|filter:ch|filter:statuspa|filter:fname\">"
    
    lnt=len(names);
    for n in range(0,len(names)):
                               	 crpn+="<td>{{chrp.%s}}</td>"%(names[n]);
    
    return """<html>%s</html>"""%(crpn)
