Class cysnet.openEmr.proxy.Put Extends cysnet.rest.proxy.Interface
{

Property exito As %Boolean;

Property trace As cysnet.rest.msg.struct.Trace;

Property statusCode As %String(MAXLEN = "");

Property url As %String(MAXLEN = "");

Property rspHeaders As list Of cysnet.rest.msg.struct.CampoValor;

Property response As cysnet.openEmr.msg.UpsertResponse;

Method getResponse(pProxyResponse As %AbstractStream) As %Status
{
	#dim sc As %Status = $$$OK	
	#dim err = ""
	
	try {
		set ..response = ##class(cysnet.openEmr.msg.UpsertResponse).%New()
		set ..response.exito = ..exito
		set ..response.trace = ..trace
		set ..response.statusCode = ..statusCode
		set ..response.rspHeaders = ..rspHeaders
		
		// Parsear la respuesta y obtener la información necesaria:
		do pProxyResponse.Rewind()
		if (pProxyResponse.Size > 0) {
			set r = ##class(%DynamicAbstractObject).%FromJSON(pProxyResponse)
			if (r.data) {
				if (r.data.%IsDefined("id")) {
					set ..response.id = r.data.id
				} elseif (r.data.%IsDefined("pid")) {
					set ..response.id = r.data.pid
				} elseif (r.data.%IsDefined("eid")) {
					set ..response.id = r.data.eid
				} elseif (r.data.%IsDefined("encounter")) {
					set ..response.id = r.data.encounter
				} elseif (r.data.%IsDefined("pc_eid")) {
					set ..response.id = r.data."pc_eid"
				}

				if (r.data.%IsDefined("uuid")) {
					set ..response.uuid = r.data.uuid
				} elseif (r.data.%IsDefined("euuid")) {
					set ..response.uuid = r.data.euuid
				} elseif (r.data.%IsDefined("pc_uuid")) {
					set ..response.uuid = r.data."pc_uuid"
				}

			} else {
				if (r.%IsDefined("id")) {
					set ..response.id = r.id
				} elseif (r.%IsDefined("pid")) {
					set ..response.id = r.pid
				} elseif (r.%IsDefined("eid")) {
					set ..response.id = r.eid
				} elseif (r.%IsDefined("encounter")) {
					set ..response.id = r.encounter
				} elseif (r.%IsDefined("pc_eid")) {
					set ..response.id = r."pc_eid"
				}

				if (r.%IsDefined("uuid")) {
					set ..response.uuid = r.uuid
				} elseif (r.%IsDefined("euuid")) {
					set ..response.uuid = r.euuid
				} elseif (r.%IsDefined("pc_uuid")) {
					set ..response.uuid = r."pc_uuid"
				}
			}
		}

		if ( (..response.exito = 0)&&(..response.trace.errors.Count() = 0) ) {
			do pProxyResponse.Rewind()
			set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error proxy.Put: "_pProxyResponse.Read(pProxyResponse.Size))
			do pProxyResponse.Rewind()
		}
		
	} catch err {
		set ..response = ##class(cysnet.openEmr.msg.UpsertResponse).%New()
		set ..response.exito = 0
		set ..response.statusCode = "500 Internal Error"
		set ..response.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error at "_err.Location_": "_err.Data)
	}
	
	quit sc
}

}
