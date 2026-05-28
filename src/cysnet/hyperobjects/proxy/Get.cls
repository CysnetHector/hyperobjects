Class cysnet.hyperobjects.proxy.Get Extends cysnet.rest.proxy.Interface
{

Property exito As %Boolean;

Property trace As cysnet.rest.msg.struct.Trace;

Property statusCode As %String(MAXLEN = "");

Property url As %String(MAXLEN = "");

Property rspHeaders As list Of cysnet.rest.msg.struct.CampoValor;

Property response As cysnet.hyperobjects.msg.GetResponse;

Method getResponse(pProxyResponse As %AbstractStream) As %Status
{
	#dim sc As %Status = $$$OK	
	#dim err = ""
	
	try {
		set ..response = ##class(cysnet.hyperobjects.msg.GetResponse).%New()
		set ..response.exito = ..exito
		set ..response.trace = ..trace
		set ..response.statusCode = ..statusCode
		set ..response.rspHeaders = ..rspHeaders
		
		// Parsear la respuesta y obtener la información necesaria:
		do pProxyResponse.Rewind()
		if (pProxyResponse.Size > 0) {
			set r = ##class(%DynamicAbstractObject).%FromJSON(pProxyResponse)
			set resource = ##class(cysnet.hyperobjects.msg.struct.Resource).%New()

			// Si tenemos cabeceras en la respuesta, vamos a buscar la cabecera LOCATION:
			if (..rspHeaders.Count() > 0) {
				set found=0
				for i=1:1:..rspHeaders.Count() {
					if (..rspHeaders.GetAt(i).campo = "LOCATION") {
						set resource.fullUrl = ..rspHeaders.GetAt(i).valor
						set found=1
					}
					quit:found=1
				}
			}
			set resource.resourceType = r.resourceType
			set resource.id = r.id
			set resource.lastUpdated = $ZDT($ZDTH(r.meta.lastUpdated,3,7),3,1)
			set resource.versionId = r.meta.versionId
			set resource.content = ##class(%Stream.GlobalCharacter).%New()
			do resource.content.Write(r.%ToJSON())
			set ..response.resource = resource
		}

		if ( (..response.exito = 0)&&(..response.trace.errors.Count() = 0) ) {
			do pProxyResponse.Rewind()
			set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "Error proxy.Get: "_pProxyResponse.Read(pProxyResponse.Size))
			do pProxyResponse.Rewind()
		}
		
	} catch err {
		set ..response = ##class(cysnet.hyperobjects.msg.GetResponse).%New()
		set ..response.exito = 0
		set ..response.statusCode = "500 Internal Error"
		set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "Error at "_err.Location_": "_err.Data)
	}
	
	quit sc
}

}
