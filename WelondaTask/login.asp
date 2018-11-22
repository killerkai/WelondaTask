<!DOCTYPE html>
<html lang="no">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-touch-fullscreen" content="yes" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="format-detection" content="date=no" />
    <meta name="format-detection" content="address=no" />
    <meta name="format-detection" content="email=no" />
    <meta name="description" content="" />
    <meta name="keywords" content="" />
    <title></title>
    <link rel="stylesheet" href="//cdn.web2net.no/lib-1.0.0/css/az-1.0.0.min.css" />
    <script src="//cdn.web2net.no/lib-1.0.0/js/az-1.0.0.min.js"></script>
    <link href="lib/standard.css" rel="stylesheet" />
    <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon" />
    <script src="lib/functionlib.js"></script>
    <script src="lib/lang-val/default.js"></script>
    <script>
    LanguagePage = "lib/lang-val/signin/signin-lang.json";        
    $(document).ready(function ()
        {
            getContentData();
        });

        function getContentData()
        {
            initializePage(
            {
                setLanguageClientStorage: true,
                getLanguage: true                
            }, function ()
            {
                setContentInfo();
            });
        }
        function setContentInfo()
        {            $("#cmdSignIn").click(function(){submitlogginn();});
            $("#cmdSendEmail").click(function(){submitsendemail();});
            $("#cmdForgotPassword").off().on('click', function ()
                {
                    $("#ForgotPassword").show();
                    $("#SignIn").hide();
                    $("#signinInfo").text(SingleElements.emailDefaultMessage);
                });
            $("#cmdBackToSigin").off().on('click', function ()
                {
                    $("#ForgotPassword").hide();
                    $("#SignIn").show();
                    $("#signinInfo").text(SingleElements.signinDefaultMessage);
                });
             var _HTML = "";
            $("#frmSignIn").off('keypress').on('keypress', function (e)
            {
                if ((e.keyCode || e.which) == 13)
                {
                    validateSignIn();
                    return false;
                }
            });            
            $.each(MyDefaultLanguage.ActiveLanguages, function (Key, Value)
            {
                _HTML += "<li><a href=\"javascript:void(0);\" onclick=\"changeLanguage('" + Value[0] + "')\">" + Value[1] + "</a></li>"
            });
            $("#ul_language").html(_HTML);            
            $("#AppName").text(AppName);
            $(".AppVersion").text(SingleNonLanguageElements.labelAppVersion + " " + AppVersion);
            //formdirty = false;
            $("#ForgotPassword").hide();
            hideCoverSpin();           }        function changeLanguage(SelectedLanguage)
        {
            ThisLanguage = SelectedLanguage;
            setLanguage();
            $("#AppVersion").text(SingleNonLanguageElements.labelAppVersion + " " + AppVersion);
            clientStorage("set", "language", ThisLanguage);
        }
        function submitsendemail()        {        showCoverSpin();
	 	    var output = "email=" + $('#Email').val();     	
		    $.ajaxSetup({cache: false});
		    $.ajax(
		    {
			    type: "POST",
			    url: "api/forgotpassword.asp",						
		        data: output,
		        dataType: 'json',					   
		        async: true,
		        cache: false,
		        timeout: 100000,
			    error: function()
			    {						
                    $("#signinInfo").text("Error1, Noe gikk galt, prøv igjen.");				
			    },
			    success: function(responseText)			
			    {
                if (responseText.Transfer == "noemailreg")
			    { 
                    hideCoverSpin();
                    $("#signinInfo").text(SingleElements.noEmailReg).removeClass('az-alert-info').addClass('az-alert-danger').show();
                    window.setTimeout(function ()
                    {
                        $("#signinInfo").text(SingleElements.emailDefaultMessage).removeClass('az-alert-danger').addClass('az-alert-info').show();
                    }, 3000);                 
                    	
			    }
                if (responseText.Transfer == "emptystring")
			    { 
                    hideCoverSpin();
                    $("#signinInfo").text(SingleElements.emailSubmitError).removeClass('az-alert-info').addClass('az-alert-danger').show();
                    window.setTimeout(function ()
                    {
                        $("#signinInfo").text(SingleElements.emailDefaultMessage).removeClass('az-alert-danger').addClass('az-alert-info').show();
                    }, 3000);                 
                    	
			    }
                if (responseText.Transfer == "ok")
			    {                     
                    $("#Email").val("");
                    $("#signinInfo").text(SingleElements.emailSendt); 
                    window.setTimeout(function ()
                    {
                       hideCoverSpin();                               
                    }, 1000);
                    
			    }            }         });        }
        function submitlogginn()
        {               showCoverSpin();
	 	    var output = "brukernavn=" + $('#Username').val() + "&passord=" + $('#Password').val();     	
		    $.ajaxSetup({cache: false});
		    $.ajax(
		    {
			    type: "POST",
			    url: "api/logginn.asp",						
		        data: output,
		        dataType: 'json',					   
		        async: true,
		        cache: false,
		        timeout: 100000,
			    error: function()
			    {						
                    $("#signinInfo").text("Error1, Noe gikk galt, prøv igjen.");				
			    },
			    success: function(responseText)			
			    {
                if (responseText.Transfer == "feilnousernamepassword")
			    { 
                    hideCoverSpin();
                    $("#signinInfo").text(SingleElements.signinDefaultMessage).removeClass('az-alert-info').addClass('az-alert-danger').show();
                    window.setTimeout(function ()
                    {
                        $("#signinInfo").text(SingleElements.signinDefaultMessage).removeClass('az-alert-danger').addClass('az-alert-info').show();
                    }, 3000);	
			    }
                if (responseText.Transfer == "feilnopassword")
			    { 
                    hideCoverSpin();
                    $("#signinInfo").text(SingleElements.PasswordSubmitError).removeClass('az-alert-info').addClass('az-alert-danger').show();
                    window.setTimeout(function ()
                    {
                        $("#signinInfo").text(SingleElements.signinDefaultMessage).removeClass('az-alert-danger').addClass('az-alert-info').show();
                    }, 3000);	
			    }
			    if (responseText.Transfer == "feilnousername")
			    { 
                    hideCoverSpin();
                    $("#signinInfo").text(SingleElements.UsernameSubmitError).removeClass('az-alert-info').addClass('az-alert-danger').show();
                    window.setTimeout(function ()
                    {
                        $("#signinInfo").text(SingleElements.signinDefaultMessage).removeClass('az-alert-danger').addClass('az-alert-info').show();
                    }, 3000);	
			    }
			    if (responseText.Transfer == "feilbrukerpass")
			    {	
                hideCoverSpin();
                $("#signinInfo").text(SingleElements.signinErrorWrongUsernamePasswordDeactivated).removeClass('az-alert-info').addClass('az-alert-danger').show();
                window.setTimeout(function ()
                {
                    $("#signinInfo").text(SingleElements.signinDefaultMessage).removeClass('az-alert-danger').addClass('az-alert-info').show();
                }, 3000);						
			    }
			    if (responseText.Transfer == "ok")
			    {
			    showCoverSpin();
			    localStorage.bruker = "ok"; 
			    localStorage.fornavn = responseText.fornavn;
			    localStorage.etternavn = responseText.etternavn;
			    localStorage.status = responseText.status;
			    localStorage.brukertype = responseText.brukertype;
			    localStorage.brukerid = responseText.brukerid;
			    localStorage.userName = responseText.brukernavn;
			    localStorage.epostvarsel = responseText.epostvarsel;
			    setTimeout(function ()
			    {			
			    window.location.href = "default.asp";
			    }, 1000);	
			    }	
		    }
	    }); 
}
       
    </script>
    <style>
        body{
            background-image: url("img/bio.jpg");
            height: 500px;
            background-repeat: no-repeat, repeat;
            background-size: cover;            
        }
        .az-container-signin {            
            position: relative;
            margin-left: auto;
            margin-right: auto;
            width: 88%;
            height: 500px;
            opacity: 0.9;
            background-repeat: no-repeat, repeat;
            background-size: cover;
            border-left: 6px solid red;
            border-radius: 15px;    
        }

        @media (min-width: 576px) {
            .az-container-signin {
                width: 70%;
            }
        }

        @media (min-width: 768px) {
            .az-container-signin {
                width: 60%;
            }
        }

        @media (min-width: 992px) {
            .az-container-signin {
                width: 50%;
            }
        }

        @media (min-width: 1200px) {
            .az-container-signin {
                width: 40%;
            }
        }
    </style>
</head>
<body>
    <form id="frmSignIn">

        <div class="az-display-middle" style="width: 100%;">

            <div class="az-container-signin az-padding-7 az-bg-white">
                <div class="az-row">
                    <div class="az-col xs-12">
                        <div class="az-form-group">
                            <img class="az-image az-center" src="img/welonda-logo_rot1166X250.png" style="max-height: 70px;" />
                        </div>
                    </div>
                </div>
                <div class="az-row">
                    <div class="az-col xs-12">
                        <div class="az-form-group">
                            <h4 class="az-text-center" id="AppName"></h4>
                        </div>
                    </div>
                </div>
                <div class="az-row">
                    <div class="az-col xs-12">
                        <div class="az-form-group">
                            <p class="az-alert az-alert-info az-circle-50" role="alert" id="signinInfo"></p>
                        </div>
                    </div>
                </div>
                <section id="SignIn">
                    <div class="az-row">
                        <div class="az-col xs-12 sm-6 sm-offset-3">
                            <div class="az-form-group">
                                <label class="az-label" for="Username" style="display: none;"></label>
                                <div class="az-input-group">
                                    <span class="az-input-group-addon"><i class="fas fa-user fa-fw"></i></span>
                                    <input type="text" class="az-input" placeholder="Brukernavn" id="Username" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="az-row">
                        <div class="az-col xs-12 sm-6 sm-offset-3">
                            <div class="az-form-group">
                                <label class="az-label" for="Password" style="display: none;"></label>
                                <div class="az-input-group">
                                    <span class="az-input-group-addon"><i class="fas fa-key fa-fw"></i></span>
                                    <input type="password" class="az-input" id="Password" />
                                    <span data-connectedid="Password" class="passwordeye az-input-group-addon az-shadow-1 az-shadow-hover-2 az-cursor-pointer"><i class="fas fa-eye fa-fw az-cursor-pointer"></i></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="az-row">
                        <div class="az-col xs-12 sm-6 sm-offset-3">
                            <div class="az-form-group">
                                <button type="button" class="az-button az-button-block az-shadow-1 az-shadow-hover-2 success" id="cmdSignIn"></button>
                            </div>
                        </div>
                    </div>
                    <div class="az-row">
                        <div class="az-col xs-12 sm-6 sm-offset-3">
                            <div class="az-form-group">
                                <button type="button" class="az-button az-button-block az-shadow-1 az-shadow-hover-2 info" id="cmdForgotPassword"></button>
                            </div>
                        </div>
                    </div>

                </section>
                <section id="ForgotPassword">
                    <div class="az-row">
                        <div class="az-col xs-12 sm-6 sm-offset-3">
                            <div class="az-form-group">
                                <label class="az-label" for="Username" style="display: none;"></label>
                                <div class="az-input-group">
                                    <span class="az-input-group-addon"><i class="fas fa-at fa-fw"></i></span>
                                    <input type="text" class="az-input" id="Email" />
                                </div>
                            </div>
                        </div>
                    </div>                    
                    <div class="az-row">
                        <div class="az-col xs-12 sm-6 sm-offset-3">
                            <div class="az-form-group">
                                <button type="button" class="az-button az-button-block az-shadow-1 az-shadow-hover-2 success" id="cmdSendEmail"></button>
                            </div>
                        </div>
                    </div>
                    <div class="az-row">
                        <div class="az-col xs-12 sm-6 sm-offset-3">
                            <div class="az-form-group">
                                <button type="button" class="az-button az-button-block az-shadow-1 az-shadow-hover-2 info" id="cmdBackToSigin"></button>
                            </div>
                        </div>
                    </div>
                </section>   
                <div class="az-row">
                    <div class="az-col xs-12 sm-6 sm-offset-3">
                        <div class="az-form-group az-dropdown-click">
                            <button type="button" class="az-button az-button-block link az-dropdown-button" id="cmdLanguage"></button>
                            <ul id="ul_language" class="az-ul-dropdown az-dropdown-content az-dropdown-default-layout"></ul>
                        </div>
                    </div>
                </div>
                <div class="az-row">
                        <div class="az-col xs-12 sm-6 sm-offset-3">
                            <div class="az-form-group">&nbsp;</div>   
                        </div>
                </div>
                <div class="az-row az-xs-margin-t-14">
                    <div class="az-col xs-12">
                        <div class="az-form-group">
                            <p class="az-text-center AppVersion"></p>
                        </div>
                    </div>
                </div>
            </div>   
          </div> 
    </form>
</body>
</html>
