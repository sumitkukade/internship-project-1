import os
import MySQLdb

def MyServer(req):
        req.content_type="Content-Type: application/text"
        FormData = req.form.getfirst("FormData","no form parameter")
        Purpose = FormData.split(" ")
        return FormData
    
