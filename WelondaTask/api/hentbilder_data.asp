<%'************************************************
Response.Charset = "ISO-8859-1"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1

'************************************************

knyttetID = Trim(Request("knyttetid"))

'**************************************************

If knyttetID <> "" Then
	
	'***************************************************
	
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0; DATA SOURCE=" & server.mappath("/fpdb/welonda.mdb")
	
	'***************************************************
	
	Set rsbilder = Server.CreateObject("ADODB.Recordset")
	strSQL = "SELECT * FROM tblfil WHERE knyttetID LIKE " & knyttetID 
		
	rsbilder.CursorType = 2
	rsbilder.LockType = 3
	rsbilder.Open strSQL, conn
	
	Do While NOT rsbilder.EOF
		
		strData = strData & "{""url"": """ & rsbilder("Filnavn") & ""","		
		strData = strData & """dato"": """ & rsbilder("RegDato") & ""","
		strData = strData & """filid"": """ & rsbilder("FilID") & ""","
		strData = strData & """beskrivelse"": """ & rsbilder("Beskrivelse") & """},"
		
		
	rsbilder.MoveNext
	Loop
	
	
	'***************************************************

	conn.Close
	Set conn = Nothing
	Set rsbilder = Nothing
		
	'***************************************************
	
	If Right(strData, 1) = "," Then
		strData = Left(strData, Len(strData) -1)
	End If
	
	data = "{"
	
	data = data & """bilder"":"	
	data = data & "["
	data = data & strData
	data = data & "]"
	
	data = data & "}"
	
	response.write Data
	
End If

'**********************************************%>