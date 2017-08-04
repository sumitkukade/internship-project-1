import os
import MySQLdb

def MyServer(req):
        req.content_type="Content-Type: application/text"
        FormData = req.form.getfirst("FormData","no form parameter")
        UserName,Password = FormData.split(" ")
        #con = sqlite3.connect("/home/pranali/Documents/2016/Task/HTML_Forms/project_data/test.db")
        conn = MySQLdb.connect(host="localhost",user="root",passwd="pranali",db="test" )
        cur = conn.cursor();
        cur.execute("""INSERT INTO login values(%s,%s)""",(UserName,Password))
        conn.commit();
        conn.close();
        return FormData
    
