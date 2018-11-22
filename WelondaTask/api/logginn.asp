<%'******************************************************
Response.Charset = "ISO-8859-1"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1



brukernavn = Trim(Request("brukernavn"))
passord = Trim(Request("passord"))

If passord = "" Then
    melding = "feilnopassword"
    end if
If brukernavn = "" Then
    melding = "feilnousername"
    end if

If brukernavn = "" OR passord = "" Then
	
	data = "{"
				data = data & """Transfer"": """ & melding & """"
		
	data = data & "}"


Else

	'***************************************************
	
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0; DATA SOURCE=" & server.mappath("/fpdb/welonda.mdb")
	
	'***************************************************
	Set rsBruker = Server.CreateObject("ADODB.Recordset")
	strSQL = "SELECT * FROM tblBruker WHERE brukernavn = '" & brukernavn & "' AND Passord = '" & passord & "' AND Status = 1"
	
	rsBruker.CursorType = 0
	rsBruker.LockType = 1
	rsBruker.CursorLocation = 3
	rsBruker.Open strSQL, conn
	
	If rsBruker.EOF Then

		conn.Close
		Set conn = Nothing
		Set rsBruker = Nothing
			
		melding = "feilbrukerpass"
		data = "{"
				data = data & """Transfer"": """ & melding & """"			
		
		data = data & "}"		
	ElseIf NOT rsBruker.EOF Then
	
		melding = "ok"
		
		data = "{"
				data = data & """Transfer"": """ & melding & ""","
				data = data & """brukerid"": """ & rsBruker.Fields("brukerID") & ""","
				data = data & """brukernavn"": """ & rsBruker.Fields("brukernavn") & ""","
				data = data & """fornavn"": """ & rsBruker.Fields("fornavn") & ""","
				data = data & """etternavn"": """ & rsBruker.Fields("etternavn") & ""","
				data = data & """brukertype"": """ & rsBruker.Fields("brukertype") & ""","
                data = data & """epostvarsel"": """ & rsBruker.Fields("epostVarsel") & ""","
				data = data & """status"": """ & rsBruker.Fields("status") & """"						
				
		
		data = data & "}"
	End if	
End if

response.write data

Set Conn = Nothing
Set rsBruker = Nothing	

%>
	
