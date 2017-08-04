import MySQLdb
import pdfkit
from datetime import date
from mod_python import Session
from config_path import data

def validate():
        db = MySQLdb.connect(
        host="localhost",
        user=data.mysql_user,
        passwd=data.mysql_pswd,
        db="userInputDatabase" )
             # prepare a cursor object using cursor() method
        cursor = db.cursor()
        ss = """select msg from outputErrorMsgs where requestId=(select requestId from inputRequests order by requestId desc limit 1);"""
        cursor.execute(ss)
        val = cursor.fetchall()
        return val
        if len(val)!=0:
            return (val[len(val)-1])
