import MySQLdb
import datetime;
import imp

f = open('/var/www/html/temp/project_data/config.txt')
global data
data = imp.load_source('data', '', f)
