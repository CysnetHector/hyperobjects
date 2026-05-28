Include Ensemble

Class cysnet.audit.util.AuditRecord Extends %RegisteredObject
{

Parameter GLAUDIT = "^cysnet.audit.config";

Parameter GLAUDITCURRENT = "^cysnet.audit.current";

Parameter GLAUDITRECORDS = "^cysnet.audit.records";

Parameter GLAUDITERRORS = "^cysnet.audit.errors";

Parameter AUDITENABLED = "enabled";

Parameter TYPEAPI = "API";

Parameter TYPEDTL = "DTL";

Parameter TYPEHL7 = "HL7";

Parameter TYPEAPISOAP = "SOAP";

Parameter TYPEAPIREST = "REST";

Parameter VERBGET = "GET";

Parameter VERBPOST = "POST";

Parameter VERBPUT = "PUT";

Parameter VERBDELETE = "DELETE";

Parameter MESSAGEREQUEST = "IncludeRequest";

Parameter MESSAGERESPONSE = "IncludeResponse";

Parameter INCLUDEHEADERS = "IncludeHeaders";

Parameter HL7IN = "IN";

Parameter HL7OUT = "OUT";

Parameter INCLUDECONTENT = "IncludeContent";

Parameter HL7CLASSNAME = "EnsLib.HL7.Message";

Property start As %String;

Property end As %String;

Property sessionId As %String;

Property status As %Boolean;

Property error As %String;

Property type As %Integer;

Property content As %DynamicObject;

/// Normaliza el texto
ClassMethod normalizeTxt(txt As %String) As %String
{
    // Convierte el texto a minúsculas
    return $ZCONVERT(txt,"L")
}

/// Método que comprueba el estado de la auditoría atendiendo a la clave del elemento indicaca
ClassMethod checkAudit(keys...) As %Boolean
{
    set global = ..#GLAUDIT
    set enabled = ##class(cysnet.utils.HelperGlobals).getGlobalValue(global, keys...)
    return $CASE(enabled, 1:1, 0:0, :0)
}

ClassMethod newRecord(sessionId As %String = "") As cysnet.audit.util.AuditRecord
{
    s obj = ##class(cysnet.audit.util.AuditRecord).%New()
    s obj.start = $ZTIMESTAMP
    s obj.status = 1
    s obj.error = ""
    //La sessionid se puede obtener tanto con $GET($$$JobSessionId,"") como con $this.%RequestHeader.SessionId
    s obj.sessionId = ""_sessionId //Si no concatenamos un "", se guarda como %Integer
    //s ^cysnet.audit.logpruebas($ZDATETIME($ZTIMESTAMP,3,1,3)) = "" 
    s obj.content = ##class(%DynamicObject).%New()
    return obj
}

ClassMethod source(source As %String) As %Status
{
    //Esto en principio sera mas "global" al bucle del core
    /*
        source
                paso-1 | paso-2 | paso-3 | paso-4
    */
    do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLAUDITCURRENT,"source",source)
    return $$$OK
}

ClassMethod step(step As %String) As %Status
{
    //Se establece desde el SyncProcess
    /*
        step
                paso-1 | paso-2 | paso-3 | paso-4
    */
    do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLAUDITCURRENT,"step",step)
    //Al cambiar de paso, limpiamos los additionalData, por si acaso
    do ..clearAdditionalData()
    return $$$OK
}

ClassMethod additionalData(idTransaction As %String = "", resource As %String = "", resourceId As %String = "") As %Status
{
    //Se establecen desde el SyncProcess
    do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLAUDITCURRENT,"idTransaction",idTransaction)
    do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLAUDITCURRENT,"resource",resource)
    do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLAUDITCURRENT,"resourceId",resourceId)
    return $$$OK
}

ClassMethod clearAdditionalData() As %Status
{
    //Borrar los datos adicionales del global de valores CURRENT
    do ##class(cysnet.utils.HelperGlobals).removeGlobalValue(..#GLAUDITCURRENT,"idTransaction")
    do ##class(cysnet.utils.HelperGlobals).removeGlobalValue(..#GLAUDITCURRENT,"resource")
    do ##class(cysnet.utils.HelperGlobals).removeGlobalValue(..#GLAUDITCURRENT,"resourceId")
    return $$$OK
}

Method error(error As %String) As %Status
{
    set ..status = 0
    set ..error = error
    return $$$OK
}

Method contentAPI(content As %DynamicObject) As %Status
{
    /*
        content
                Si type = 1: api → Información de las API’s
                Si type = 2: dtl → Información de transformaciones
                Si type = 3: hl7 → Información de mensajería HL7    
    */
    /*
        type
                1: api | 2: dtl | 3: hl7
    */
    set ..type = ..#TYPEAPI
    set ..content = content //.%ToJSON()
    return $$$OK
}

Method contentDTL(content As %DynamicObject) As %Status
{
    /*
        content
                Si type = 1: api → Información de las API’s
                Si type = 2: dtl → Información de transformaciones
                Si type = 3: hl7 → Información de mensajería HL7    
    */
    /*
        type
                1: api | 2: dtl | 3: hl7
    */
    set ..type = ..#TYPEDTL
    set ..content = content //.%ToJSON()
    return $$$OK
}

Method endRecord() As %Status
{
    ;Para determinar si hay que insertar el registro actual, bastaría con comprobar el contenido del campo auditRecord.type,
    ;ya que, si la auditoría no está habilitada, ese campo no se informa, al igual que ocurre con el campo auditRecord.content
    if (..type = "") {
        return $$$OK
    }   
     
    try {
        //Finalizar/insertar el registro actual
        set ..end = $ZTIMESTAMP
        //duration

        s starthorolog = ..start
        s endhorolog = ..end

        s startStr = $ZDATETIME(starthorolog,3,1,3)
        s endStr = $ZDATETIME(endhorolog,3,1,3)
        s duration = ##class(%SYSTEM.SQL.Functions).DATEDIFF("s",starthorolog,endhorolog)


        /*
            start
            end
            duration
            type
                    1: api | 2: dtl | 3: hl7
            sessionId
            additionalData
                idTransaction
                step
                        paso-1 | paso-2 | paso-3 | paso-4
                resource
                resourceId
            status
                    true → Todo ha ido bien
                    false → Ha ocurrido un error
            error
            content
                    Si type = 1: api → Información de las API’s
                    Si type = 2: dtl → Información de transformaciones
                    Si type = 3: hl7 → Información de mensajería HL7    
        */

        #dim registro As %DynamicObject
        s registro = ##class(%DynamicObject).%New()
        s registro.start = startStr
        s registro.end = endStr
        s registro.duration = duration
        s registro.type = ..type
        s registro.sessionId = ..sessionId
        s registro.additionalData = {}
        s registro.additionalData.step = ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLAUDITCURRENT,"step")
        // Añadir solo si tienen valor:
        s idT = ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLAUDITCURRENT,"idTransaction")
        if (idT '= "") { s registro.additionalData.idTransaction = idT }
        s res = ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLAUDITCURRENT,"resource")
        if (res '= "") { s registro.additionalData.resource = res }
        s resID = ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLAUDITCURRENT,"resourceId")
        if (resID '= "") { s registro.additionalData.resourceId = resID }
        #; s registro.additionalData.target = ""           //Lo podria establecer el SyncProcess...
        s registro.status = ..status
        s registro.error = ..error
        s registro.content = ..content

        do ..insertAuditRecord(registro)
    } catch (err) {
        //Logueamos si se produce una exception
        do ..logAuditException("endRecord",err)
	}

    return $$$OK
}

/*
        sessionId
        idTransaction
        target
        resource
        resourceId
    */
Method insertAuditRecord(record As %DynamicObject) As %Status
{
	try {
        s informationToInsert = record.%ToJSON()

        // Añadir json al global temporal
        s key = $INCREMENT(@..#GLAUDITRECORDS)
        do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLAUDITRECORDS,key,informationToInsert)

    } catch (err) {
        //Logueamos si se produce una exception
        do ..logAuditException("insertarRegistroAuditoria",err)
	}
}

Method generateAuditContentAPIRest(operation As %String, destinationClassName As %String, url As %String, paramsURL As %ListOfObjects(ELEMENTTYPE="cysnet.rest.msg.struct.CampoValor") = "", headerParams As %ListOfObjects(ELEMENTTYPE="cysnet.rest.msg.struct.CampoValor") = "", contentType As %String, pRequest As %RegisteredObject, statusCode As %String, rspHeaders As %ListOfObjects(ELEMENTTYPE="cysnet.rest.msg.struct.CampoValor") = "", pProxyResponse As %AbstractStream) As %Status
{
    #dim sc as %Status = $$$OK

    //El RestManager nos envia los datos sin convertir, este metodo extrae y convierte

    //Si la auditoria no esta activa, no se hace nada
    set procesar = ((..checkAudit(..#AUDITENABLED)) && (..checkAudit(..#TYPEAPI, ..#TYPEAPIREST)))
    ;$$$LOGINFO("Procesar ((..checkAudit(..#AUDITENABLED)) && (..checkAudit(..#TYPEAPI, ..#TYPEAPIREST))): "_procesar)
    if ('procesar) {
        return $$$OK
    }
    
    ;Se comprueba sin está habilitada la auditoría en función del tipo de operación
    set procesar = ..checkAudit(..#TYPEAPI, ..#TYPEAPIREST, operation)

    ;$$$LOGINFO("Procesar "_"operation"_": "_procesar)
    if ('procesar) {
        return $$$OK
    }

	try {
        //extraer el destination de la classname
        s destination = destinationClassName
        if ($F(destinationClassName,".")>1){
            s destination = $P(destinationClassName,".",2)
        }

        #dim paramsJSON As %DynamicObject = {}
        #dim requestHeaders As %DynamicObject = {}
        #dim request As %DynamicObject = {}
        #dim responseHeaders As %DynamicObject = {}
        #dim response As %DynamicObject = {}

        ;Informamos headers, request y response en función de si están habilitados o no en la auditoría
        if (..checkAudit(..#TYPEAPI, ..#TYPEAPIREST, ..#INCLUDEHEADERS)) {
            s requestHeaders = ..convertListToJSON(headerParams) //headerParams
            s responseHeaders = ..convertListToJSON(rspHeaders) //rspHeaders
        }
        if (..checkAudit(..#TYPEAPI, ..#TYPEAPIREST, operation, ..#MESSAGEREQUEST)) {
            s request = ..convertRequestToJSON(pRequest) //pRequest
        }
        if (..checkAudit(..#TYPEAPI, ..#TYPEAPIREST, operation, ..#MESSAGERESPONSE)) {
            s response = ..convertResponseToJSON(pProxyResponse) //pProxyResponse
        }

        s paramsJSON = ..convertListToJSON(paramsURL) //paramsURL

        //Generamos el content con los datos obtenidos de la API
        #dim contentAPI As %DynamicObject
        s contentAPI = ##class(%DynamicObject).%New()

        s contentAPI.apiType = ..#TYPEAPIREST
        s contentAPI.operation = operation
        s contentAPI.destination = ..normalizeTxt(destination)
        s contentAPI.url = url
        s contentAPI.params = paramsJSON
        s contentAPI.requestHeaders = requestHeaders
        s contentAPI.contentType = contentType
        s contentAPI.request = request
        s contentAPI.statusCode = statusCode
        s contentAPI.responseHeaders = responseHeaders
        s contentAPI.response = response

        //Una vez generados los datos del content, se incluye al registro de auditoria
        do ..contentAPI(contentAPI)

    } catch (err) {
        //Logueamos si se produce una exception
        do ..logAuditException("generateAuditContentAPIRest",err)
	}    

    return $$$OK
}

Method generateAuditContentAPISoap(destinationClassName As %String, webClient As %SOAP.WebClient, requestHeaders As %DynamicObject, pRequest As Ens.Request) As %Status
{
    #dim sc as %Status = $$$OK

    //Si la auditoria no esta activa, no se hace nada
    set procesar = ((..checkAudit(..#AUDITENABLED)) && ..checkAudit(..#TYPEAPI, ..#TYPEAPISOAP))
    if ('procesar) {    
        return $$$OK
    }   

	try {
        //extraer el destination de la classname
        s destination = destinationClassName
        if ($F(destinationClassName,".")>1){
            s destination = $P(destinationClassName,".",2)
        }

        #dim paramsJSON As %DynamicObject = {}
        #dim request As %String = ""
        #dim reqHeaders As %DynamicObject = {}
        #dim responseHeaders As %DynamicObject = {}
        #dim response As %String = ""

         ;Informamos request headers en función de si están habilitados o no en la auditoría
        if (..checkAudit(..#TYPEAPI, ..#TYPEAPISOAP, ..#INCLUDEHEADERS)) {
            s reqHeaders = requestHeaders
        }
         ;Informamos request y responde en función de si están habilitados o no en la auditoría
        if (..checkAudit(..#TYPEAPI, ..#TYPEAPISOAP, ..#MESSAGEREQUEST)) {
            s request = ..convertXMLToString(pRequest) //pRequest
        }
        if (..checkAudit(..#TYPEAPI, ..#TYPEAPISOAP, ..#MESSAGERESPONSE)) {
            // Si tenemos respuesta, la leemos:
            if ( ($IsObject(webClient.HttpResponse.Data))&&(webClient.HttpResponse.Data.Size > 0) ) {
                // Ponemos el cursor del Data al comienzo, por si acaso:
                do webClient.HttpResponse.Data.Rewind()
                // Leemos todo el contenido del Data de la response:
                s response = webClient.HttpResponse.Data.Read(webClient.HttpResponse.Data.Size)

            // Sino, si tenemos SoapFault, lo ponemos como respuesta:
            } elseif ($IsObject(webClient.SoapFault)) {
                s response = ..convertXMLToString(webClient.SoapFault)
            }
        }

        //Generamos el content con los datos obtenidos de la API
        #dim contentAPI As %DynamicObject
        s contentAPI = ##class(%DynamicObject).%New()

        s contentAPI.apiType = ..#TYPEAPISOAP
        s contentAPI.operation = ..#VERBPOST
        s contentAPI.destination = ..normalizeTxt(destination)
        s contentAPI.url = webClient.Location
        s contentAPI.params = paramsJSON
        s contentAPI.requestHeaders = reqHeaders
        s contentAPI.contentType = webClient.HttpRequest.ContentType
        s contentAPI.request = request
        s contentAPI.statusCode = webClient.HttpResponse.StatusCode
        s contentAPI.responseHeaders = responseHeaders
        s contentAPI.response = response
        
        //Una vez generados los datos del content, se incluye al registro de auditoria
        do ..contentAPI(contentAPI)

    } catch (err) {
        //Logueamos si se produce una exception
        do ..logAuditException("generateAuditContentAPISoap",err)
	}    

    return $$$OK
}

ClassMethod convertExceptionToJSON(exception As %Exception.SystemException) As %String
{
    s resultado = {}
    if ($ISOBJECT(exception)){
        s resultado.Code = exception.Code
        s resultado.Name = exception.Name
        s resultado.Location = exception.Location
        s resultado.Data = exception.Data
        //s resultado.InnerException = exception.InnerException
    }
    return resultado.%ToJSON()
}

ClassMethod logAuditException(method As %String, exception As %Exception.SystemException)
{
    s key = $ZTIMESTAMP
    if ($ISOBJECT(exception)){
        do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLAUDITERRORS,key,method,..convertExceptionToJSON(exception))
    }
}

ClassMethod convertListToJSON(params As %ListOfObjects(ELEMENTTYPE="cysnet.rest.msg.struct.CampoValor") = "") As %DynamicObject
{
    #dim resultado As %DynamicObject
    s resultado = ##class(%DynamicObject).%New()
	try {
        if ( (params '= "")&&(params.Count() > 0) ) {
            for i=1:1:params.Count() {
                //incluir en el json la pareja "campo":"valor"
                do resultado.%Set(params.GetAt(i).campo,params.GetAt(i).valor)
            }
        }
    } catch (err) {
        //Logueamos si se produce una exception
        do ..logAuditException("convertListToJSON",err)
	}
    return resultado
}

ClassMethod convertRequestToJSON(pRequest As %RegisteredObject) As %DynamicObject
{
    set resultado = {}
	try {
        set tBody = ##class(%Stream.GlobalCharacter).%New()
        if ($IsObject(pRequest)) {
            if (pRequest.%ClassName(1) = "%Stream.GlobalCharacter") {
                // Si es un GlobalCharacterStream, copiar el contenido
                do tBody.CopyFrom(pRequest)
            } else {
                // Si es una request normal, convertirla a un Stream JSON:
                do ##class(cysnet.rest.util.JsonProvider).ObjectToJSONStream(pRequest, .tBody, "alotw")
            }
        }
        do tBody.Rewind()
        set resultado = {}.%FromJSON(tBody.Read())
    } catch (err) {
        //Logueamos si se produce una exception
        do ..logAuditException("convertRequestToJSON",err)
	}

    return resultado
}

ClassMethod convertResponseToJSON(pProxyResponse As %AbstractStream) As %DynamicObject
{
    set resultado = {}
	try {
        if ($IsObject(pProxyResponse)) {
            if (pProxyResponse.Size > 0) {
                do pProxyResponse.Rewind()
                set resultado = {}.%FromJSON(pProxyResponse)
            }
        }
    } catch (err) {
        //Logueamos si se produce una exception
        do ..logAuditException("convertResponseToJSON",err)
	}
    return resultado
}

ClassMethod convertXMLToString(object As %RegisteredObject) As %String
{
    set resultado = ""
	try {
        set writer=##class(%XML.Writer).%New()
        set sc = writer.OutputToString()
        set sc = writer.RootObject(object)
        set resultado = writer.GetXMLString()
    } catch (err) {
        //Logueamos si se produce una exception
        do ..logAuditException("convertXMLToString",err)
	}

    return resultado
}

Method generateAuditContentDTL(origin As %String, entity As %String, destination As %String, dtl As %String, contentO As %DynamicObject, contentD As %String) As %Status
{
    #dim sc as %Status = $$$OK
    
    //Si la auditoria no esta activa, no se hace nada
    set procesar = ((..checkAudit(..#AUDITENABLED)) && (..checkAudit(..#TYPEDTL)))
    ;$$$LOGINFO("Procesar dtl: "_procesar)
    if ('procesar) {
        return $$$OK
    }

    /*
        origin
        destination
        contentO
        contentD
        changesD
                de momento, no
    */
    try{

        //Generamos el content con los datos obtenidos de la DTL
        #dim contentDTL As %DynamicObject
        s contentDTL = ##class(%DynamicObject).%New()

        s contentDTL.origin = normalizeTxt(origin)
        if (destination = ..#HL7CLASSNAME) {
            set destination = ..#TYPEHL7
        }
        s contentDTL.destination = ..normalizeTxt(destination)
        s contentDTL.entity = entity
        s contentDTL.dtl = dtl
        s contentDTL.contentO = contentO
        if ($ClassName(contentD) = ..#HL7CLASSNAME) {
            set contentHL7 = ##class(%Stream.TmpCharacter).%New()
            do contentD.OutputToLibraryStream(contentHL7)
            s contentDTL.contentD = contentHL7.Read(contentHL7.Size)
        } else {
            s contentDTL.contentD = contentD
        }

        //Una vez generados los datos del content, se incluye al registro de auditoria
        do ..contentDTL(contentDTL)

    } catch (err) {
        //Logueamos si se produce una exception
        do ..logAuditException("generateAuditContentDTL",err)
	}

    return $$$OK
}

Method generateAuditContentHL7IN(source As %String, filename As %String, msgName As %String, msgContent As %Stream.TmpCharacter) As %Status
{
    //Si la auditoria no esta activa, no se hace nada
    set procesar = ((..checkAudit(..#AUDITENABLED)) && (..checkAudit(..#TYPEHL7)) && (..checkAudit(..#TYPEHL7, ..#HL7IN)))
    ;$$$LOGINFO("Procesar dtl: "_procesar)
    if ('procesar) {
        return $$$OK
    }

    return ..generateAuditContentHL7(..#HL7IN, source, filename, msgName, msgContent)
}

Method generateAuditContentHL7OUT(source As %String, filename As %String, msgName As %String, msgContent As %Stream.TmpCharacter) As %Status
{
    //Si la auditoria no esta activa, no se hace nada
    set procesar = ((..checkAudit(..#AUDITENABLED)) && (..checkAudit(..#TYPEHL7)) && (..checkAudit(..#TYPEHL7, ..#HL7OUT)))
    ;$$$LOGINFO("Procesar dtl: "_procesar)
    if ('procesar) {
        return $$$OK
    }

    return ..generateAuditContentHL7(..#HL7OUT, source, filename, msgName, msgContent)
}

Method generateAuditContentHL7(destination As %String, source As %String, filename As %String, msgName As %String, msgContent As %Stream.TmpCharacter) As %Status
{
    #dim sc as %Status = $$$OK
    
    //Si la auditoria no esta activa, no se hace nada
    set procesar = ((..checkAudit(..#AUDITENABLED)) && (..checkAudit(..#TYPEHL7)) && (..checkAudit(..#TYPEHL7, destination)))
    ;$$$LOGINFO("Procesar dtl: "_procesar)
    if ('procesar) {
        return $$$OK
    }

    /*
        origin
        destination -> IN|OUT
        filename
        msgName
        msgContent
    */

    try {
        //Generamos el content con los datos del HL7
        #dim contentHL7 As %DynamicObject
        s contentHL7 = ##class(%DynamicObject).%New()

        s contentHL7.origin = ..normalizeTxt(source)
        s contentHL7.destination = destination
        s contentHL7.filename = filename
        s contentHL7.msgName = msgName
        if (..checkAudit(..#TYPEHL7, destination, ..#INCLUDECONTENT)) {
            s contentHL7.msgContent = msgContent.Read(msgContent.Size)
        }
        
        //Una vez generados los datos del content, se incluye al registro de auditoria
        do ..contentHL7(contentHL7)

    } catch (err) {
        //Logueamos si se produce una exception
        do ..logAuditException("generateAuditcontentHL7",err)
	}

    return $$$OK
}

Method contentHL7(content As %DynamicObject) As %Status
{
    /*
        content
                Si type = 1: api → Información de las API’s
                Si type = 2: dtl → Información de transformaciones
                Si type = 3: hl7 → Información de mensajería HL7    
    */
    /*
        type
                1: api | 2: dtl | 3: hl7
    */
    set ..type = ..#TYPEHL7
    set ..content = content //.%ToJSON()
    return $$$OK
}

}
