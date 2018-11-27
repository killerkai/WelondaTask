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
    <link rel="shortcut icon" href="../img/favicon.ico" type="image/x-icon" />
    <script src="lib/functionlib.js"></script>
    <script>
        if (!localStorage.bruker || localStorage.bruker == "")
        {
	        window.location.href = "login.asp";
        }

        LanguagePage = "lib/lang-val/default/default-lang.json";    
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
        {
         $("#cmdModalUser").off("click", setModalUser).on("click", setModalUser);
         $("#cmdSignOut").click(function () { signOut(); });
         $("#userFname").append(localStorage.fornavn);
         $("#userLname").append(localStorage.etternavn);
         hideCoverSpin();
        }
        function signOut()
        {
        showCoverSpin();
	    localStorage.bruker = ""; 
	    localStorage.fornavn = "";
	    localStorage.etternavn = "";
	    localStorage.status = "";
        window.setTimeout(function ()
                    {
                    window.location.href = "login.asp";                   
                    }, 500);
	        
        }
        function setModalUser()
        {           
            initializeModalDialog(
                {
                    dialogTitle: SingleElements.LabeleditUserTitle,
                    dialogWidth: 600,
                    dialogHeight: 250,
                    dialogiFrameURL: "pages/edituser.asp",
                    dialogPosition: true,
                    dialogPositionOf: $("#cmdModalUser"),
                    dialogNoParentScroll: true,
                    dialogTitlebarClose: false,
                    dialogNoParentScroll: true
                });
        }
    </script>
</head>
<body>
    <form id="frmReg">

        <div class="az-navbar az-navbar-top az-navbar-sticky">
            <div class="az-navbar-top-content">
                <button type="button" class="az-navbar-button">&#9776;</button>
                <img class="az-navbar-branding" alt="" src="img/welonda1.png" />
                <div class="az-navbar-menu-wrapper">
                    <ul class="az-navbar-menu az-left">
                        <li><a href="#section-1"><i class="fas fa-home fa-fw"></i><span id="menu1"></span></a></li>
                        <li><a href="#section-2"><i class="fas fa-tasks"></i><span id="menu2"></span></a></li>
                        <li><a href="#section-3"><i class="fas fa-users"></i><span id="menu3"></span></a></li>
                        <li><a href="#section-4"><i class="fas fa-chart-line"></i><span id="menu4"></span></a></li>
                        <li><a href="#section-5"><i class="fas fa-calculator"></i><span id="menu5"></span></a></li>
                    </ul>
                    <ul class="az-navbar-menu az-right">
                        <li id="cmdModalUser"><a href="javascript:void(0);closeNavbarMobile();"><i class="fas fa-user"></i><span>&nbsp;</span><span id="userFname"></span><span>&nbsp;</span><span id="userLname"></span></a></li>
                        <li id="cmdSignOut"><a href="javascript:void(0)"><i class="fas fa-sign-out-alt"></i><span id="signOut"></span></a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="az-navbar az-navbar-bottom az-navbar-sticky">
            <div class="az-navbar-bottom-content ka-text-center">
                <div class="az-col xs-12 az-white az-text-tiny "><i class="fas fa-copyright fa-fw "></i>2018 Welonda Norway AS</div>
            </div>
        </div>

        <div id="section-1" class="az-section" style="height: 1200px;">
            <div class="az-container az-padding-t-56">
                <h1>Hjem</h1>
            </div>
        </div>

        <div id="section-2" class="az-section az-bg-teal" style="height: 1200px;">
            <div class="az-container">
                <h1>Task</h1>

            </div>
        </div>

        <div id="section-3" class="az-section" style="height: 1200px;">
            <div class="az-container">
                <h1>Kunder</h1>
            </div>
        </div>
        <div id="section-4" class="az-section az-bg-teal" style="height: 1200px;">
            <div class="az-container">
                <h1>Statistikk</h1>
            </div>
        </div>
        <div id="section-5" class="az-section" style="height: 1200px;">
            <div class="az-container">
                <h1>Utregning</h1>
            </div>
        </div>
    </form>
</body>
</html>
