<%'************************************************
Response.Charset = "ISO-8859-1"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1

'************************************************
taskid = Trim(Request("taskid"))

If taskid <> "" Then
	
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0; DATA SOURCE=" & server.mappath("/fpdb/welonda.mdb")	
	
	
	'***************************************************
	
	Set rs = Server.CreateObject("ADODB.Recordset")
	strSQL = "SELECT * FROM tblService WHERE serviceID LIKE " & taskid 
		
	rs.CursorType = 2
	rs.LockType = 3
	rs.Open strSQL, conn
	
	'rs.Delete
	'rs.Update
	
	Conn.Close
	Set Conn = Nothing
	Set rs = Nothing
			
	'***************************************************************************************
	melding = "ok"
Else
    melding = "emptystring"
End If

data = "{"
		data = data & """Transfer"": """ & melding & ""","		
		data = data & """Updated"": """ & now & """"		
		

data = data & "}"

response.write data




'**********************************************%>