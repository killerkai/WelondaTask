<%'************************************************
Response.Charset = "ISO-8859-1"
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1

'************************************************
Function jsonEncode(str)
 If str <> "" Then
  Dim charmap(127), haystack()
  charmap(8)  = "\b"
  charmap(9)  = "\t"
  charmap(10) = "\n"
  charmap(12) = "\f"
  charmap(13) = "\r"
  charmap(34) = "\"""
  charmap(47) = "\/"
  charmap(92) = "\\"
  Dim strlen : strlen = Len(str) - 1
  ReDim haystack(strlen)
  Dim i, charcode
  For i = 0 To strlen
   haystack(i) = Mid(str, i + 1, 1)
   charcode = AscW(haystack(i)) And 65535
   If charcode < 127 Then
    If Not IsEmpty(charmap(charcode)) Then
     haystack(i) = charmap(charcode)
    ElseIf charcode < 32 Then
     haystack(i) = "\u" & Right("000" & LCase(Hex(charcode)), 4)
    End If
   Else
    haystack(i) = "\u" & Right("000" & LCase(Hex(charcode)), 4)
   End If
  Next
  jsonEncode = Join(haystack, "")
 Else
  jsonEncode = str 
 End If
End Function

Function ReplaceBadChar(strTemp)
	strTemp = Replace(Replace(Replace(Replace(strTemp, Chr(10), "\n"), Chr(13), "\r"), Chr(34), "\"""), "<br>", "")
	ReplaceBadChar = strTemp
End Function

Function IngressTekst(InString,What,Lengde)

	LoopLengde = LEN(InString)
	If LoopLengde < Lengde Then
		IngressTekst = InString	
	Else

		If Asc(Mid(InString, LoopLengde, 1)) <> Asc(What) Then
			InString = InString & chr(What)
			LoopLengde = LEN(InString)
		End If

		For i = 1 To LoopLengde
		 	If Asc(Mid(InString, i, 1)) = What Then	 	
				If i >= Lengde Then
			 		w_InString = Mid(InString, 1, i)
		 			Exit For 	
		 		End If
		 	End If	
		Next		
		IngressTekst = w_InString

	End If

End Function


mode = Trim(Request("mode"))
kundeid = Trim(Request("kundeid"))
utforesav = Trim(Request("utforesav"))
taskid = Trim(Request("taskid"))

'**************************************************
If mode <> "" Then
	
	'***************************************************
	
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open "PROVIDER=MICROSOFT.JET.OLEDB.4.0; DATA SOURCE=" & server.mappath("/fpdb/welonda.mdb")
	
	'***************************************************
	
	Set rsserviceliste = Server.CreateObject("ADODB.Recordset")
    If mode = "full" Then
		strSQL = "SELECT * FROM tblservice" 	
	end if
	If mode = "alle_full" Then
		strSQL = "SELECT * FROM tblservice WHERE motattav=" & utforesav 	
	end if
	If mode = "apene_full" Then
		strSQL = "SELECT * FROM tblservice WHERE motattav = " & utforesav & " AND (status <>  '1' OR fakturert = '0') ORDER BY servicenummer DESC"	
	end if
	If mode = "kunde" Then
		strSQL = "SELECT * FROM tblservice WHERE knyttetID=" & kundeid	
	end if	
	If mode = "ut_full" Then
		strSQL = "SELECT * FROM tblservice WHERE status = '1' AND fakturert > '0' AND motattav=" & utforesav & " ORDER BY servicenummer"	
    end if	
	If mode = "OneTask" Then
		strSQL = "SELECT * FROM tblservice WHERE serviceID=" & taskid
	end if
	rsserviceliste.CursorType = 2
	rsserviceliste.LockType = 3
	rsserviceliste.Open strSQL, conn
	
	Do While NOT rsserviceliste.EOF
	
		thisserviceBeskrivelseIngress = ""
		If rsserviceliste("beskrivelse") <> "" Then
			thisserviceBeskrivelseIngress = IngressTekst(rsserviceliste("beskrivelse"),32,15) & "..."
		End If
		
		kundeid = rsserviceliste("knyttetID")
		
		Set rsKunde = Server.CreateObject("ADODB.Recordset")
		strSQL = "SELECT * FROM kunder WHERE kundeID = " & kundeid
			
		rsKunde.CursorType = 2
		rsKunde.LockType = 3
		rsKunde.Open strSQL, conn		
		
		
		strData = strData & "{""servicenummer"": """ & rsserviceliste("servicenummer") & ""","		
		strData = strData & """regdato"": """ & rsserviceliste("regdato") & ""","
		strData = strData & """kundeid"": """ & rsserviceliste("knyttetID") & ""","
		strData = strData & """kunde"": """ & jsonEncode(rsKunde("kunde")) & ""","
        strData = strData & """adresse"": """ & jsonEncode(rsKunde("adresse")) & ""","
        strData = strData & """postnr"": """ & rsKunde("postnr") & ""","
        strData = strData & """sted"": """ & jsonEncode(rsKunde("sted")) & ""","
        strData = strData & """tlf"": """ & rsKunde("tlf") & ""","
		strData = strData & """utfortdato"": """ & rsserviceliste("utfortdato") & ""","
		strData = strData & """onsketdato"": """ & rsserviceliste("onsketdato") & ""","
		strData = strData & """ubeskrivelse"": """ & jsonEncode(rsserviceliste("ubeskrivelse")) & ""","
		strData = strData & """beskrivelse"": """ & jsonEncode(rsserviceliste("beskrivelse")) & ""","
		strData = strData & """beskrivelseingress"": """ & ReplaceBadChar(thisserviceBeskrivelseIngress) & ""","
		strData = strData & """serviceid"": """ & rsserviceliste("serviceID") & ""","
		strData = strData & """fakturert"": """ & rsserviceliste("fakturert") & ""","
		strData = strData & """utfortav"": """ & rsserviceliste("utfortav") & ""","
		strData = strData & """motattav"": """ & rsserviceliste("motattav") & ""","
		strData = strData & """status"": """ & rsserviceliste("status") & """},"
		
		Set rsKunde = Nothing

	rsserviceliste.MoveNext
	Loop
	
	
	'***************************************************

	conn.Close
	Set conn = Nothing
	Set rsserviceliste = Nothing
		
	'***************************************************
	
	If Right(strData, 1) = "," Then
		strData = Left(strData, Len(strData) -1)
	End If
	
	data = "{"
	
	data = data & """service"":"	
	data = data & "["
	data = data & strData
	data = data & "]"
	
	data = data & "}"
	
	response.write Data
	
End If

'**********************************************%>