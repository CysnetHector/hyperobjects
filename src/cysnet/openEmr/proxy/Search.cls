Class cysnet.openEmr.proxy.Search Extends cysnet.rest.proxy.Interface
{

Property exito As %Boolean;

Property trace As cysnet.rest.msg.struct.Trace;

Property statusCode As %String(MAXLEN = "");

Property url As %String(MAXLEN = "");

Property rspHeaders As list Of cysnet.rest.msg.struct.CampoValor;

Property response As cysnet.openEmr.msg.SearchResponse;

Method getResponse(pProxyResponse As %AbstractStream) As %Status
{
	#dim sc As %Status = $$$OK	
	#dim err = ""
	
	try {
		set ..response = ##class(cysnet.openEmr.msg.SearchResponse).%New()
		set ..response.exito = ..exito
		set ..response.trace = ..trace
		set ..response.statusCode = ..statusCode
		set ..response.rspHeaders = ..rspHeaders
		
		// Parsear la respuesta y obtener la información necesaria:
		do pProxyResponse.Rewind()
		if (pProxyResponse.Size > 0) {
			set search = ##class(%DynamicAbstractObject).%FromJSON(pProxyResponse)
			// Si hay cambios:
			if (search.total > 0)&&(search.entry '= "") {
				set ..response.total = search.total
				set ..response.entry = ##class(%ListOfObjects).%New()

				// Obtener el link a la siguiente página (si hubiese)
				for i=0:1:search.link.%Size()-1 {
					if (search.link.%Get(i).relation = "next") {
						set ..response.nextLink = search.link.%Get(i).url
					}
				}

				// Recorrer los cambios y generar un objeto Resource
				for i=0:1:search.entry.%Size()-1 {
					set r = search.entry.%Get(i).resource
					set resource = ##class(cysnet.hyperobjects.msg.struct.Resource).%New()
					set resource.fullUrl = search.entry.%Get(i).fullUrl
					set resource.resourceType = r.resourceType
					set resource.id = r.id
					set resource.lastUpdated = $ZDT($ZDTH(r.meta.lastUpdated,3,7),3,1)
					set resource.versionId = r.meta.versionId
					set resource.content = ##class(%Stream.GlobalCharacter).%New()
					do resource.content.Write(r.%ToJSON())

					do ..response.entry.Insert(resource)
					k resource
				}
			}
		}

		if ( (..response.exito = 0)&&(..response.trace.errors.Count() = 0) ) {
			do pProxyResponse.Rewind()
			set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error proxy.Search: "_pProxyResponse.Read(pProxyResponse.Size))
			do pProxyResponse.Rewind()
		}
		
	} catch err {
		set ..response = ##class(cysnet.openEmr.msg.SearchResponse).%New()
		set ..response.exito = 0
		set ..response.statusCode = "500 Internal Error"
		set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error at "_err.Location_": "_err.Data)
	}
	
	quit sc
}

}
