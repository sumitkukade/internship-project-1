$( document ).ready(function() {

		$("#student-submit-button").click(function(){
				login();

		}); 
		$("#student-pin-validate-button").click(function(){
				validate_pin();
		}); 
		$("#get-student-code-button").click(function(){
				get_forget_otp();
		}); 
		$("#staff-submit-button").click(function(){
				staff_login();

		}); 
		$("#signup_pin_gen").click(function(){
				signup_pin();
		}); 
		$("#student-login-page").click(function(){
				window.location="temp/student-login.html";	
		}); 
		$("#staff-login-page").click(function(){
				window.location="temp/staff-login.html";	
		}); 
		$("#home-button").click(function(){
				window.location="../index.html";
		});
		$("#back-button").click(function(){
				window.location="../index.html";
		});
		$("#testttttttttttttttttttt").click(function(){
				alert(window.location.hostname)
		});
		$("#click-here").click(function(){
				window.location="login-successfull.html";
		});
		$("#already-have-pin-button").click(function(){
				window.location="signup.html";
		});
		$("#login-page-button").click(function(){
				window.location="student-login.html";
		});




});

function login(){
		var student_rollno = $("#student-rollno-input").val();
		var student_passwd = $("#student-password-input").val();

		var request = {};
		request["rollno"] = student_rollno;
		request["password"] = student_passwd;

		if(validate_roll_no(student_rollno) && validate_student_passwd(student_passwd)){

				$.post(
								"http://"+window.location.hostname+"/index.py/login",
								{data: JSON.stringify(request)}

					  ).done(function(response) {
						if (response == "True")
						{
								window.location="login-successfull.html";
						}
						else{
								status_msg('status-msg',response);
						}
				});

		}
		else{
				status_msg("status-msg","invalid rollno or password");
		}

}

function validate_roll_no(student_rollno)
{
		var re = /\d{5}/;
		var result = student_rollno.match(re);
		if(result == null)
		{
				return false;
		}
		else{
				return true;
		}
}

function validate_student_passwd(student_passwd)
{
		if(student_passwd.length<6)
		{
				status_msg('status-msg',"password length should be greater than 5");
				return false;
		}
		else
		{
				return true;
		}

}

function get_sha5(input_string){
		var sha5 = new jsSHA(input_string, "ASCII");
		return sha5.getHash("SHA-512", "HEX");
}
function validate_pin(){
		var student_rollno = $("#student-rollno-input").val();
		var student_pin = $("#student-pin-input").val();
		var student_pass = $("#student-password-input").val();
		var student_conf_pass = $("#student-confirm-password-input").val();
		if(student_pass != student_conf_pass)
		{
				status_msg("status-msg","password dosent match");
				return;
		}

		var request = {};
		request["roll_no"] = student_rollno;
		request["pin"] = student_pin;
		request["new_password"] = student_conf_pass;

		if(validate_roll_no(student_rollno) && validate_student_passwd(student_pass) && validate_student_pin(student_pin))
		{

				$.post(
								"http://"+window.location.hostname+"/index.py/validate_pin",
								{data: JSON.stringify(request)}

					  ).done(function(response) {
						handle_response(response);
						if(response == "new_password,success")
						{
								window.setTimeout(function(){


										window.location="student-login.html"
								}, 3000);

						}
				});

		}
		else{
				status_msg('status-msg',"invalid rollno or password");
		}

}

function validate_student_pin(pin)
{
		var re = /\d{7}/;
		var result = pin.match(re);
		if(result == null)
		{
				return false;
		}
		else{
				return true;
		}

}

function handle_response(response)
{
		result = response.split(',');
		if(result[0] == 'rollno')
		{
				if(result[1] == 'invalid')
				{
						status_msg('status-msg','invalid');
				}
		}
		else if(result[0] == 'pin')
		{
				if(result[1] == 'invalid')
						status_msg('status-msg','invalid pin');

		}
		else if(result[0] == 'new_password')
		{
				if(result[1] == 'success')
						status_msg('status-msg','New password set');
				//redirect to home page

		}

}
function status_msg(id,msg)
{
		document.getElementById(id).innerHTML = msg;
}

function forgot_password()
{
		request = {}
		var rollno = prompt("Please enter your roll no.", "");
		request["roll_no"] = rollno; 
		if (rollno != null)
		{
				if(validate_roll_no(rollno))
				{
						$.post(
										"http://"+window.location.hostname+"/index.py/forgot_password",
										{data: JSON.stringify(request)}

							  ).done(function(response) {
								if(response == "True")
								{
										window.location="forgot-password-request-generated.html"


								}
						});



				}


		}
}

function get_forget_otp(){
		var rollno = $("#student-rollno-input").val();
		var request = {};
		request["rollno"] = rollno;
		$.post(
						"http://"+window.location.hostname+"/index.py/get_student_reset_code",
						{data: JSON.stringify(request)}

			  ).done(function(response) {
				status_msg('status-msg',response);
				/*alert(response);*/
		});



}

function signup_pin(){
		request = {}
		var rollno = prompt("Please enter your roll no.", "");
		request["roll_no"] = rollno; 
		console.log(request);
		if (rollno != null)
		{
				if(validate_roll_no(rollno))
				{
						$.post(
										"http://"+window.location.hostname+"/index.py/signup_pin_generator",
										{data: JSON.stringify(request)}

							  ).done(function(response) {
								if(response == "True")
								{
										window.location="signup-pin-generated.html"

								}
								else
								{
										alert("invalid user");
								}


						});


				}
		}
}

function staff_login(){
		request = {}
		staff_username = $("#staff-input-username").val();
		staff_password = $("#staff-password-input").val();
		request["username"] = staff_username;
		request["password"] = staff_password;
		$.post(
						"http://"+window.location.hostname+"/index.py/staff_login",
						{data: JSON.stringify(request)}

			  ).done(function(response) {
				if(response == "True")
				{
						/*$.post("http://"+window.location.hostname+"/project_data/staff.py/index",{data: JSON.stringify(request)}).done(function(response){alert(response);});*/
						/**/
						window.location="staff-login-successfull.html"

				}
				else
				{
						status_msg("status-msg",response);
				}
		});
}
function get_student_pin_link()
{
		window.location="staff-getApplication-code.html"
}
