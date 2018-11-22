<%'******************************************************
Response.Charset = "ISO-8859-1"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1

serverIP = "178.21.128.93"
email = Trim(Request("email"))
Domain = Trim(Request.ServerVariables("SERVER_NAME"))

If email = "" Then
	melding = "emptystring"
	data = "{"
			data = data & """Transfer"": """ & melding & """"		
	data = data & "}"

Else
'***************************************************
	
Set Conn = Server.CreateObject("ADODB.Connection")
Conn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0; DATA SOURCE=" & server.mappath("../fpdb/welonda.mdb")
	
'***************************************************
    Set rsBruker = Server.CreateObject("ADODB.Recordset")
	strSQL = "SELECT * FROM tblBruker WHERE brukernavn = '" & email & "'"
	
	rsBruker.CursorType = 0
	rsBruker.LockType = 1
	rsBruker.CursorLocation = 3
	rsBruker.Open strSQL, conn
	
	If rsBruker.EOF Then

		
			
		melding = "noemailreg"
		data = "{"
				data = data & """Transfer"": """ & melding & """"	
		data = data & "}"		
	ElseIf NOT rsBruker.EOF Then

		html = "Hei " & rsBruker.Fields("fornavn") & " " & rsBruker.Fields("etternavn") & ", " & VbCrLf 
		html = html & VbCrLf			
		html = html & "Du har kontaktet oss ang ditt passord." & VbCrLf
		html = html & "Passordet ditt er: " & rsBruker("passord") & VbCrLf					
		html = html & VbCrLf
		html = html & VbCrLf			
		html = html & "Mvh" & VbCrLf
		html = html & "Team Welonda Norway AS" & VbCrLf
		html = html & "http://" & Domain & "" & VbCrLf
		html = html & VbCrLf
		html = html & VbCrLf
		html = html & VbCrLf
		html = html & "Dette er en automatisk generert e-post, vennligst ikke svar på denne." & VbCrLf
				
		Set myMail = Server.CreateObject("CDO.Message")
		myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = serverIP
		myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		myMail.Configuration.Fields.Update
				
		myMail.From = "team@welondanorway.no"
		myMail.To = rsBruker.Fields("brukernavn")		
		myMail.Subject = "Team Welonda Norway"
		myMail.TextBody = html
		myMail.BodyPart.Charset = "UTF-8"		
		myMail.Send
		Set myMail = Nothing

        melding = "ok"
	    data = "{"
				    data = data & """Transfer"": """ & melding & """"
	    data = data & "}"
        conn.Close
    End if
End if


Set conn = Nothing
Set rsBruker = Nothing
response.write data
%>