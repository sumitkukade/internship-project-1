import MySQLdb as db
import json
from random import randint
from passlib.apache import HtpasswdFile
import os.path
import os

def add_user(username,password):
		cwd = os.path.abspath(__file__)[:-8]
		if os.path.exists(cwd+"pucsd.htpasswd") == False:
				ht = HtpasswdFile(cwd+"pucsd.htpasswd", new=True)
				result = ht.set_password(username, password)
				ht.save()
				return result
		else:
				ht = HtpasswdFile(cwd+"pucsd.htpasswd")
				resule = ht.set_password(username, password)
				ht.save()
				if result == False:
						return True

def check_user_password_htpasswd(username,password):
		cwd = os.path.abspath(__file__)[:-8]
		ht = HtpasswdFile(cwd+"pucsd.htpasswd")
		return ht.check_password(username, password)


def get_db_connection(database_name):
		database = db.connect('localhost','root','S',database_name)
		return database, database.cursor()

def login(data):
		data_dict = json.loads(data)
		roll_no = data_dict["rollno"]
		password = data_dict["password"]
		query = "select password from userPassword where userId = '"+roll_no+"';"
		result = perform_sql_action("applicationProcess",query,'select')
		if result == ():
				return "roll no. doesn't exist..! please signup to continue"
		elif True:# result[0][0] == password:
				if check_user_password_htpasswd(roll_no,password):
						return "True"
				else:
						return "invalid password"

		else:
				return "invalid password"


def validate_pin(data):
		data_dict = json.loads(data)
		pin = data_dict["pin"]
		roll_no = data_dict["roll_no"]
		new_pass = data_dict["new_password"]
		query = "SELECT userId FROM userIdDomain WHERE userId = '"+ roll_no +"';"
		result = perform_sql_action("applicationProcess",query,'select')
		if len(result) == 1:
				if is_valid_pin(data):
						add_user(roll_no,new_pass)
						query = "insert into userPassword (userId,password) values ('"+roll_no+"','"+new_pass+"') ON DUPLICATE KEY UPDATE password='"+new_pass+"';"
						ret = perform_sql_action("applicationProcess",query, 'insert')
						return "new_password,success"
				else:
						return "pin,invalid," + pin
		else:
				return "rollno,invalid," + roll_no

def perform_sql_action(database_name,query, action):
		try:
				db_con, db_cur = get_db_connection(database_name)
				db_cur.execute(query)
				if(action == 'select'):
						result = db_cur.fetchall()
						db_cur.close()
						return result
				else:
						db_con.commit()
						db_con.close()
		except Exception as e:
				return "DatabaseError, "+str(e)




def is_valid_pin(data):
		data_dict = json.loads(data);
		roll_no  = data_dict["roll_no"]
		pin = data_dict["pin"];
		query = "select applicationCode from applicationProcess.applicationCodeBySystem where userId = '" + roll_no +"';"
		result = perform_sql_action("applicationProcess",query,"select")
		if result[0][0] == pin:
				return True
		else:
				return False


def forgot_password(data):
		data_dict = json.loads(data)
		roll_no = data_dict["roll_no"]
		random_number = str(randint(1000000, 9999999))
		query = "insert into inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),'insert','"+roll_no +"','applicationCodeBySystem', '"+ random_number+"')"
		result = perform_sql_action("userInputDatabase",query,"insert");
		return "True"


def get_student_reset_code(data):
		data_dict = json.loads(data)
		roll_no = data_dict["rollno"]
		query = "select applicationCode from applicationProcess.applicationCodeBySystem where userId = '" + roll_no + "';"
		result = perform_sql_action("applicationProcess",query,"select")
		if result == ():
				return "user is not registerd"
		return "reset pin is "+ str(result[0][0])

def signup_pin_generator(data):
		data_dict = json.loads(data)
		roll_no = data_dict["roll_no"]
		return roll_no;
		random_number = str(randint(1000000, 9999999))
		query = "select '"+ roll_no +"' in (select userId from applicationProcess.userIdDomain where userId = '"+ roll_no +"');"
		result = perform_sql_action("applicationProcess",query,"select");
		if int(result[0][0]) == 1:
				query = "insert into inputRequests(requestTime,requestType,userId,tableId,params) values (NOW(),'insert','"+roll_no +"','applicationCodeBySystem', '" + random_number +"')"
				result = perform_sql_action("userInputDatabase",query,"insert");
				return "True"
		else:
				return "False"

def staff_login(data):
		data_dict = json.loads(data)
		staff_username = data_dict["username"]
		staff_password = data_dict["password"]
		query = "select userId from applicationProcess.userPassword where userId = '"+staff_username+"'";
		result = perform_sql_action("applicationProcess",query,"select");
		if result[0][0] == staff_username:
				query = "select password from applicationProcess.userPassword where userId = '"+staff_username+"'";
				result = perform_sql_action("applicationProcess",query,"select");
				if result[0][0] == staff_password:
						return "True"
				else:
						return "False"
		else:
				return "False"

def abc():
		cwd = os.path.abspath(__file__)[:-8]
		try:
				x = open(cwd+"q/rtyyyyyyyyyyyyyyyy","w+")
				x.write("qwerfdvcs")
		except Exception as e:
				return e
