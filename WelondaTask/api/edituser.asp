<%'******************************************************
Response.Charset = "ISO-8859-1"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1


    firstname = Trim(Request("firstname"))
    lastname = Trim(Request("lastname"))
    email = Trim(Request("email"))
    emailnotification = Trim(Request("emailnotification"))
    brukerid = Trim(Request("brukerid"))


    If firstname = "" OR lastname = "" OR email = "" OR emailnotification = "" OR brukerid = "" Then
	    melding = "emptystring"
    Else
        '***************************************************
	
	    Set Conn = Server.CreateObject("ADODB.Connection")
	    Conn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0; DATA SOURCE=" & server.mappath("/fpdb/welonda.mdb")
	
	    '***************************************************
	    Set rsBruker = Server.CreateObject("ADODB.Recordset")
	    strSQL = "SELECT * FROM tblBruker WHERE brukerID = " & brukerid
    
        rsBruker.CursorType = 2
	    rsBruker.LockType = 3	    
	    rsBruker.Open strSQL, conn
        
        rsBruker.Fields("fornavn") = firstname
        rsBruker.Fields("etternavn") = lastname
        rsBruker.Fields("brukernavn") = email
        rsBruker.Fields("epostVarsel") = emailnotification
        rsBruker.Update


        melding = "ok"
    End if
    data = "{"
				data = data & """Transfer"": """ & melding & """"
        data = data & "}"

    response.write data
    Set Conn = Nothing
    Set rsBruker = Nothing
%>