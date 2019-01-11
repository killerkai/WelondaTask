<%'************************************************
'Response.Charset = "ISO-8859-1"
Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
Response.CodePage = 65001
Response.CharSet = "UTF-8"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1

'************************************************

kundesok = Trim(Request("kundesok"))

'**************************************************

If kundesok <> "" Then
	
	'***************************************************
	
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0; DATA SOURCE=" & server.mappath("/fpdb/welonda.mdb")
	
	'***************************************************
	
	Set rsKunder = Server.CreateObject("ADODB.Recordset")
	strSQL = "SELECT TOP 50 * FROM kunder WHERE kunde Like '" & kundesok & "%'"
		
	rsKunder.CursorType = 2
	rsKunder.LockType = 3
	rsKunder.Open strSQL, conn
	
	Do While NOT rsKunder.EOF	
		
		strData = strData & "{""kunde"": """ & rsKunder("kunde") & ""","
		strData = strData & """org"": """ & rsKunder("org") & ""","
		strData = strData & """adresse"": """ & rsKunder("adresse") & ""","
		strData = strData & """postnr"": """ & rsKunder("postnr") & ""","
		strData = strData & """sted"": """ & rsKunder("sted") & ""","
		strData = strData & """info"": """ & rsKunder("info") & ""","
		strData = strData & """tlf"": """ & rsKunder("tlf") & ""","
		strData = strData & """kontaktperson"": """ & rsKunder("kontaktperson") & ""","
		strData = strData & """mobil"": """ & rsKunder("mobil") & ""","
		strData = strData & """epost"": """ & rsKunder("epost") & ""","
		strData = strData & """dato"": """ & rsKunder("dato") & ""","
		strData = strData & """status"": """ & rsKunder("status") & ""","		
		strData = strData & """kundeID"": """ & rsKunder("kundeid") & """},"
	
	rsKunder.MoveNext
	Loop

	'***************************************************

	conn.Close
	Set conn = Nothing
	Set rsKunder = Nothing
		
	'***************************************************
	
	If Right(strData, 1) = "," Then
		strData = Left(strData, Len(strData) -1)
	End If
	
	Data = "[" & strData & "]"
	
	response.write Data
	
End If

'**********************************************%>