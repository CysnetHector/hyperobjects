Class cysnet.openEmr.proxy.Token Extends cysnet.rest.proxy.Interface
{

Property exito As %Boolean;

Property trace As cysnet.rest.msg.struct.Trace;

Property statusCode As %String(MAXLEN = "");

Property url As %String(MAXLEN = "");

Property rspHeaders As list Of cysnet.rest.msg.struct.CampoValor;

Property response As cysnet.openEmr.msg.GetTokenResponse;

Method getResponse(pProxyResponse As %AbstractStream) As %Status
{
	#dim sc As %Status = $$$OK	
	#dim err = ""
	
	try {
		set ..response = ##class(cysnet.openEmr.msg.GetTokenResponse).%New()
		set ..response.exito = ..exito
		set ..response.trace = ..trace
		set ..response.statusCode = ..statusCode
		set ..response.rspHeaders = ..rspHeaders
		
		// Parsear la respuesta y obtener la información necesaria:
		do pProxyResponse.Rewind()
		if (pProxyResponse.Size > 0) {
			set json = ##class(%DynamicAbstractObject).%FromJSON(pProxyResponse)

			if (..exito = 1) {
				set ..response.token = json.get("access_token")
			} else {
				set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", json.get("error")_": "_json.get("error_description"))
			}
		}

		if ( (..response.exito = 0)&&(..response.trace.errors.Count() = 0) ) {
			do pProxyResponse.Rewind()
			set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error proxy.Token: "_pProxyResponse.Read(pProxyResponse.Size))
			do pProxyResponse.Rewind()
		}
		
	} catch err {
		set ..response = ##class(cysnet.openEmr.msg.GetTokenResponse).%New()
		set ..response.exito = 0
		set ..response.statusCode = "500 Internal Error"
		set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error at "_err.Location_": "_err.Data)
	}
	
	quit sc
}

}
