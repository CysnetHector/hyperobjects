Include Ensemble

Class cysnet.hyperobjects.bo.core.HyperObjectsCore Extends cysnet.hyperobjects.util.Parameters
{

ClassMethod getChanges(pRequest As cysnet.syncEngine.core.msg.GetChangesRequest, Output pResponse As cysnet.syncEngine.core.msg.GetChangesResponse, bo As cysnet.hyperobjects.bo.HyperObjects) As %Status
{
	#dim sc As %Status = $$$OK
	#dim lastUpdate As %TimeStamp
	#dim infoRecursos As %List = $lb()
	#dim i As %Integer = 1
	
	set pResponse = ##class(cysnet.syncEngine.core.msg.GetChangesResponse).%New()
	set pResponse.exito = 1
	set pResponse.listaCambios = ##class(%ListOfObjects).%New()
	set pResponse.total = 0

	try {
		// Obtener recursos de HyperObjects:
		set infoRecursos = ##class(cysnet.syncEngine.core.data.Entidad).obtenerEntidadesMaestras()
		
		for i=1:1:$ll(infoRecursos) {
			// Montar el path del recurso en base al nombre de éste y el filtro (si tiene):
			set recurso = $li($li(infoRecursos,i),1)
			set filtro = $li($li(infoRecursos,i),2)
			
			// Si no hay registro en el global para lastUpdate-recurso, obtener los cambios desde ahora:
			if ('##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBINFOHYPEROBJECTS, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:""))) {
				do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBINFOHYPEROBJECTS, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:""), $ZDT($H,3,7))
			}
			set lastUpdate = ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBINFOHYPEROBJECTS, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:""))

			if (bo.ResetLastUpdate '= "") {
				set lastUpdate = $ZDT($ZDTH(bo.ResetLastUpdate,3,1),3,7)
				do ##class(cysnet.utils.HelperGlobals).removeGlobal(..#GLBHYPEROBJECTS)
			}
			$$$LOGWARNING("Buscar cambios de "_recurso_$s(filtro'="":"?"_filtro,1:"")_" desde "_lastUpdate)

			// Guardar siempre el lastId antes de la ejecución, por si hay que resetearlo en ProcesoSync:
			do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBINFOHYPEROBJECTS, "prevUpdate", recurso_$s(filtro'="":"?"_filtro,1:""),
			   ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBINFOHYPEROBJECTS, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:"")))

			set sc = ..buscarCambios(pRequest.codConector, recurso, filtro, "/"_recurso_$s(filtro'="":"?"_filtro_"&",1:"?")_"_lastUpdated=gt"_lastUpdate_"&_sort=_lastUpdated", .pResponse, bo)
			
			quit:pResponse.exito=0
			quit:$$$ISERR(sc)
		}
		
		if (pResponse.listaCambios.Count() > 0) {
			set pResponse.listaCambios = ..ordenarCambios(pResponse.listaCambios)
		}
		set pResponse.total = pResponse.listaCambios.Count()

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "Error en getChanges: "_$System.Status.GetErrorText(sc))
	}
	
	quit $$$OK
}

ClassMethod search(pRequest As cysnet.hyperobjects.msg.SearchRequest, Output pResponse As cysnet.hyperobjects.msg.SearchResponse, bo As cysnet.hyperobjects.bo.HyperObjects) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.hyperobjects.proxy.Search
	#dim headerParams As %ListOfObjects
	
	set pResponse = ##class(cysnet.hyperobjects.msg.SearchResponse).%New()
	set pResponse.exito = 1
	
	try {
		if (pRequest.url = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "No se ha especificado URL")

		} else {
			set proxyManager = ##class(cysnet.hyperobjects.proxy.Search).%New()
			
			set headerParams = ##class(%ListOfObjects).%New()
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/fhir+json"))
			
			set sc = bo.runMethod(proxyManager, "", pRequest.url, "GET", "application/fhir+json;charset=UTF-8", headerParams)
			if ($$$ISOK(sc)) {
				set pResponse = proxyManager.response
			}
			
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "Error en search: "_$System.Status.GetErrorText(sc))
	}
	
	quit $$$OK
}

ClassMethod get(pRequest As cysnet.hyperobjects.msg.GetRequest, Output pResponse As cysnet.hyperobjects.msg.GetResponse, bo As cysnet.hyperobjects.bo.HyperObjects) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.hyperobjects.proxy.Get
	#dim headerParams As %ListOfObjects
	
	set pResponse = ##class(cysnet.hyperobjects.msg.GetResponse).%New()
	set pResponse.exito = 1
	
	try {
		if (pRequest.url = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "No se ha especificado URL")

		} else {
			set proxyManager = ##class(cysnet.hyperobjects.proxy.Get).%New()
			
			set headerParams = ##class(%ListOfObjects).%New()
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/fhir+json"))
			
			set sc = bo.runMethod(proxyManager, "", pRequest.url, "GET", "application/fhir+json;charset=UTF-8", headerParams)
			if ($$$ISOK(sc)) {
				set pResponse = proxyManager.response
			}
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "Error en get: "_$System.Status.GetErrorText(sc))
	}
	
	quit $$$OK
}

ClassMethod upsert(pRequest As cysnet.hyperobjects.msg.UpsertRequest, Output pResponse As cysnet.hyperobjects.msg.UpsertResponse, bo As cysnet.hyperobjects.bo.HyperObjects) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.rest.proxy.Rest
	#dim headerParams As %ListOfObjects
	#dim rspRest As cysnet.rest.msg.RestResponse
	
	set pResponse = ##class(cysnet.hyperobjects.msg.UpsertResponse).%New()
	set pResponse.exito = 1
	
	try {
		if (pRequest.url = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "No se ha especificado URL")

		} else {
			set proxyManager = ##class(cysnet.rest.proxy.Rest).%New()
			
			set headerParams = ##class(%ListOfObjects).%New()
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/fhir+json"))
			
			set sc = bo.runMethod(proxyManager, pRequest.body, pRequest.url, "PUT", "application/fhir+json;charset=UTF-8", headerParams)
			if ($$$ISOK(sc)) {
				set rspRest = proxyManager.response
				
				set pResponse.exito = rspRest.exito
				set pResponse.trace = rspRest.trace
				set pResponse.statusCode = rspRest.statusCode

				// Si tenemos cabeceras en la respuesta, vamos a buscar la cabecera LOCATION:
				if (rspRest.rspHeaders.Count() > 0) {
					set found=0
					for i=1:1:rspRest.rspHeaders.Count() {
						if (rspRest.rspHeaders.GetAt(i).campo = "LOCATION") {
							set pResponse.resourceURL = rspRest.rspHeaders.GetAt(i).valor
							set found=1
						}
						quit:found=1
					}
				}
			}
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "Error en upsert: "_$System.Status.GetErrorText(sc))
	}
	
	quit $$$OK
}

ClassMethod send(pRequest As cysnet.hyperobjects.msg.SendRequest, Output pResponse As cysnet.hyperobjects.msg.SendResponse, bo As cysnet.hyperobjects.bo.HyperObjects) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.rest.proxy.Rest
	
	set pResponse = ##class(cysnet.hyperobjects.msg.SendResponse).%New()
	set pResponse.exito = 1
	
	try {
		if (pRequest.url = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "No se ha especificado URL")

		} elseif (pRequest.verb = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "No se ha especificado verbo")
			
		} else {
			set proxyManager = ##class(cysnet.rest.proxy.Rest).%New()
			
			set sc = bo.runMethod(proxyManager, pRequest.body, pRequest.url, pRequest.verb, "application/fhir+json", pRequest.headerParams)
			if ($$$ISOK(sc)) {
				set pResponse = proxyManager.response
			}
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "Error en send: "_$System.Status.GetErrorText(sc))
	}
	
	quit $$$OK
}

ClassMethod buscarCambios(codConector As %String, recurso As %String, filtro As %String, url As %String, Output pResponse As cysnet.syncEngine.core.msg.GetChangesResponse, bo As cysnet.hyperobjects.bo.HyperObjects) As %Status
{
	#dim sc As %Status = $$$OK
	#dim i, j As %Integer = 1
	#dim reqSearch As cysnet.hyperobjects.msg.SearchRequest
	#dim rspSearch As cysnet.hyperobjects.msg.SearchResponse
	#dim insertChange As %Boolean = 0
	#dim action, finalContent As %String = ""

	try {
		set reqSearch = ##class(cysnet.hyperobjects.msg.SearchRequest).%New()
		set reqSearch.url = url

		set sc = ..search(reqSearch, .rspSearch, bo)
		if ($$$ISOK(sc)) {
			set pResponse.exito = rspSearch.exito
			set pResponse.trace = rspSearch.trace
			
			if (pResponse.exito = 1) {
				// Si hay cambios:
				if (rspSearch.total > 0)&&(rspSearch.entry.Count() > 0) {
					// Añadir a la lista final de cambios:
					for j=1:1:rspSearch.entry.Count() {
						// Si no hay registro en el global para HO.<recurso>, registrarlo como nuevo:
						set hayDatos =  ##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBPREFIX_codConector, recurso, rspSearch.entry.GetAt(j).id)

						set action = "-"
						set insertChange = 0

						// Si hay datos, obtener la última versión leída, y marcarlo como Update; sino, marcarlo como Insert:
						if (hayDatos > 0) {
							set lastVersionId = ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBPREFIX_codConector, recurso, rspSearch.entry.GetAt(j).id)

							if (lastVersionId '= rspSearch.entry.GetAt(j).versionId)||(bo.ResetLastUpdate '= "") {
								set action = "U"
								set insertChange = 1

								$$$LOGINFO(recurso_"/"_rspSearch.entry.GetAt(j).id_": prev: "_lastVersionId_", ahora: "_rspSearch.entry.GetAt(j).versionId)

								set sc = ..buscarDiferencias(rspSearch.entry.GetAt(j).content, recurso, rspSearch.entry.GetAt(j).id, lastVersionId, .result, bo)
								quit:$$$ISERR(sc)

								// Si no hay contenido, no insertar:
								if (result.%Size() = 0) {
									set insertChange = 0

								} else {
									set finalContent = result.%ToJSON()
								}
							}
						} else {
							set action = "I"
							set insertChange = 1
							set finalContent = rspSearch.entry.GetAt(j).content.Read()
						}

						if (insertChange = 1) {
							set newC = ##class(cysnet.syncEngine.core.msg.struct.Cambio).%New()
							set newC.origen = codConector
							set newC.fecha = rspSearch.entry.GetAt(j).lastUpdated
							set newC.idTransaccion = $System.Util.CreateGUID()
							set newC.entidad = rspSearch.entry.GetAt(j).resourceType
							set newC.claveDef = "*"
							set newC.tipoContenido = "HO"
							set newC.accion = action
							set newC.contenido = finalContent

							do pResponse.listaCambios.Insert(newC)
							set pResponse.total = pResponse.total + 1

							// Registrar en el global HO.<recurso> la última versión leída
							do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBPREFIX_codConector, recurso, rspSearch.entry.GetAt(j).id, rspSearch.entry.GetAt(j).versionId)

							// Guardar en un global todos los ID's leídos esta iteración:
							do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBINFOHYPEROBJECTS, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:""), $ZDT($ZDTH(rspSearch.entry.GetAt(j).lastUpdated,3,1),3,7))
						}
						
						k resource
						k newC
					}
				}

				if (rspSearch.nextLink '= "") {
					$$$LOGALERT("("_recurso_") Buscar recursivamente: "_rspSearch.nextLink)
					set sc = ..buscarCambios(codConector, recurso, filtro, rspSearch.nextLink, .pResponse, bo)
				}
			}
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "Error en buscarCambios: "_$System.Status.GetErrorText(sc))
	}

	quit sc
}

ClassMethod buscarDiferencias(content As %Stream.GlobalCharacter, recurso As %String, id As %String, prevVersionId As %String, Output result As %DynamicObject, bo As cysnet.hyperobjects.bo.HyperObjects) As %Status
{
	#dim sc As %Status = $$$OK
	#dim reqGet As cysnet.hyperobjects.msg.GetRequest
	#dim rspGet As cysnet.hyperobjects.msg.GetResponse	
	#dim mustReturn As %List = $lb("relationship")
	
	try {
		set reqGet = ##class(cysnet.hyperobjects.msg.GetRequest).%New()
		set reqGet.url = "/"_recurso_"/"_id_"/_history/"_prevVersionId

		set sc = ..get(reqGet, .rspGet, bo)
		if ($$$ISOK(sc)) {
			if (rspGet.exito = 1) {
				// Si hay elemento:
				if (rspGet.resource.resourceType '= "") {
					do rspGet.resource.content.Rewind()
					do content.Rewind()
					set objOri = ##class(%DynamicAbstractObject).%FromJSON(rspGet.resource.content.Read())
					set resource = ##class(%DynamicAbstractObject).%FromJSON(content.Read())
					
					set result = ##class(cysnet.syncEngine.core.util.JSONComparator).compareJSONObj(objOri, resource, 1, "", ..#COMPAREJSONIGNORE, ..#COMPAREJSONLISTKEYS)
					// Si hay diferencias, volver a obtener el resultado, pero con los campos obligatorios:
					if (result.%Size() > 0) {
						// Pasamos 0 a la propiedad "returnFullArray" para que devuelva, de un array, solo lo que ha cambiado:
						set result = ##class(cysnet.syncEngine.core.util.JSONComparator).compareJSONObj(objOri, resource, 0, ..#COMPAREJSONMANDATORY, "", ..#COMPAREJSONLISTKEYS, mustReturn)
					}
				} else {
					set result = resource
				}
			} else {
				set sc = $system.Status.Error($$$EnsErrGeneral,"Error en buscarDiferencias","",rspGet.trace.errors.GetAt(1).message)
			}
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	quit sc
}

ClassMethod ordenarCambios(listaCambios As %ListOfObjects(ELEMENTTYPE="cysnet.syncEngine.core.msg.struct.Cambio")) As %ListOfObjects
{
	#dim listaCambiosNew As %ListOfObjects = ##class(%ListOfObjects).%New()
	#dim i As %Integer = 1
	#dim fecha, entidad, idEnt = ""
	
	// Recorrer la lista de informes, comprobar el estado de la variable "leido"
	for i=1:1:listaCambios.Count() {
		set lista(listaCambios.GetAt(i).fecha, listaCambios.GetAt(i).entidad, listaCambios.GetAt(i).idTransaccion) = i
	}
	
	// Recorrer el global:
	set fecha = ""
	for {
		set fecha = $Order(lista(fecha),1)
		quit:fecha=""
		
		set entidad = ""
		for {
			set entidad = $Order(lista(fecha,entidad),1)
			quit:entidad=""
			
			set idEnt = ""
			for {
				set idEnt = $Order(lista(fecha,entidad,idEnt),1,i)
				quit:idEnt=""
				
				do listaCambiosNew.Insert(listaCambios.GetAt(i))
			}
		}
	}
	
	quit listaCambiosNew
}

}
