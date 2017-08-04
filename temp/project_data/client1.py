from socket import *
def index():
     host='192.168.1.33'
     port=50202
     buff=5000

     sock = socket()
     try:
          sock.connect((host, port))
          message= """<html>
          <head>
          <title>Test</title></head>
          <body>
          <center><h1>Fault Tolerance Compute Service</h1></center>
          <br><br><br>
          <script src="http://code.angularjs.org/1.2.9/angular.min.js"></script>
          <style>
          .error {
          color: red;
          }
          h4 {
          color:red;
          }
          body {
          background-color: lightgrey;
          }
           .loader {
              border: 10px solid #f3f3f3; /* Light grey */
              border-top: 10px solid #3498db; /* Blue */
              border-radius: 50%;
              width: 5px;
              height: 5px;
              animation: spin 1s linear infinite;
              margin: 0 auto;
              }

              @keyframes spin {
              0% { transform: rotate(0deg); }
              100% { transform: rotate(360deg); }
              }
              html, body, container {
              height: 100%;
              width: 100%;
              margin: 0;
              }

          </style>
          <script>
          var myapp = angular.module('myApp', []);

          myapp.controller('mainCtrl', function ($scope) {
          $scope.showContent = function($fileContent){
          $scope.program=$fileContent;
          };
          $scope.clientId = /^[a-zA-Z ]{2,30}[0-9]*$/;
          $scope.ShowSpinnerStatus = false;

          $scope.ShowSpinner = function(){
          $scope.ShowSpinnerStatus = true;
          };
          $scope.HideSpinner = function(){
          $scope.ShowSpinnerStatus = false;
          };

          });
          
          myapp.directive('onReadFile', function ($parse) {
          return {
          restrict: 'A',
          scope: false,
          link: function(scope, element, attrs) {
          var fn = $parse(attrs.onReadFile);
          
          element.on('change', function(onChangeEvent) {
          var reader = new FileReader();
          
          reader.onload = function(onLoadEvent) {
          scope.$apply(function() {
          fn(scope, {$fileContent:onLoadEvent.target.result});
          });
          };

          reader.readAsText((onChangeEvent.srcElement || onChangeEvent.target).files[0]);
          });
          }
          };
          });

          </script>
          </head>
          <body ng-app="myApp">
          <form name="myForm" ng-controller="mainCtrl"  action="/server0/client1.py/getinfo" method="post">
          <div>Enter your client Id. :</div>
          <div>
          <input type="text" placeholder="Client Id" name="clientid" ng-pattern="clientId" ng-model="clientid" required/>
          <span class="error" ng-show="myForm.clientid.$error.required">Required!</span>
          <br><span class="error" ng-show="myForm.clientid.$error.pattern">Please enter valid clientId</span>
          </div><br>"""
          data="ProblemNoWithDescription"
          sock.send(data)
          ack=sock.recv(buff)
          if ack=="No problems":
               message1="""<h4>No Problems </h4>"""
               message=message+message1
          else:
               message1="""<table border=1><tr><th>Problemid</th><th>problemtext</th></tr>"""
               message=message+message1
               ack1=ack.split("$")
               length=len(ack1)-1
               for i in range(length):
                    ack2=ack1[i].split(",")
                    problemid=ack2[0]
                    problemtext=ack2[1]
                    message1="""<tr><td>"""+problemid+"""</td><td>"""+problemtext+"""</td></tr>"""
                    message=message+message1
          
               message1="""</table><br><br>"""
               message=message+message1
          data="selectProblemNo"
          sock.send(data)
          ack=sock.recv(buff)
          if ack=="No Problems":
               message1="""<h4>No Problems </h4>"""
               message=message+message1
               print "No Problems in problem table"
          else:
               ack=ack.split(',')
               print ack
               length=len(ack)-1
               print length
               message1="""<h4>Select Problem:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="problemid">"""
               message=message+message1
               for i in range(length):
                    print "ack[",i,"]=",ack[i]
                    message1="""<option>"""+ack[i]+"""</option>"""
                    message=message+message1
               message1="""</select></h4><br><br>"""
               message=message+message1

          data="selectLanguage"
          sock.send(data)
          ack=sock.recv(buff)
          if ack=="No Language":
               message1="""<h4>No Language </h4>"""
               message=message+message1
               print "No languages available in languagetable"
          else:
               ack=ack.split(',')
               print ack
               length=len(ack)-1
               print length
               message1="""<h4>Select Language:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="languageno">"""
               message=message+message1
               for i in range(length):
                    print ack[i]
                    message1="""<option>"""+ack[i]+"""</option>"""
                    message=message+message1
               message1="""</select><br><br><br><br><h4>"""
               message=message+message1
               message1="""<center><h3>Write your program below:</h3><br><br></center><center><textarea name="program" ng-model="program" rows="30" cols="80" required></textarea ><span class="error" ng-show="myForm.program.$error.required">Required!</span><br><br>
               <input type="file" on-read-file="showContent($fileContent)" />"""
               message=message+message1
               message1="""<input type="submit" value="submit" class="btn" ng-click="ShowSpinner()" ng-disabled = "myForm.$invalid">
               <input type="reset" value="reset" class="btn" ng-click="HideSpinner()">
               <div ng-if="ShowSpinnerStatus" class="loader"></div>
                &nbsp&nbsp&nbsp
               <a href="/server0/get-status-of-program.py"><input type="button" name="getStatus" value="Get Status"></a></center><br><br>"""
               message=message+message1
               message1="""</form></body></html>"""
               message=message+message1
               return message
               sock.close()
     except:
          message1="""<html><head><title>Acknowlegement</title></head><body><form>"""
          message2="""<h4>"""+"Server1 is not running"+"""</h4>"""
          message3="""<a href="/server0/client1.py"><input type="button" name="back" value="Back"></a>&nbsp&nbsp&nbsp
          <a href="/server0/get-status-of-program.py"><input type="button" name="getStatus" value="Get Status"></a><br><br>
          </form></body></html>"""
          message=message1+message2+message3
          return message
          
def getinfo(req):
     info=req.form
     clientid=info['clientid']
     problemid=info['problemid']
     languageno=info['languageno']
     program=info['program']
     data="SubmitProgram"+"$"+clientid+"$"+problemid+"$"+languageno+"$"+program+"$"
     host='192.168.1.33'
     port=60100
     buff=5000
    
     addr=(host,port)
     sock = socket()
     try:
          sock.connect(addr)
          sock.send(data)
          ack1=sock.recv(buff)
          data1=ack1.split("$")
          if data1[0]=="Ack":
               message1="""<html><head><title>Acknowlegement</title></head><body><form>"""
               message2="""<h4>"""+data1[1]+"""</h4>"""
               message3="""<a href="/server0/client1.py"><input type="button" name="back" value="Back"></a>&nbsp&nbsp&nbsp
               <a href="/server0/get-status-of-program.py"><input type="button" name="getStatus" value="Get Status"></a><br><br>
               </form></body></html>"""
               message=message1+message2+message3
               return message
     except:
          message1="""<html><head><title>Acknowlegement</title></head><body><form>"""
          message2="""<h4>"""+"Server0 is not running"+"""</h4>"""
          message3="""<a href="/server0/client1.py"><input type="button" name="back" value="Back"></a>&nbsp&nbsp&nbsp
          <a href="/server0/get-status-of-program.py"><input type="button" name="getStatus" value="Get Status"></a><br><br>
          </form></body></html>"""
          message=message1+message2+message3
          return message
          
