import MySQLdb
import pdfkit
from datetime import date
from config_path import data


db = MySQLdb.connect(
host="localhost",
user=data.mysql_user,
passwd=data.mysql_pswd,
db="applicationProcess" )
# prepare a cursor object using cursor() method
cursor = db.cursor()

ss = """select * from studentActionDomain;"""
cursor.execute(ss)
studAct = cursor.fetchall()
studAct=map(lambda x : x,studAct)
print studAct
ss = """select appId from applicationDomain;"""
cursor.execute(ss)
appId = cursor.fetchall()
appId = map(lambda x : x[0],appId)
print appId
ss = """select appDesc from applicationDomain;"""
cursor.execute(ss)
appdesc = cursor.fetchall()
appdesc = map(lambda x : x[0],appdesc)
print appdesc

