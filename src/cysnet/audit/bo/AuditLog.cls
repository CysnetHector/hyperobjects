Class cysnet.audit.bo.AuditLog Extends cysnet.rest.bo.RestManager
{

// Parameter ENDPOINTBASE = "http://webgateway/audit/api";

Parameter METHODADDRECORD = "addRecord";

Method addRecord(pRequest As cysnet.audit.msg.AddAuditRecordRequest, Output pResponse As cysnet.audit.msg.AddAuditRecordResponse) As %Status
{
	#dim httpadapter as EnsLib.HTTP.OutboundAdapter	
	set pResponse = ##class(cysnet.audit.msg.AddAuditRecordResponse).%New()
	set pResponse.done = 0

	set rest = ##class(cysnet.utils.HelperRestInvoker).%New()
    do rest.setUrlBase(..Adapter.URL)
	// Si se han especificado credenciales, las establecemos
	if ..Adapter.Credentials'=""
	{
		set tSC = ##class(cysnet.utils.HelperCredentials).getValues(..Adapter.Credentials,.username,.password)
		if $$$ISOK(tSC) do rest.setBasicAuth(username,password)
	}
    do rest.setCallMethod(##class(cysnet.utils.HelperRestInvoker).#METHODPOST)
    do rest.setBodyContent( pRequest.jsonAudit )
    set tSC = rest.invoke(..#METHODADDRECORD,.out,.statusCode)
    
    if $$$ISOK(tSC)
    {
        set pResponse.done = 1
        if (statusCode >= 400){
            set pResponse.done = 0
			set pResponse.error = "StatusCode: "_statusCode_$C(13,10)_"Out: "_out
        }
    } 
	else
	{
		set pResponse.error = $System.Status.GetErrorText(tSC)
	}
	quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="cysnet.audit.msg.AddAuditRecordRequest"> 
		<Method>addRecord</Method>
	</MapItem>
</MapItems>
}

}
