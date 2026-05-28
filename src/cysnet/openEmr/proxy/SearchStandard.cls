Include Ensemble

Class cysnet.openEmr.proxy.SearchStandard Extends cysnet.rest.proxy.Interface
{

Property exito As %Boolean;

Property trace As cysnet.rest.msg.struct.Trace;

Property statusCode As %String(MAXLEN = "");

Property url As %String(MAXLEN = "");

Property rspHeaders As list Of cysnet.rest.msg.struct.CampoValor;

Property response As cysnet.openEmr.msg.SearchStandardResponse;

Method getResponse(pProxyResponse As %AbstractStream) As %Status
{
	#dim sc As %Status = $$$OK	
	#dim err = ""
	
	try {
		set ..response = ##class(cysnet.openEmr.msg.SearchStandardResponse).%New()
		set ..response.exito = ..exito
		set ..response.trace = ..trace
		set ..response.statusCode = ..statusCode
		set ..response.rspHeaders = ..rspHeaders
	
		// Parsear la respuesta y obtener la información necesaria:
		do pProxyResponse.Rewind()
		if (pProxyResponse.Size > 0) {
			set ..response.total = 0
			set ..response.data = ##class(%ListOfObjects).%New()

			set lista = []
			try {
				set search = ##class(%DynamicAbstractObject).%FromJSON(pProxyResponse)
			} catch {
				// Si da error la transformación, generar un JSON vacío
				set search = {}
			}

			// Si la respuesta es un objeto dinámico, y tiene una propiedad data, y ésta es un array:
			if (search.%IsA("%Library.DynamicObject"))&&(search.%Get("data") '= "")&&(search.data.%IsA("%Library.DynamicArray")) {
				set lista = search.data

			// Si la respuesta es un array:
			} elseif (search.%IsA("%Library.DynamicArray")) {
				set lista = search
			}

			if (lista.%Size() > 0) {
				// Recorrer los cambios y generar un objeto Resource
				for i=0:1:lista.%Size()-1 {
					set r = lista.%Get(i)
					set resource = ##class(cysnet.hyperobjects.msg.struct.Resource).%New()
					set resource.fullUrl = ""
					set resource.resourceType = r.type
					set resource.id = r.id
					set resource.lastUpdated = ""
					set resource.versionId = ""
					set resource.content = ##class(%Stream.GlobalCharacter).%New()
					do resource.content.Write(r.%ToJSON())

					do ..response.data.Insert(resource)
					set ..response.total = ..response.total + 1
					k resource
				}
			}
		}

		// Si el status code es 404, cambiamos el exito a 1 para que no devuelva error:
		if (..statusCode = "404") {
			set ..response.exito = 1
		}
		
		if ( (..response.exito = 0)&&(..response.trace.errors.Count() = 0) ) {
			do pProxyResponse.Rewind()
			set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error proxy.SearchDefault: ["_..statusCode_"] "_pProxyResponse.Read(pProxyResponse.Size))
			do pProxyResponse.Rewind()
		}
		
	} catch err {
		set ..response = ##class(cysnet.openEmr.msg.SearchStandardResponse).%New()
		set ..response.exito = 0
		set ..response.statusCode = "500 Internal Error"
		set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error at "_err.Location_": "_err.Data)
	}
	
	quit sc
}

}
