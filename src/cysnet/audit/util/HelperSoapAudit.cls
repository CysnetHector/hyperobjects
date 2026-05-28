/// Clase auxiliar para registrar auditoría en API's de tipo SOAP
Class cysnet.audit.util.HelperSoapAudit Extends %RegisteredObject
{

Property auditRecord As cysnet.audit.util.AuditRecord;

Property headers As %DynamicObject;

/// Inicializar el registro de auditoría:
Method %OnNew(sessionId As %String, headers As %Collection.ArrayOfObj(ELEMENTTYPE="%SOAP.Header") = "") As %Status
{
	set ..auditRecord = ##class(cysnet.audit.util.AuditRecord).newRecord(sessionId)
	set ..headers = {}

	if (headers '= "") {
		do ..addHeaders(headers)
	}

	return $$$OK
}

Method addHeaders(headers As %Collection.ArrayOfObj(ELEMENTTYPE="%SOAP.Header")) As %Status
{
	set hName = ""
	for {
		set h = headers.GetNext(.hName)
		quit:hName=""

		set headerValueStr = ##class(cysnet.audit.util.AuditRecord).convertXMLToString(h)
		do ..headers.%Set(hName, headerValueStr)
	}

	return $$$OK
}

Method endAuditSoap(wsSC As %Status, className As %String, webClient As %SOAP.WebClient, reqWS As Ens.Request) As %Status
{
	// Si ha habido error en la invocación, registrarlo:
	if ($$$ISERR(wsSC)){
		do ..auditRecord.error("Error in SOAP invocation")
	}
	// Almacenar la información de la petición:
	do ..auditRecord.generateAuditContentAPISoap(className, webClient, ..headers, reqWS)
	
	// Finalizar auditoría:
	do ..auditRecord.endRecord()

	return $$$OK
}

}
