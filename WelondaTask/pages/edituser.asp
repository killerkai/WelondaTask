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
    <link href="../lib/standard.css" rel="stylesheet" />
    <link rel="shortcut icon" href="../img/favicon.ico" type="image/x-icon" />
    <script src="../lib/functionlib.js"></script>
    <script>
        if (!localStorage.bruker || localStorage.bruker == "")
        {
	        window.location.href = "../login.asp";
        }

        LanguagePage = "../lib/lang-val/edituser/edituser-lang.json";        ValidationPage = "../lib/lang-val/edituser/edituser-val.json";
    $(document).ready(function ()
        {
            getContentData();
        });

        function getContentData()
        {
            initializePage(
            {     
                setLanguageClientStorage: true,
                getLanguage: true,
                getValidation: true
            }, function ()
            {
                setContentInfo();
            });
        }       
        function setContentInfo()
        {                 
         var radioState;
         $("#emailNotifacatin").click(function(){
                if (radioState === this) {
                $("#emailNotifacatin").val("true");
                localStorage.epostvarsel = true
                radioState = null;
                } else {
                    $("#emailNotifacatin").val("false");
                    localStorage.epostvarsel = false
                    radioState = this;
                }            
            });
         $("#FirstName").val(localStorage.fornavn);
         $("#LastName").val(localStorage.etternavn);
         $("#Email").val(localStorage.userName);         
         if (localStorage.epostvarsel == "true")
            {
                $("#emailNotifacatin").prop('checked', true);
                $("#emailNotifacatin").val("true");
            }
        if (localStorage.epostvarsel == "false")
            {
                $("#emailNotifacatin").prop('checked', false);
                $("#emailNotifacatin").val("false");
            }
         formdirty = false;
         hideCoverSpin();
         $("#" + ThisFormId).show();
        }         function validateDirty()
        {
            formdirty = true;        
            $("#cmdClose").text(SingleDefaultElements.cmdCancelText);
        }        function verifyCancel()
        {
            confirmCancel(function () { window.top.closeModalDialog() });
        }        function verifySubmit()
        {        var _ObjForm = serializeForm("#" + ThisFormId);
        if (isEmpty(_ObjForm) == false)
        {            var brukerid = localStorage.brukerid            showCoverSpin();
	 	    var output = "firstname=" + $('#FirstName').val() + "&lastname=" + $('#LastName').val()+ "&email=" + $('#Email').val()+ "&emailnotification=" + $('#emailNotifacatin').val()+ "&brukerid=" + brukerid; 		    
            $.ajaxSetup({cache: false});
		    $.ajax(
		    {
			    type: "POST",
			    url: "../api/edituser.asp",						
		        data: output,
		        dataType: 'json',					   
		        async: true,
		        cache: false,
		        timeout: 100000,
			    error: function()
			    {    
                    hideCoverSpin(); 
                    initializeAZWindow(
                        {
                            dialogTitle: SingleDefaultElements.errorDialogAlertTitle,
                            dialogText: SingleDefaultElements.errorDialogAlertText
                        });				
			    },
			    success: function(responseText)			
			    {
                if (responseText.Transfer == "emptystring")
			    {  
                    hideCoverSpin(); 
                    initializeAZWindow(
                        {
                            dialogTitle: SingleDefaultElements.errorDialogAlertTitle,
                            dialogText: SingleDefaultElements.errorDialogAlertText
                        });	
                }
                if (responseText.Transfer == "ok")
			    {  
                    window.setTimeout(function ()
                    {
                        localStorage.fornavn = $("#FirstName").val();
			            localStorage.etternavn = $("#LastName").val();
			            localStorage.userName = $("#Email").val();
			            localStorage.epostvarsel = $("#emailNotifacatin").val();
                        parent.$("#userFname").text("");
                        parent.$("#userLname").text("");
                        parent.$("#userFname").append(localStorage.fornavn);
                        parent.$("#userLname").append(localStorage.etternavn);
                        formdirty = false;
                        changeModalTitlebar(
                        {
                            dialogTitle: SingleDefaultElements.labelTopsliderChangesHaveBeenSaved,
                            dialogAlertClass: 'az-alert-primary',
                            dialogTitleTimeout: 3000
                        });
                        $("#cmdClose").text(SingleDefaultElements.cmdCloseText);
                        hideCoverSpin();                         
                    }, 1000);
                    
                    
			    }            }         });        }                }        
    </script>
</head>
<body class="az-bg-white">

    <form class="disabled-enter" id="frmContact" style="display: none;">
        <div class="az-container">

            <div class="az-row az-padding-t-14">
                <div class="az-col xs-12 sm-6">
                    <div class="az-form-group">
                        <label class="az-label" for="FirstName" id="labelFirstName"></label>
                        <input type="text" class="az-input" id="FirstName" />
                    </div>
                </div>
                <div class="az-col xs-12 sm-6">
                    <div class="az-form-group">
                        <label class="az-label" for="LastName" id="labelLastName"></label>
                        <input type="text" class="az-input" id="LastName" />
                    </div>
                </div>
            </div>
            <div class="az-row">
                <div class="az-col xs-12 sm-6">
                    <div class="az-form-group">
                        <label class="az-label" for="Email" id="labelEmail"></label>
                        <input type="text" class="az-input" id="Email" />
                    </div>
                </div>
                <div class="az-col xs-12 sm-6">
                    <div class="az-form-group">
                        <input id="emailNotifacatin" class="az-radio" type="checkbox" value="">
                        <label id="LableEmailNotifacatin" class="az-label"></label>
                    </div>
                </div>
            </div>
            <div class="az-row az-margin-t-14 az-margin-b-14">
                <div class="az-col xs-12 sm-6">
                    <div class="az-form-group">
                        <button type="button" class="az-button az-button-block primary az-shadow-1 az-shadow-hover-2 submit" id="cmdSubmit"></button>
                    </div>
                </div>
                <div class="az-col xs-12 sm-6">
                    <div class="az-form-group">
                        <button type="button" class="az-button az-button-block info az-shadow-1 az-shadow-hover-2 cancel" id="cmdClose"></button>
                    </div>
                </div>
            </div>

        </div>
    </form>

</body>
</html>
