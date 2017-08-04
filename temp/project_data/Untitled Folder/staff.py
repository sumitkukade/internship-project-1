import MySQLdb
from config_path import data
from mod_python import Session
def okfun(req):

   
   info=req.form
   rolno=info['rono']
   docm=info['docm']
   stt=info['sopt']
   return docm
   cursor.execute("""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values(NOW(),"insert","staff1-%s","applicationRequestByStaff","APBN,%s,RequestArrivedInOffice,%s");
;""");   
   val=cursor.fetchall()
   val=map(lambda x:x,val)

   
def index(req):
    info=req.form;
    session = Session.Session(req)
    info = req.form
    sname=info['number']	
    session['rno']=sname
    session.save()
    session.cleanup()
    #rollno=info['number']
    #req.content_type="text/html";
    #req.write("name="+rollno)
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
    
    #table="""create table StudentStatusnew (RollNo int,Document varchar(50),Status varchar(50));""";
    #cursor.execute(table);
    
    ss="""select appDesc from applicationProcess.applicationDomain """
    cursor.execute(ss);
    val=cursor.fetchall()
    appname=map(lambda x:x[0],val) 



    
    cursor.execute("""select  appId  from  applicationProcess.applicationDomain ;""");   
    appid=cursor.fetchall()
    appid=map(lambda x:x[0],appid)
   


      
    cursor.execute("""select  userId,remark from  applicationProcess.requestStateTransitions where toState= 'ApplicationSubmitted';""");   
    val=cursor.fetchall()
    val=map(lambda x:x,val)
    newA=val
    result=[]
    appl=['bonafide Application','Fees Structure Application','international bonafide application','No Dues Application']
    

    arrayid=["bonafide Application,apply for bonafide Application","Fees Structure Application,apply for Fees Structure Application","International bonafide Application,apply for International bonafide Application","No Dues Application,apply for No Dues Application"]

    cursor.execute("""select  userId,remark from  applicationProcess.requestStateTransitions where toState= 'RequestArrivedInOffice';""");   
    rval=cursor.fetchall()
    rval=map(lambda x:x,rval)

    
	
    for i,j in val[(len(rval)):]:
	     cursor.execute("""insert into userInputDatabase.inputRequests(requestTime,requestType,userId,tableId,params) values(NOW(),"insert","staff1-"%s,"applicationRequestByStaff",%s",ApplicationSubmitted,RequestArrivedInOffice,"%s);
;""",(sname,appid[appl.index(j)],arrayid[appl.index(j)]));   
   
    
    db.commit()


    for i in range(0,len(newA)):
      
      ss="""select  * from  applicationProcess.requestStateTransitions where userId=%s and remark=%s order by requestId desc limit 1 ;"""
      cursor.execute(ss,(str(val[i][0]),str(val[i][1])));
      val1=cursor.fetchall()
      val1=map(lambda x:x,val1[0])
      result.append(val1)
    d=6;
    for i in range(len(rval),len(result)):
             
             ss="""insert into StudentStatusnew values(%s,%s,%s,%s)"""
             cursor.execute(ss,(result[i][3],'',str(result[i][5]),"RequestArrivedInOffice")); 
             db.commit();
    
    
    fp1=open(data.path+"/project_data/json.txt","w");
    fp1.write("[");
    
    cursor.execute(""" select * from StudentStatusnew;""");
    val=cursor.fetchall()
    names = list(map(lambda x: x[0], cursor.description))  
    
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

     
    fp2=open(data.path+"/project_data/json1.txt","w");
    fp2.write("[");
    
    for n in range(0,len(names)):
                fp2.write("{");
                if n==len(names)-1:
                    fp2.write("count:0}");	
		else:	
		 fp2.write("count:0},");	

    fp2.write("]");
  

    
    crp=open(data.path+"/project_data/sample.html","r");
    crpn+=crp.read()
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




      
    crpn+="<button type=\"button\" onclick=\"printJS(\'./student.html\')\">Print PDF</button><br></br>"
    
    for i in names:
	 
		crpn+="<label style=\"padding-left:40px;\">%s<label>"%(i)
    crpn+="<br>"
    for i in names:
	crpn+="<input ng-model=\"ch.%s\" style=\"width:120px;\">"%(i) 
    crpn+="<table border=1>"

    for i in names:
      crpn+="<th style=\"width:80px;\">%s</th>"%(i)    
    crpn+="<tr ng-repeat=\"chrp in chiarperson|filter:ch|filter:fname\">"
    lnt=len(names);



    ll	="""select Status from mysql.StudentStatusnew;"""
    cursor.execute(ll)
    aps=cursor.fetchall()
    aps=map(lambda x:x[0],aps);

    cnt=0;
    for n in range(0,lnt):
      crpn+="<td>{{chrp.%s}}</td>"%(names[n]);
      	
      if('status' in names[n]):
         
    	crpn+="<td ng-if=\"chrp.%s==\'ApplicationInitiated\' ||  chrp.%s==\'ApplicationFormPartiallyFilled\' || chrp.%s==\'ApplictionFormFilled\'\" ng-init=\"ststs1=[\'ApplicationFormPartiallyFilled\',\'ApplictionFormFilled\']\">"%(names[n],names[n],names[n])                        
    	crpn+="{{stats1}}<select  ng-model=\"stats1\" ng-options=\"op for op in ststs1\"> </select><input type=\"button\" value=\"ok\"></td>"
	
				
    	crpn+="<td ng-if=\"chrp.%s ==\'ApplictionRejectedByOffice\'\" ng-init=\"ststs2=[\'RequestFisnishedWithError\']\">"%(names[n])                        
    	crpn+="{{stats2}}<select  ng-model=\"stats2\" ng-options=\"op for op in ststs2\"> </select><input type=\"button\" value=\"ok\"></td>"







	
	crpn+="<td  ng-if=\"chrp.%s ==\'ApplicationSubmitted\'\" ng-init=\"ststs3=[\'RequestArrivedInOffice\']\">"%(names[n])                        
    	crpn+="</form><html><head><body><form value=\"form\" action=\"staff.py/okfun\" method=\"post\"><input type=hidden name=\"rono\" value={{chrp.RollNo}}><input type=hidden name=\"docm\" value={{chrp.Document}}></lable><select  name=\"sopt\" ng-model=\"stats3\" name=''ng-options=\"op for op in ststs3\"> </select>"
        
        fp=open(data.path+"/project_data/nn.html")
        crpn+=fp.read();
        crpn+="</td>"  




                
        crpn+="<td ng-if=\"chrp.%s ==\'FormPrinted\'\" ng-init=\"ststs4=[\'ApplictionRejectedByOffice \',\'FormSigned\']\">"%(names[n])                        
    	crpn+="{{stats4}}<select  ng-model=\"stats4\" ng-options=\"op for op in ststs4\"> </select> <input type=\"button\" value=\"ok\"></td>"
        

        crpn+="<td ng-if=\"chrp.%s ==\'FormSigned\'\" ng-init=\"ststs5=[\'ApplictionRejectedByOffice\',\'SignedFormArrivedInOffice \']\">"%(names[n])                        
    	crpn+="{{stats5}}<select  ng-model=\"stats5\" ng-options=\"op for op in ststs5\"> </select><input type=\"button\" value=\"ok\"></td>"
        

        crpn+="<td ng-if=\"chrp.%s ==\'CertificateCollectedByStudent\'\" ng-init=\"ststs6=[\'RequestFinishedSuccessfully\']\">"%(names[n])                        
    	crpn+="{{stats6}}<select  ng-model=\"stats6\" ng-options=\"op for op in ststs6\"> </select><input type=\"button\" value=\"ok\"></td>"
        



        crpn+="<td ng-if=\"chrp.%s ==\'RequestArrivedInOffice\'\" ng-init=\"ststs7=[\'ApplictionRejectedByOffice\',\'FormPrinted \']\">"%(names[n])                        
    	crpn+="</form><html><head><body><form value=\"form\" action=\"staff.py/okfun\" method=\"post\"><input type=hidden name=\"rono\" value={{chrp.RollNo}}><input type=hidden name=\"docm\" value={{chrp.Document}}></lable><select  name='sopt' ng-model=\"stats7\" ng-options=\"op for op in ststs7\">"
        fp=open(data.path+"/project_data/nn.html")
        crpn+=fp.read();
        crpn+="</td>"  
        






        crpn+="<td ng-if=\"chrp.%s ==\'RequestFinishedSuccessfully\' || chrp.%s ==\'RequestFisnishedWithError\' \" ng-init=\"ststs8=[\'Finish \']\">"%(names[n],names[n])                        
    	crpn+="{{stats8}}<select  ng-model=\"stats8\" ng-options=\"op for op in ststs8\"> </select><input type=\"button\" value=\"ok\"></td>"

        crpn+="<td ng-if=\"chrp.%s ==\'SignedFormArrivedInOffice\'\" ng-init=\"ststs9=[\' ApplictionRejectedByOffice \',\' CertificateCollectedByStudent\']\">"%(names[n])                        
    	crpn+="{{stats9}}<select  ng-model=\"stats9\" ng-options=\"op for op in ststs9\"> </select><input type=\"button\" value=\"ok\"></td>"
        

        crpn+="<td ng-if=\"chrp.%s ==\'Start\' \" ng-init=\"ststs0=[\'  ApplicationInitiated \']\">"%(names[n])                        
    	crpn+="{{stats0}}<select  ng-model=\"stats0\" ng-options=\"op for op in ststs0\"> </select><input type=\"button\" value=\"ok\"></td>"
        
    #crpn+="<td>{{stats}}<td>"
     
    return """<html>%s</html>"""%(crpn)
