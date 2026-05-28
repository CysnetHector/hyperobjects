Class cysnet.audit.proxy.AddRecord Extends cysnet.rest.proxy.Interface
{

Property exito As %Boolean;

Property trace As cysnet.rest.msg.struct.Trace;

Property statusCode As %String(MAXLEN = "");

Property url As %String(MAXLEN = "");

Property rspHeaders As list Of cysnet.rest.msg.struct.CampoValor;

Property response As cysnet.audit.msg.AddAuditRecordResponse;

Method getResponse(pProxyResponse As %AbstractStream) As %Status
{
	#dim sc As %Status = $$$OK	
	#dim err = ""
	set ..response = ##class(cysnet.audit.msg.AddAuditRecordResponse).%New()
	set ..response.exito = 0

	try {	
		// Parsear la respuesta y obtener la información necesaria:
		do pProxyResponse.Rewind()
		if (pProxyResponse.Size > 0) {
			set response = ##class(%DynamicAbstractObject).%FromJSON(pProxyResponse)

			// Comprobamos si la llamada ha dado error
			if (response.%IsDefined("done")) 
			{
                set ..response.done = response.done
				set ..response.exito = 1
			}
			else
			{ 
				set ..response.done = 0
			}
		}
		do pProxyResponse.Rewind()
			
	} catch err {
		set ..response.done = 0
	}
	
	return sc
}

}
