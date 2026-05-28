Include Ensemble

Class cysnet.rest.proxy.Rest Extends cysnet.rest.proxy.Interface
{

Property exito As %Boolean;

Property trace As cysnet.rest.msg.struct.Trace;

Property statusCode As %String(MAXLEN = "");

Property url As %String(MAXLEN = "");

Property rspHeaders As list Of cysnet.rest.msg.struct.CampoValor;

Property response As cysnet.rest.msg.RestResponse;

Method getResponse(pProxyResponse As %AbstractStream) As %Status
{
	#dim sc As %Status = $$$OK	
	#dim err = ""
	
	try {
		set ..response = ##class(cysnet.rest.msg.RestResponse).%New()
		
		set ..response.output = ##class(%Stream.GlobalCharacter).%New()
		set ..response.exito = ..exito
		set ..response.trace = ..trace
		set ..response.statusCode = ..statusCode
		set ..response.rspHeaders = ..rspHeaders
		do ..response.output.CopyFromAndSave(pProxyResponse)

		if ( (..response.exito = 0)&&(..response.trace.errors.Count() = 0) ) {
			do ..response.output.Rewind()
			set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("Rest", "Error: "_..response.output.Read(..response.output.Size))
			do ..response.output.Rewind()
		}
		
	} catch err {
		set ..response = ##class(cysnet.rest.msg.RestResponse).%New()
		set ..response.exito = 0
		set ..response.statusCode = "500 Internal Error"
		set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("Rest", "Error at "_err.Location_": "_err.Data)
	}
	
	quit sc
}

}
