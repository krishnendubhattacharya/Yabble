
	          $(document).ready(function(){ 
		   if (navigator.geolocation) {
                        navigator.geolocation.getCurrentPosition(showPosition);
                    } else { 
                        x.innerHTML = "Geolocation is not supported by this browser.";
                    }
                 });
                 function showPosition(position) {
                    $('#ulatitude').val(position.coords.latitude); 
                    $('#ulongitude').val(position.coords.longitude);	
                 }
	          function check_validate()
	          {
	            
	            var email=$('#username').val();
	            var password=$('#password').val();
	            if(email=='')
	            {
	              $('#emailerr').html('<font color="red">Please enter your email</font>');
	            }
	            else
	            {
	              $('#emailerr').html('');
	            }
	            if(password=='')
	            {
	              $('#passworderr').html('<font color="red">Please enter your password</font>');
	            }
	            else
	            {
	              $('#passworderr').html('');
	            }
	            if(email!='' && password!='')
	            {
	              var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	              if(!regex.test(email)) {
                        $('#emailerr').html("<font color='#ff0000'>Please enter valid email</font>");
                        return false;
                      }
                      else
                      {
                          $('#emailerr').html('');
                          return true;
                      }
	            }
	            else
	            {
	              return false;
	            }
	          }
	       