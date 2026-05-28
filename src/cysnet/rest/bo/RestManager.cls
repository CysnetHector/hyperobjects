Class cysnet.rest.bo.RestManager Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Parameter SETTINGS = "PrintLog";

Property PrintLog As %Boolean [ InitialExpression = 0 ];

Method runMethod(pProxyManager As cysnet.rest.proxy.Interface, pRequest As %RegisteredObject, pURL As %String, type As %String, contentType As %String = "", headerParams As %ListOfObjects(ELEMENTTYPE="cysnet.rest.msg.struct.CampoValor") = "", params As %ListOfObjects(ELEMENTTYPE="cysnet.rest.msg.struct.CampoValor") = "") As %Status
{
	#dim tSC As %Status = $$$OK
	#dim exito As %Boolean = 0
	#dim traza As cysnet.rest.msg.struct.Trace = ##class(cysnet.rest.msg.struct.Trace).%New()
	#dim tURL, statusCode As %String = ""
	#dim tProxyResponse = ""
	
	// Si la URL ya tiene http (los 4 primeros caracteres), no concatenar nada
	if ($Extract(pURL,1,4) = "http") {
		set tURL = pURL
	} else {
		set tURL = ..Adapter.URL_pURL
	}
	
	set pProxyManager.url = tURL

	if (..PrintLog) {
		$$$LOGASSERT("Parámetros en header: "_$s((headerParams '= ""):headerParams.Count(),1:"No hay")_" - Parámetros adicionales: "_$s((params '= ""):params.Count(),1:"No hay"))
	}
	
	set auditRecord = ##class(cysnet.audit.util.AuditRecord).newRecord($this.%RequestHeader.SessionId)

	// Enviar la solicitud
	set tSC = ..sendHttpRequest(tURL, pRequest, .tProxyResponse, type, contentType, headerParams, params, .exito, .traza, .statusCode, .rspHeaders)

	//Si se ha producido un error, se incluye en el registro de auditoria
	if $$$ISERR(tSC){
		do auditRecord.error($System.Status.GetErrorText(tSC))
	}
	if ('exito){
		do auditRecord.error("Error in REST invocation")
	}	
	do auditRecord.generateAuditContentAPIRest(type,..%ClassName(1),pURL,params,headerParams,contentType,pRequest,statusCode,rspHeaders,tProxyResponse)
	do auditRecord.endRecord()
	k auditRecord
	
	if $$$ISERR(tSC) quit tSC

	// Parsear la respuesta
	set pProxyManager.exito = exito
	set pProxyManager.trace = traza
	set pProxyManager.statusCode = statusCode
	set pProxyManager.rspHeaders = rspHeaders
	
	set tSC = pProxyManager.getResponse(tProxyResponse)

	if (pProxyManager.response.exito = 0) {
		if (pProxyManager.response.trace.errors.Count() > 0) {
			set pProxyManager.response.trace.errors.GetAt(1).datos = ..addInfoToTrace(pProxyManager)
		}
	}
	
	quit tSC
}

Method sendHttpRequest(pURL As %String, pRequest As %RegisteredObject, ByRef pProxyResponse As %AbstractStream, type As %String, contentType As %String, headerParams As %ListOfObjects(ELEMENTTYPE="cysnet.rest.msg.struct.CampoValor") = "", params As %ListOfObjects(ELEMENTTYPE="cysnet.rest.msg.struct.CampoValor") = "", ByRef exito As %Boolean, ByRef traza As cysnet.rest.msg.struct.Trace, ByRef statusCode As %String = "", ByRef rspHeaders As %ListOfObjects(ELEMENTTYPE="cysnet.rest.msg.struct.CampoValor") = "") As %Status
{
	#dim sc As %Status = $$$OK
 	#dim httpReq as %Net.HttpRequest
 	#dim httpRsp as %Net.HttpResponse
 	#dim output As %ZEN.proxyObject
 	#dim i, pos As %Integer = 0
 	#dim listaParamsURL As %List = $lb()
 	
 	set httpReq = ##class(%Net.HttpRequest).%New()
	
	set exito = 1
	
	if ( (headerParams '= "")&&(headerParams.Count() > 0) ) {
		for i=1:1:headerParams.Count() {
			do httpReq.SetHeader(headerParams.GetAt(i).campo, headerParams.GetAt(i).valor)
		}
	}
	
	if ( (params '= "")&&(params.Count() > 0) ) {
		for i=1:1:params.Count() {
			if ( ($f(pURL, "{"_params.GetAt(i).campo_"}") > 0)||($f(pURL, ":"_params.GetAt(i).campo) > 0) ) {
				set $li(listaParamsURL, i) = params.GetAt(i).campo
			}
			set pURL = $Replace(pURL, "{"_params.GetAt(i).campo_"}", params.GetAt(i).valor)
			set pURL = $Replace(pURL, ":"_params.GetAt(i).campo, params.GetAt(i).valor)
		}
	}
	
	if (type = "GET") {
		if ( (params '= "")&&(params.Count() > 0)&&( ($ll(listaParamsURL) '= params.Count())||(listaParamsURL = $lb()) ) ) {
			if ($f(pURL,"?") = 0) {
				set pURL = pURL_"?"
			}
			for i=1:1:params.Count() {
				if ($lf(listaParamsURL, params.GetAt(i).campo) = 0) {
					set pURL = pURL_"&"_params.GetAt(i).campo_"="_params.GetAt(i).valor
				}
			}
		}
		
		if (..PrintLog) {
			$$$LOGASSERT("GET URL: "_pURL)
		}
		
		set sc = ..Adapter.SendFormDataURL(pURL, .httpRsp, "GET", httpReq, , )
		
		//set sc = ..Adapter.GetURL(pURL, .httpRsp, , )
		
	} elseif ( (type = "POST")||(type = "PUT")||(type = "PATCH") ) {
		if (..PrintLog) {
			$$$LOGASSERT("POST/PUT URL: "_pURL)
		}
		
		if ($l(contentType) > 0) {
			set httpReq.ContentType = contentType
		}
		
 		set tBody = ##class(%Stream.GlobalCharacter).%New()
 		
 		if ($IsObject(pRequest)) {
	 		if (pRequest.%ClassName(1) = "%Stream.GlobalCharacter") {
	 			// Si es un GlobalCharacterStream, copiar el contenido
	 			do tBody.CopyFrom(pRequest)
	 		} else {
	 			// Si es una request normal, convertirla a JSON:
	 			do ##class(cysnet.rest.util.JsonProvider).ObjectToJSONStream(pRequest, .tBody, "alotw")
	 		}
		}
 		
 		if (..PrintLog) {
 			$$$LOGASSERT("Request: "_$Char(10)_tBody.Read())
 		}
 		do tBody.Rewind()
 		
 		set sc = ..Adapter.SendFormDataURL(pURL, .httpRsp, type, httpReq, , tBody)
 		
	} elseif (type = "DELETE") {
		if (..PrintLog) {
			$$$LOGASSERT("DELETE URL: "_pURL)
		}
		set sc = ..Adapter.SendFormDataURL(pURL, .httpRsp, "DELETE", httpReq)
		
	} else {
		if (..PrintLog) {
			$$$LOGASSERT("URL: "_pURL)
		}
		quit $$$ERROR("HTTP method not valid: "_type)
	}
	
	if ($$$ISOK(sc)) {
		if ($IsObject(httpRsp)) {
			if (..PrintLog) {
				$$$LOGASSERT("StatusCode: "_httpRsp.StatusCode)
			}
			set statusCode = httpRsp.StatusCode
			set pProxyResponse = httpRsp.Data
			
			// Si el status code es >= 400, ha ocurrido un error
			if (httpRsp.StatusCode >= 400) {
				set exito = 0
			}
			
			if (httpRsp.Data.Size > 0) {
				if (..PrintLog) {
					$$$LOGASSERT("Response: "_$Char(10)_httpRsp.Data.Read())
				}
				do httpRsp.Data.Rewind()
			}
			set sc = ..getResponseHeaders(httpRsp, .rspHeaders)
			if ($$$ISERR(sc)) {
				set rsp = ##class(cysnet.rest.msg.RestResponse).%New()
				set rsp.exito = 0
				set rsp.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("RestManager", $System.Status.GetErrorText(sc))
				do ##class(cysnet.rest.util.JsonProvider).ObjectToJSONStream(rsp, .pProxyResponse)
			}
		// Si no hay respuesta, generar contenido vacío:
		} else {
			if (..PrintLog) {
				$$$LOGASSERT("Response: vacío")
			}
			set empty = ##class(%Stream.GlobalCharacter).%New()
			do empty.Write("{}")
			do ##class(cysnet.rest.util.JsonProvider).JSONStreamToObject(empty, .output)
			do ##class(cysnet.rest.util.JsonProvider).ObjectToJSONStream(output, .pProxyResponse)
		}
	
	} else {
		set exito = 0
		if ($IsObject(httpRsp)) {
			if (..PrintLog) {
				$$$LOGASSERT("StatusCode: "_httpRsp.StatusCode)
			}
			set statusCode = httpRsp.StatusCode
			
			set pProxyResponse = httpRsp.Data
			
			if (httpRsp.Data.Size > 0) {
				if (..PrintLog) {
					$$$LOGASSERT("Response: "_$Char(10)_httpRsp.Data.Read())
				}
				do httpRsp.Data.Rewind()
			}
			set sc = ..getResponseHeaders(httpRsp, .rspHeaders)
			if ($$$ISERR(sc)) {
				set rsp = ##class(cysnet.rest.msg.RestResponse).%New()
				set rsp.exito = 0
				set rsp.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("RestManager", $System.Status.GetErrorText(sc))
				do ##class(cysnet.rest.util.JsonProvider).ObjectToJSONStream(rsp, .pProxyResponse)
			}
		} else {
			set statusCode = "500 Internal Error"
			set traza = ##class(cysnet.rest.msg.struct.Trace).generarTraza("RestManager", $System.Status.GetErrorText(sc))
		
			set rsp = ##class(cysnet.rest.msg.RestResponse).%New()
			set rsp.exito = exito
			set rsp.trace = traza
			
			do ##class(cysnet.rest.util.JsonProvider).ObjectToJSONStream(rsp, .pProxyResponse)
		}
		// Devolver OK para que no salte error de Ensemble
		set sc = $$$OK
	}
    
    quit sc
}

ClassMethod getResponseHeaders(httpRsp As %Net.HttpResponse, Output headers As %ListOfObjects) As %Status
{
	#dim sc As %Status = $$$OK

	try {
		set headers = ##class(%ListOfObjects).%New()

		set hName = ""
		for {
			set hName = httpRsp.GetNextHeader(hName)
			quit:hName=""

			set hValue = httpRsp.GetHeader(hName)
			do headers.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew(hName, hValue))
		}

	} catch (err) {
		// Si ha ocurrido un error, crear el objeto Status:
		if (err.%ClassName(1)="common.err.exception") && ($$$ISERR(err.status)) {
      		set sc = err.status
    	} else {
      		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
  		}
	}

	quit sc
}

ClassMethod addInfoToTrace(proxyManager As cysnet.rest.proxy.Interface) As %String
{
	#dim datos As %String = ""

	try {
		set datos = "StatusCode: "_proxyManager.statusCode
		set datos = datos_$Char(10)_"URL: "_proxyManager.url
		if (proxyManager.rspHeaders.Count() > 0) {
			set datos = datos_$Char(10)_"ResponseHeaders:"
			for i=1:1:proxyManager.rspHeaders.Count() {
				set datos = datos_$Char(10)_$Char(9)_proxyManager.rspHeaders.GetAt(i).campo_": "_proxyManager.rspHeaders.GetAt(i).valor
			}
		}
	} catch (err) {

	}
	
	return datos
}

/// Override this method to provide custom error handling. Return 0 means skip standard AlertOnError behavior.
Method OnError(ByRef pStatus As %Status) As %Boolean
{
	// Devolver 0 para que no salte alerta. La alerta saltará en OnFailureTimeout
	Quit 0
}

/// Override this method to provide custom handling of retry / failure timeout.<p/>
/// Set ..Retry=1 to override normal error return and re-evaluate flag properties.<p/>
/// Return 0 to skip further (default) FailureTimeout processing, 1 to perform default processing.
Method OnFailureTimeout(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent, ByRef pSC As %Status) As %Boolean
{
	// Enviar la alerta solo en este punto y si está activo Alerta si error:
	if (..AlertOnError) {
		do ..SendAlert(##class(Ens.AlertRequest).%New($LB(..%ConfigName,$$$StatusDisplayString(pSC))))
	}
	
	quit 1
}

}
