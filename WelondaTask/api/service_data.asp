<%'******************************************************
Response.Charset = "ISO-8859-1"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1

mode = Trim(Request("mode"))
kundeid = Trim(Request("txtkundeid"))
serviceid = Trim(Request("txtserviceid"))
servicenr = Trim(Request("txtservicenr"))
regdato = Trim(Request("txtregdato"))
onsketdato = Trim(Request("txtonsketdato"))
motattav = Trim(Request("txtmotattav"))
beskrivelse = Trim(Request("txtbeskrivelse"))
udato = Trim(Request("txtudato"))
fakturert = Trim(Request("txtfakturert"))
status = Trim(Request("txtstatus"))
utfortav = Trim(Request("txtutfortav"))
ubeskrivelse = Trim(Request("txtubeskrivelse"))
brukerid = Trim(Request("txtbrukerid"))
brukernavn = Trim(Request("txtbrukernavn"))
serverIP = "178.21.128.93"
Domain = Trim(Request.ServerVariables("SERVER_NAME"))

If beskrivelse = ""  or  motattav = 0 Then
	melding = "feil"
	


Else

	'***************************************************
	
	Set Conn = Server.CreateObject("ADODB.Connection")
    
	Conn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0; DATA SOURCE=" & server.mappath("/fpdb/welonda.mdb")
	
	'***************************************************
	if serviceid = "" then
		Set rsNyService = Server.CreateObject("ADODB.Recordset")
		strSQL = "SELECT * FROM tblService"
			
		rsNyService.CursorType = 2
		rsNyService.LockType = 3
		rsNyService.Open strSQL, conn
		
		rsNyService.MoveLast
		Lastservicenr = rsNyService.Fields("servicenummer")
		Lastservicenr = Lastservicenr + 1
		
		rsNyService.Update	
			
		rsNyService.AddNew
		
		rsNyService.Fields("servicenummer") = Lastservicenr
		rsNyService.Fields("knyttetID") = kundeid
		rsNyService.Fields("regdato") = NOW
		rsNyService.Fields("onsketdato") = onsketdato
		rsNyService.Fields("motattav") = motattav
		rsNyService.Fields("beskrivelse") = beskrivelse
		rsNyService.Fields("utfortdato") = udato
		rsNyService.Fields("fakturert") = fakturert		
		rsNyService.Fields("status") = status
		rsNyService.Fields("utfortav") = utfortav
		rsNyService.Fields("ubeskrivelse") = ubeskrivelse	
			
		rsNyService.Update
		
		
		
		melding = "ny"
		if motattav = brukerid then
			epost = "nei"
		else
			Set rsBruker = Server.CreateObject("ADODB.Recordset")
			strSQL = "SELECT * FROM tblBruker WHERE brukerID = " & motattav
				
			rsBruker.CursorType = 2
			rsBruker.LockType = 3
			rsBruker.Open strSQL, conn
			
			epostadresse = rsBruker.Fields("brukernavn") 
			html = "Hei " & rsBruker.Fields("fornavn") & " " & rsBruker.Fields("etternavn") & VbCrLf
			html = html & VbCrLf
			html = html & VbCrLf
			html = html & brukernavn & " har sendt deg en ny oppgave i Welonda Task" & VbCrLf
			html = html & VbCrLf
			html = html & "Beskrivelse: " & beskrivelse & "" & VbCrLf			
			html = html & VbCrLf
			html = html & VbCrLf			
			html = html & VbCrLf
			html = html & "Mvh" & VbCrLf
			html = html & "Team Welonda Norway AS" & VbCrLf
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
			myMail.To = epostadresse		
			myMail.Subject = "Ny oppgave "& Lastservicenr
			myMail.TextBody = html
			myMail.BodyPart.Charset = "UTF-8"		
			myMail.Send
			Set myMail = Nothing
			epost = "ja"
		end if
	else
		Set rsService = Server.CreateObject("ADODB.Recordset")
		strSQL = "SELECT * FROM tblService WHERE serviceID = " & serviceid
			
		rsService.CursorType = 2
		rsService.LockType = 3
		rsService.Open strSQL, conn	
			
		rsService.Fields("onsketdato") = onsketdato
		rsService.Fields("motattav") = motattav
		rsService.Fields("beskrivelse") = beskrivelse
		rsService.Fields("utfortdato") = udato
		rsService.Fields("fakturert") = fakturert		
		rsService.Fields("status") = status
		rsService.Fields("utfortav") = utfortav
		rsService.Fields("ubeskrivelse") = ubeskrivelse
		servicenummer = rsService.Fields("servicenummer")
		rsService.Update		
		
		if motattav = brukerid then
			epost = "nei"
		else
			Set rsBruker = Server.CreateObject("ADODB.Recordset")
			strSQL = "SELECT * FROM tblBruker WHERE brukerID = " & motattav
				
			rsBruker.CursorType = 2
			rsBruker.LockType = 3
			rsBruker.Open strSQL, conn
			
			epostadresse = rsBruker.Fields("brukernavn") 
			html = "Hei " & rsBruker.Fields("fornavn") & " " & rsBruker.Fields("etternavn") & VbCrLf
			html = html & VbCrLf			
			html = html & brukernavn & " har sendt deg en ny oppgave i Welonda Task" & VbCrLf
			html = html & VbCrLf
			html = html & "Beskrivelse: " & beskrivelse & "" & VbCrLf			
			html = html & VbCrLf
			html = html & VbCrLf			
			html = html & "Mvh" & VbCrLf
			html = html & "Team Welonda Norway AS" & VbCrLf			
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
			myMail.To = epostadresse		
			myMail.Subject = "Ny oppgave "& servicenummer 
			myMail.TextBody = html
			myMail.BodyPart.Charset = "UTF-8"		
			myMail.Send
			Set myMail = Nothing
			epost = "ja"
		end if
		
		melding = "opp"
	End If


End If
data = "{"
		data = data & """Transfer"": """ & melding & ""","
		data = data & """epost"": """ & epost & ""","
		data = data & """epostadresse"": """ & epostadresse & ""","
		data = data & """serviceid"": """ & Lastservicenr & ""","
		data = data & """uppserviceid"": """ & servicenr & ""","
		data = data & """Updated"": """ & now & """"		
		

data = data & "}"

response.write data

Set Conn = Nothing
Set rsService = Nothing
Set rsBruker = Nothing
Set rsNyService = Nothing










%>