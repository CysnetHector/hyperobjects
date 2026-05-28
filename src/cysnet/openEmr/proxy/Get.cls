Class cysnet.openEmr.proxy.Get Extends cysnet.rest.proxy.Interface
{

Property exito As %Boolean;

Property trace As cysnet.rest.msg.struct.Trace;

Property statusCode As %String(MAXLEN = "");

Property url As %String(MAXLEN = "");

Property rspHeaders As list Of cysnet.rest.msg.struct.CampoValor;

Property response As cysnet.openEmr.msg.GetResponse;

Method getResponse(pProxyResponse As %AbstractStream) As %Status
{
	#dim sc As %Status = $$$OK	
	#dim err = ""
	
	try {
		set ..response = ##class(cysnet.openEmr.msg.GetResponse).%New()
		set ..response.exito = ..exito
		set ..response.trace = ..trace
		set ..response.statusCode = ..statusCode
		set ..response.rspHeaders = ..rspHeaders
		
		// Parsear la respuesta y obtener la información necesaria:
		do pProxyResponse.Rewind()
		if (pProxyResponse.Size > 0) {
			set r = ##class(%DynamicAbstractObject).%FromJSON(pProxyResponse)
			set resource = ##class(cysnet.openEmr.msg.struct.Resource).%New()
			if (r.data) {
				#; // Si tenemos cabeceras en la respuesta, vamos a buscar la cabecera LOCATION:
				#; if (..rspHeaders.Count() > 0) {
				#; 	set found=0
				#; 	for i=1:1:..rspHeaders.Count() {
				#; 		if (..rspHeaders.GetAt(i).campo = "LOCATION") {
				#; 			set resource.fullUrl = ..rspHeaders.GetAt(i).valor
				#; 			set found=1
				#; 		}
				#; 		quit:found=1
				#; 	}
				#; }
				set resource.id = r.data.id
				set resource.uuid = r.data.uuid
				set resource.lastUpdated = r.data.date
				set resource.content = ##class(%Stream.GlobalCharacter).%New()
				do resource.content.Write(r.data.%ToJSON())
				set ..response.resource = resource
			}
		}

		if ( (..response.exito = 0)&&(..response.trace.errors.Count() = 0) ) {
			do pProxyResponse.Rewind()
			set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error proxy.Get: "_pProxyResponse.Read(pProxyResponse.Size))
			do pProxyResponse.Rewind()
		}
		
	} catch err {
		set ..response = ##class(cysnet.openEmr.msg.GetResponse).%New()
		set ..response.exito = 0
		set ..response.statusCode = "500 Internal Error"
		set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error at "_err.Location_": "_err.Data)
	}
	
	quit sc
}

}
