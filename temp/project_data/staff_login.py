from config_path import data
def index():
    fp=open(data.path+"/project_data/staff_log.html","r");
    st=fp.read();
    return st;
