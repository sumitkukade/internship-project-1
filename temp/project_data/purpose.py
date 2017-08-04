import MySQLdb
import datetime;
from mod_python import Session
from config_path import data

def index():
    fp =open(data.path+"/project_data/purpose.html")
    fp=fp.read()
    return """<html>%s</html>"""%(fp)
