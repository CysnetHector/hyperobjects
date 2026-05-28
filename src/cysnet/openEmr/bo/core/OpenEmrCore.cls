Include Ensemble

/// Clase CORE para el manejo de métodos contra la API de OpenEMR
Class cysnet.openEmr.bo.core.OpenEmrCore Extends cysnet.hyperobjects.util.Parameters
{

/// Método para hacer el login en caso de que no haya token o haya caducado. Sirve para ser invocado desde cada método:
ClassMethod doLogin(Output pResponse As cysnet.syncEngine.core.msg.GenericResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim rspToken As cysnet.openEmr.msg.GetTokenResponse

	try {
		set sc = ..getToken(.rspToken, bo)

		if ($$$ISOK(sc)) {
			if (rspToken.exito = 1) {
				do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBOPENEMR, "token", rspToken.token)

			} else {
				set pResponse.exito = 0
				set pResponse.trace = rspToken.trace
			}
		} else {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.syncEngine.core.msg.struct.Trace).generarTraza("OpenEMR", "Error en doLogin 1: "_$System.Status.GetErrorText(sc))
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.syncEngine.core.msg.struct.Trace).generarTraza("OpenEMR", "Error en doLogin: "_$System.Status.GetErrorText(sc))
	}

	return $$$OK
}

/// Método que obtiene la lista de cambios. Si la sesión es inválida, genera de nuevo un token:
ClassMethod getChanges(pRequest As cysnet.syncEngine.core.msg.GetChangesRequest, Output pResponse As cysnet.syncEngine.core.msg.GetChangesResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	
	set pResponse = ##class(cysnet.syncEngine.core.msg.GetChangesResponse).%New()
	set pResponse.exito = 1
	
	try {
		if ('##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBOPENEMR, "token")) {
			$$$LOGWARNING("No hay token. Do login")
			set sc = ..doLogin(.pResponse, bo)
		}

		if (($$$ISOK(sc))&&(pResponse.exito = 1)) {
			set sc = ..getChangesOpenEmr(pRequest, .pResponse, bo)

			// Si se ha devuelto una traza de error de que la sesión no es válida, volver a hacer login y volver a hacer la llamada:
			if (($$$ISOK(sc))&&(pResponse.exito = 0)&&($IsObject(pResponse.trace))&&(pResponse.trace.errors.Count() = 1)&&($f(pResponse.trace.errors.GetAt(1).message, "401") > 0)) {
				$$$LOGWARNING("401. Do login")
				set pResponse = ##class(cysnet.syncEngine.core.msg.GetChangesResponse).%New()
				set pResponse.exito = 1
				set sc = ..doLogin(.pResponse, bo)
				if (($$$ISOK(sc))&&(pResponse.exito = 1)) {
					set sc = ..getChangesOpenEmr(pRequest, .pResponse, bo)
				}
			}
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.syncEngine.core.msg.struct.Trace).generarTraza("OpenEMR", "Error en getChanges: "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

/// Método que obtiene una entidad. Si la sesión es inválida, genera de nuevo un token:
ClassMethod getEntity(pRequest As cysnet.openEmr.msg.GetRequest, Output pResponse As cysnet.openEmr.msg.GetResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	
	set pResponse = ##class(cysnet.openEmr.msg.GetResponse).%New()
	set pResponse.exito = 1
	
	try {
		if ('##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBOPENEMR, "token")) {
			$$$LOGWARNING("No hay token. Do login")
			set sc = ..doLogin(.pResponse, bo)
		}

		if (($$$ISOK(sc))&&(pResponse.exito = 1)) {
			set sc = ..get(pRequest, .pResponse, bo)

			// Si se ha devuelto una traza de error de que la sesión no es válida, volver a hacer login y volver a hacer la llamada:
			if (($$$ISOK(sc))&&(pResponse.exito = 0)&&($IsObject(pResponse.trace))&&(pResponse.trace.errors.Count() = 1)&&($f(pResponse.trace.errors.GetAt(1).message, "401") > 0)) {
				$$$LOGWARNING("401. Do login")
				set pResponse = ##class(cysnet.openEmr.msg.GetResponse).%New()
				set pResponse.exito = 1
				set sc = ..doLogin(.pResponse, bo)
				if (($$$ISOK(sc))&&(pResponse.exito = 1)) {
					set sc = ..get(pRequest, .pResponse, bo)
				}
			}
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.syncEngine.core.msg.struct.Trace).generarTraza("OpenEMR", "Error en getEntity: "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

/// Método que crea o actualiza una entidad. Si la sesión es inválida, genera de nuevo un token:
ClassMethod upsertEntity(pRequest As cysnet.openEmr.msg.UpsertRequest, Output pResponse As cysnet.openEmr.msg.UpsertResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	
	set pResponse = ##class(cysnet.openEmr.msg.UpsertResponse).%New()
	set pResponse.exito = 1
	
	try {
		if ('##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBOPENEMR, "token")) {
			$$$LOGWARNING("No hay token. Do login")
			set sc = ..doLogin(.pResponse, bo)
		}

		if (($$$ISOK(sc))&&(pResponse.exito = 1)) {
			// Si no hay UUID, crear; si lo hay, actualizar
			if ($l(pRequest.uuid) <= 1) {
				set sc = ..post(pRequest, .pResponse, bo)
			} else {
				set sc = ..put(pRequest, .pResponse, bo)
			}

			// Si se ha devuelto una traza de error de que la sesión no es válida, volver a hacer login y volver a hacer la llamada:
			if (($$$ISOK(sc))&&(pResponse.exito = 0)&&($IsObject(pResponse.trace))&&(pResponse.trace.errors.Count() = 1)&&($f(pResponse.trace.errors.GetAt(1).message, "401") > 0)) {
				$$$LOGWARNING("401. Do login")
				set pResponse = ##class(cysnet.openEmr.msg.UpsertResponse).%New()
				set pResponse.exito = 1
				set sc = ..doLogin(.pResponse, bo)
				if (($$$ISOK(sc))&&(pResponse.exito = 1)) {
					// Si no hay UUID, crear; si lo hay, actualizar
					if ($l(pRequest.uuid) <= 1) {
						set sc = ..post(pRequest, .pResponse, bo)
					} else {
						set sc = ..put(pRequest, .pResponse, bo)
					}
				}
			}
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.syncEngine.core.msg.struct.Trace).generarTraza("OpenEMR", "Error en postEntity: "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

/// Método que elimina una entidad. Si la sesión es inválida, genera de nuevo un token:
ClassMethod deleteEntity(pRequest As cysnet.openEmr.msg.DeleteRequest, Output pResponse As cysnet.openEmr.msg.DeleteResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	
	set pResponse = ##class(cysnet.openEmr.msg.DeleteResponse).%New()
	set pResponse.exito = 1
	
	try {
		if ('##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBOPENEMR, "token")) {
			$$$LOGWARNING("No hay token. Do login")
			set sc = ..doLogin(.pResponse, bo)
		}

		if (($$$ISOK(sc))&&(pResponse.exito = 1)) {
			set sc = ..delete(pRequest, .pResponse, bo)

			// Si se ha devuelto una traza de error de que la sesión no es válida, volver a hacer login y volver a hacer la llamada:
			if (($$$ISOK(sc))&&(pResponse.exito = 0)&&($IsObject(pResponse.trace))&&(pResponse.trace.errors.Count() = 1)&&($f(pResponse.trace.errors.GetAt(1).message, "401") > 0)) {
				$$$LOGWARNING("401. Do login")
				set pResponse = ##class(cysnet.openEmr.msg.DeleteResponse).%New()
				set pResponse.exito = 1
				set sc = ..doLogin(.pResponse, bo)
				if (($$$ISOK(sc))&&(pResponse.exito = 1)) {
					set sc = ..delete(pRequest, .pResponse, bo)
				}
			}
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.syncEngine.core.msg.struct.Trace).generarTraza("OpenEMR", "Error en putEntity: "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

// *******************************************************************************************************************************************************************************

/// Método que solicita un nuevo token:
ClassMethod getToken(Output pResponse As cysnet.syncEngine.core.msg.GenericResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.openEmr.proxy.Token
	#dim headerParams As %ListOfObjects
	
	set pResponse = ##class(cysnet.openEmr.msg.GetTokenResponse).%New()
	set pResponse.exito = 1
	
	try {
		set proxyManager = ##class(cysnet.openEmr.proxy.Token).%New()
		
		set headerParams = ##class(%ListOfObjects).%New()
		do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/x-www-form-urlencoded"))
		do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Content-Type", "application/x-www-form-urlencoded"))

		set formData = "client_id="_bo.%ClientIdAndSecretObj.Username
		set formData = formData_"&grant_type=password"
		set formData = formData_"&user_role=users"
		set formData = formData_"&scope=openid offline_access api:fhir patient/AllergyIntolerance.read patient/Appointment.read patient/Binary.read patient/CarePlan.read patient/CareTeam.read patient/Condition.read patient/Coverage.read patient/Device.read patient/DiagnosticReport.read patient/DocumentReference.read patient/DocumentReference.$docref patient/Encounter.read patient/Goal.read patient/Immunization.read patient/Location.read patient/MedicationRequest.read patient/Medication.read patient/Observation.read patient/Organization.read patient/Patient.read patient/Person.read patient/Practitioner.read patient/Procedure.read patient/Provenance.read user/AllergyIntolerance.read user/Binary.read user/CarePlan.read user/CareTeam.read user/Condition.read user/Coverage.read user/Device.read user/DiagnosticReport.read user/DocumentReference.read user/DocumentReference.$docref user/Encounter.read user/Goal.read user/Immunization.read user/Location.read user/MedicationRequest.read user/Medication.read user/Observation.read user/Organization.read user/Organization.write user/Patient.read user/Patient.write user/Person.read user/Practitioner.read user/Practitioner.write user/PractitionerRole.read user/Procedure.read user/Provenance.read api:oemr user/allergy.read user/allergy.write user/appointment.read user/appointment.write user/dental_issue.read user/dental_issue.write user/document.read user/document.write user/drug.read user/encounter.read user/encounter.write user/facility.read user/facility.write user/immunization.read user/insurance.read user/insurance.write user/insurance_company.read user/insurance_company.write user/insurance_type.read user/list.read user/medical_problem.read user/medical_problem.write user/medication.read user/medication.write user/message.write user/patient.read user/patient.write user/practitioner.read user/practitioner.write user/prescription.read user/procedure.read user/soap_note.read user/soap_note.write user/surgery.read user/surgery.write user/transaction.read user/transaction.write user/vital.read user/vital.write"
		set formData = formData_"&username="_bo.%OauthUserObj.Username
		set formData = formData_"&password="_bo.%OauthUserObj.Password

		set tBody = ##class(%Stream.GlobalCharacter).%New()
		do tBody.Write(formData)

		set sc = bo.runMethod(proxyManager, tBody, bo.URLOauth_"/token", "POST", "application/x-www-form-urlencoded", headerParams, "")
		if ($$$ISOK(sc)) {
			set pResponse = proxyManager.response
		}
		
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error en getToken: "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

/// Método que obtiene los cambios en OpenEMR, llamando primero a FHIR y luego a cada recurso:
ClassMethod getChangesOpenEmr(pRequest As cysnet.syncEngine.core.msg.GetChangesRequest, Output pResponse As cysnet.syncEngine.core.msg.GetChangesResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	#dim listaRecursos, infoRecursos As %List = $lb()
	#dim i As %Integer = 1
	
	set pResponse = ##class(cysnet.syncEngine.core.msg.GetChangesResponse).%New()
	set pResponse.exito = 1
	set pResponse.total = 0
	set pResponse.listaCambios = ##class(%ListOfObjects).%New()
	
	try {
		// ----------------------------------------------------------------------------------------------------------------------------------------------------
		// NOTA: En OpenEMR tenemos la misma entidad mapeada con varios recursos FHIR. Esto hace que se realicen las mismas invocaciones N veces, tantas como
		// mapeos con la misma entidad haya. Para evitar esto, primero obtendremos las entidades únicas a buscar, y por cada una, obtendremos la lista de 
		// búsquedas a realizar y/o filtros a aplicar.  De esta forma, solo invocaremos 1 vez el recurso, pero aplicaremos los N filtros que hagan falta
		// ----------------------------------------------------------------------------------------------------------------------------------------------------

		// Obtener lista de recursos:
		// - codConector --> Nombre del conector (OpenEMR)
		// 1 --> Obtiene el nombre del recurso original, ya que las búsquedas se harán sobre la API Standard.
		// 1 --> Solo devuelve las entidades originales (sin más propiedades)
		set listaRecursos = ##class(cysnet.syncEngine.core.data.MapeoEntidad).obtenerEntidades(pRequest.codConector, 1, 1)

		// Obtener información de recursos mapeados:
		// - codConector --> Nombre del conector (OpenEMR)
		// 1 --> Obtiene el nombre del recurso original, ya que las búsquedas se harán sobre la API Standard.
		// 0 --> Devuelve todo: entidad, filtro, clave, etc
		set infoRecursos = ##class(cysnet.syncEngine.core.data.MapeoEntidad).obtenerEntidades(pRequest.codConector, 1)
		
		// Recorremos listaRecursos (recursos únicos)
		for i=1:1:$ll(listaRecursos) {
			set recurso = $li($li(listaRecursos,i),1)

			// Borramos el array (por si existe previamente)
			k infoOpenEMR
			set index = 0

			// Por cada recurso, comparamos con la segunda lista (infoRecursos) y generamos una lista de filtros/claves/etc que tenga:
			for j=1:1:$ll(infoRecursos) {
				if (recurso = $li($li(infoRecursos,j),1)) {
					set filtro = $li($li(infoRecursos,j),2)
					set clave = $li($li(infoRecursos,j),3)
					set campoLastUpdate = $li($li(infoRecursos,j),4)

					// Añadimos la información a un array:
					set infoOpenEMR(recurso,$i(index)) = $lb(filtro, clave, campoLastUpdate)
				}
			}
			
			// Generar una lista de listas con las configuraciones por recurso:
			set listaFinal = $lb(), pos = 0
			set index = ""
			for {
				set index = $Order(infoOpenEMR(recurso,index),1,lista)
				quit:index=""
				// Añadir cada lista de configuraciones (filtro-clave-campoLastUpdate) a una lista final
				set $li(listaFinal, $i(pos)) = lista
			}
			set sc = ..searchOpenEMR(pRequest, .pResponse, bo, recurso, recurso, listaFinal)
			
			quit:pResponse.exito=0
			quit:$$$ISERR(sc)
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.syncEngine.core.msg.struct.Trace).generarTraza("OpenEMR", "Error en getChangesOpenEmr: "_$System.Status.GetErrorText(sc))
	}
	
	quit sc
}

/// Método que hace una búsqueda en la API FHIR:
ClassMethod searchOpenEMR(pRequest As cysnet.openEmr.msg.SearchRequest, Output pResponse As cysnet.openEmr.msg.SearchResponse, bo As cysnet.openEmr.bo.OpenEmr, url As %String, recurso As %String, listaInfoRecurso As %List = "") As %Status
{
	#dim sc As %Status = $$$OK
	#dim lastUpdate As %TimeStamp
	#dim i, j, k As %Integer = 1
	#dim seguir As %Boolean = 0
	#dim reqSearch As cysnet.openEmr.msg.SearchRequest
	#dim rspSearch As cysnet.openEmr.msg.SearchStandardResponse
	
	try {
		// Recorrer la lista de configuraciones:
		for i=1:1:$ll(listaInfoRecurso) {
			set filtro = $li($li(listaInfoRecurso,i),1)
			set clave = $li($li(listaInfoRecurso,i),2)
			set campoLastUpdate = $li($li(listaInfoRecurso,i),3)

			// Sólo realizaremos la búsqueda con el primer elemento de la lista!!
			if (i = 1) {
				// Si no hay registro en el global para lastUpdate-recurso, obtener los cambios desde ahora:
				if ('##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBOPENEMR, pRequest.codConector, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:""))) {
					do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBOPENEMR, pRequest.codConector, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:""), $ZDT($H,3,1))
				}
				set lastUpdate = $P(##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBOPENEMR, pRequest.codConector, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:"")),"+",1)
				if (bo.ResetLastUpdate '= "") {
					set lastUpdate = bo.ResetLastUpdate
					do ..limpiarGlobalsDatos(recurso, lastUpdate)
				}
				$$$LOGWARNING("Buscar cambios de "_url_$s(filtro'="":"?"_filtro,1:"")_" desde "_lastUpdate)

				// Guardar siempre el lastId antes de la ejecución, por si hay que resetearlo en ProcesoSync:
				do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBOPENEMR, pRequest.codConector, "prevUpdate", recurso_$s(filtro'="":"?"_filtro,1:""),
				   ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBOPENEMR, pRequest.codConector, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:"")))	
				set reqSearch = ##class(cysnet.openEmr.msg.SearchRequest).%New()
				set reqSearch.url = url

				set sc = ..searchStandard(reqSearch, .rspSearch, bo)
			}

			// *** Esta parte del código se ejecuta para CADA ELEMENTO DE LA LISTA listaInfoRecurso ***

			if ($$$ISOK(sc)) {
				set pResponse.exito = rspSearch.exito
				set pResponse.trace = rspSearch.trace
				if (pResponse.exito = 1) {
					// Si hay cambios:
					if (rspSearch.total > 0)&&(rspSearch.data.Count() > 0) {
						// Obtener lista de recursos dependientes de éste recurso:
						set infoRecursosDep = ##class(cysnet.syncEngine.core.data.MapeoEntidad).obtenerEntidadesDependientes(pRequest.codConector, recurso, 1)
						
						// Añadir a la lista final de cambios:
						for j=1:1:rspSearch.data.Count() {
							k resource
							k newC
							set seguir = 1

							set resource = rspSearch.data.GetAt(j)
							set resourceJson = {}.%FromJSON(resource.content.Read())
							do resource.content.Rewind()
							set finalContent = resourceJson.%ToJSON()

							// Si la entidad tiene campo de fecha de última actualización:
							if (campoLastUpdate '= "") {
								// Comprobar el tiempo que ha pasado desde la fecha de última actualización. Si el tiempo es > 0, entonces seguir; sino, omitir este cambio
								if ($SYSTEM.SQL.Functions.DATEDIFF("ss", lastUpdate, $ZDT($ZDTH(resourceJson.%Get(campoLastUpdate),3,7),3,1)) <= 0) {
									set seguir = 0
								}
							}

							if (seguir) {
								// Si tenemos guardada la última versión del JSON, comparar con la actual:
								if (##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBOPENEMR, recurso, resourceJson.%Get(clave), "json")) {
									// Comparar el recurso actual con el obtenido la última vez. Si hay cambios, seguir; sino, omitir este cambio
									set sc = ..buscarDiferencias(resourceJson, recurso, resourceJson.%Get(clave), .result)
									quit:$$$ISERR(sc)

									// Si no hay contenido, no insertar:
									if (result.%Size() = 0) {
										set seguir = 0

									} else {
										set finalContent = result.%ToJSON()
									}
								}
							}

							if (seguir) {
								// Si tenemos filtro sobre las entidades de OpenEMR, aplicarlo.
								// Si al aplicarlo la comprobación es positiva, añadir el registro; sino, ignorarlo
								if (filtro '= "") {
									set json = {}.%FromJSON(finalContent)
									Xecute ("(in,out) set out = in."_filtro, json, .seguir)
								}
								// Si se cumple el filtro, cogemos el recurso entero de nuevo
								if (seguir) {
									set finalContent = resourceJson.%ToJSON()
								}
							}

							if (seguir) {
								set newC = ##class(cysnet.syncEngine.core.msg.struct.Cambio).%New()
								set newC.origen = pRequest.codConector
								set newC.idTransaccion = $System.Util.CreateGUID()
								if ( (campoLastUpdate = "")||(resourceJson.%Get(campoLastUpdate) = "") ) {
									set newC.fecha = $ZDT($H,3,1)
								} else {
									set newC.fecha = resourceJson.%Get(campoLastUpdate)
								}
								// Si tenemos registro de este recurso en el global de OpenEMR, marcarlo como Update; sino marcarlo como Insert
								if (##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBOPENEMR, recurso, resourceJson.%Get(clave),"lastUpdate")) {
									set newC.accion = "U"
									do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBOPENEMR,recurso, resourceJson.%Get(clave),"lastUpdate", newC.fecha)
								} else {
									set newC.accion = "I"
									do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBOPENEMR, recurso, resourceJson.%Get(clave),"lastUpdate", newC.fecha)
								}
								do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBOPENEMR, recurso, resourceJson.%Get(clave), "json", resourceJson.%ToJSON())
								set newC.entidad = recurso
								set newC.claveDef = clave
								set newC.tipoContenido = "JSON"
								set newC.contenido = finalContent

								do pResponse.listaCambios.Insert(newC)
								set pResponse.total = pResponse.total + 1
								
								if (campoLastUpdate '= "") {
									// Guardar en un global todos los ID's leídos esta iteración:
									do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBOPENEMR, pRequest.codConector, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:""), resourceJson.%Get(campoLastUpdate))
								} else {
									// Guardar en un global todos los ID's leídos esta iteración:
									do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBOPENEMR, pRequest.codConector, "lastUpdate", recurso_$s(filtro'="":"?"_filtro,1:""), $ZDT($H,3,1))
								}
							}

							// Sólo realizaremos la búsqueda de recursos dependientes con el primer elemento de la lista!!
							if (i = 1) {
								// Si hay recursos dependientes, realizar búsquedas para esos recursos:
								if ($ll(infoRecursosDep) > 0) {
									for k=1:1:$ll(infoRecursosDep) {
										// Montar el path del recurso en base al nombre de éste y el filtro (si tiene):
										set recursoD = $li($li(infoRecursosDep,k),1)
										set filtroD = $li($li(infoRecursosDep,k),2)
										set claveD = $li($li(infoRecursosDep,k),3)
										set campoLastUpdateD = $li($li(infoRecursosDep,k),4)
										set claveDepende = $li($li(infoRecursosDep,k),5)
										
										do ..searchOpenEMR(pRequest, .pResponse, bo, recurso_"/"_resourceJson.%Get(claveDepende)_"/"_recursoD, recursoD, $lb($lb(filtroD, claveD, campoLastUpdateD)))

										quit:pResponse.exito=0
										quit:$$$ISERR(sc)
									}
								}
							}

							quit:pResponse.exito=0
							quit:$$$ISERR(sc)
						}
					}
				}
			}
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.syncEngine.core.msg.struct.Trace).generarTraza("OpenEMR", "Error en searchOpenEMR: "_$System.Status.GetErrorText(sc))
	}
	
	quit sc
}

ClassMethod buscarDiferencias(resource As %DynamicObject, recurso As %String, id As %String, Output result As %DynamicObject) As %Status
{
	#dim sc As %Status = $$$OK
	#dim reqGet As cysnet.hyperobjects.msg.GetRequest
	#dim rspGet As cysnet.hyperobjects.msg.GetResponse
	
	try {
		if (##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBOPENEMR, recurso, id, "json")) {
			set jsonOri = ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBOPENEMR, recurso, id, "json")
			
			set objOri = ##class(%DynamicAbstractObject).%FromJSON(jsonOri)
			
			set result = ##class(cysnet.syncEngine.core.util.JSONComparator).compareJSONObj(objOri, resource, 1, "", ..#COMPAREJSONIGNORE _ ..#COMPAREJSONIGNOREOPENEMR)

			// Si hay diferencias, volver a obtener el resultado, pero con los campos obligatorios:
			if (result.%Size() > 0) {
				set result = ##class(cysnet.syncEngine.core.util.JSONComparator).compareJSONObj(objOri, resource, 1, ..#COMPAREJSONMANDATORY _ ..#COMPAREJSONMANDATORYOPENEMR, "")
			}
		} else {
			set result = {}
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	quit sc
}

/// Método que hace una búsqueda en la API FHIR:
ClassMethod searchFHIR(pRequest As cysnet.openEmr.msg.SearchRequest, Output pResponse As cysnet.openEmr.msg.SearchResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.openEmr.proxy.Search
	#dim headerParams As %ListOfObjects
	
	set pResponse = ##class(cysnet.openEmr.msg.SearchResponse).%New()
	set pResponse.exito = 1

	try {
		if (pRequest.url = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "No se ha especificado URL")

		} else {
			set proxyManager = ##class(cysnet.openEmr.proxy.Search).%New()
			
			set headerParams = ##class(%ListOfObjects).%New()
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/json"))
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Authorization", "Bearer "_##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBOPENEMR, "token")))
			
			set sc = bo.runMethod(proxyManager, "", "/fhir/"_pRequest.url, "GET", "application/json;charset=UTF-8", headerParams)
			if ($$$ISOK(sc)) {
				set pResponse = proxyManager.response
			}
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error en search: "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

/// Método que hace una búsqueda en la API Standard:
ClassMethod searchStandard(pRequest As cysnet.openEmr.msg.SearchRequest, Output pResponse As cysnet.openEmr.msg.SearchStandardResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.openEmr.proxy.SearchStandard
	#dim headerParams As %ListOfObjects
	
	set pResponse = ##class(cysnet.openEmr.msg.SearchStandardResponse).%New()
	set pResponse.exito = 1

	try {
		if (pRequest.url = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "No se ha especificado URL")

		} else {
			set proxyManager = ##class(cysnet.openEmr.proxy.SearchStandard).%New()
			
			set headerParams = ##class(%ListOfObjects).%New()
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/json"))
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Authorization", "Bearer "_##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBOPENEMR, "token")))
			
			set sc = bo.runMethod(proxyManager, "", "/api/"_pRequest.url, "GET", "application/json;charset=UTF-8", headerParams)
			if ($$$ISOK(sc)) {
				set pResponse = proxyManager.response
			}
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error en searchStandard "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

/// Método que obtiene un recurso:
ClassMethod get(pRequest As cysnet.openEmr.msg.GetRequest, Output pResponse As cysnet.openEmr.msg.GetResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.openEmr.proxy.Get
	#dim headerParams As %ListOfObjects
	
	set pResponse = ##class(cysnet.openEmr.msg.GetResponse).%New()
	set pResponse.exito = 1

	try {
		if (pRequest.url = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "No se ha especificado URL")

		} else {
			set proxyManager = ##class(cysnet.openEmr.proxy.Get).%New()
			
			set headerParams = ##class(%ListOfObjects).%New()
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/json"))
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Authorization", "Bearer "_##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBOPENEMR,"token")))
			
			set sc = bo.runMethod(proxyManager, "", pRequest.url, "GET", "application/json;charset=UTF-8", headerParams)
			if ($$$ISOK(sc)) {
				set pResponse = proxyManager.response
			}
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error en get: "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

/// Método que crea un recurso:
ClassMethod post(pRequest As cysnet.openEmr.msg.UpsertRequest, Output pResponse As cysnet.openEmr.msg.UpsertResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.openEmr.proxy.Post
	#dim headerParams As %ListOfObjects
	
	set pResponse = ##class(cysnet.openEmr.msg.UpsertResponse).%New()
	set pResponse.exito = 1

	try {
		if (pRequest.url = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "No se ha especificado URL")

		} else {
			set proxyManager = ##class(cysnet.openEmr.proxy.Post).%New()
			
			set headerParams = ##class(%ListOfObjects).%New()
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/json"))
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Authorization", "Bearer "_##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBOPENEMR, "token")))
			
			set sc = bo.runMethod(proxyManager, pRequest.body, pRequest.url, "POST", "application/json;charset=UTF-8", headerParams)
			if ($$$ISOK(sc)) {
				set pResponse = proxyManager.response
			}
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error en post: "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

/// Método que actualiza un recurso:
ClassMethod put(pRequest As cysnet.openEmr.msg.UpsertRequest, Output pResponse As cysnet.openEmr.msg.UpsertResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.openEmr.proxy.Put
	#dim headerParams As %ListOfObjects
	
	set pResponse = ##class(cysnet.openEmr.msg.UpsertResponse).%New()
	set pResponse.exito = 1

	try {
		if (pRequest.url = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "No se ha especificado URL")

		} else {
			set proxyManager = ##class(cysnet.openEmr.proxy.Put).%New()
			
			set headerParams = ##class(%ListOfObjects).%New()
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/json"))
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Authorization", "Bearer "_##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBOPENEMR, "token")))
			
			set sc = bo.runMethod(proxyManager, pRequest.body, pRequest.url, "PUT", "application/json;charset=UTF-8", headerParams)
			if ($$$ISOK(sc)) {
				set pResponse = proxyManager.response
			}
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error en put: "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

/// Método que elimina un recurso:
ClassMethod delete(pRequest As cysnet.openEmr.msg.DeleteRequest, Output pResponse As cysnet.openEmr.msg.DeleteResponse, bo As cysnet.openEmr.bo.OpenEmr) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.openEmr.proxy.Delete
	#dim headerParams As %ListOfObjects
	
	set pResponse = ##class(cysnet.openEmr.msg.DeleteResponse).%New()
	set pResponse.exito = 1

	try {
		if (pRequest.url = "") {
			set pResponse.exito = 0
			set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "No se ha especificado URL")

		} else {
			set proxyManager = ##class(cysnet.openEmr.proxy.Delete).%New()
			
			set headerParams = ##class(%ListOfObjects).%New()
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/json"))
			do headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Authorization", "Bearer "_##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBOPENEMR, "token")))
			
			set sc = bo.runMethod(proxyManager, "", pRequest.url, "DELETE", "application/json;charset=UTF-8", headerParams)
			if ($$$ISOK(sc)) {
				set pResponse = proxyManager.response
			}
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("OpenEMR", "Error en put: "_$System.Status.GetErrorText(sc))
	}
	
	return $$$OK
}

ClassMethod limpiarGlobalsDatos(recurso As %String, lastUpdate As %TimeStamp) As %Status
{
	#dim id As %String = ""

	#; $$$LOGINFO("limpiarGlobalsDatos")
	#; $$$LOGINFO("recurso: "_recurso)
	#; $$$LOGINFO("lastUpdate: "_lastUpdate)

	for {
		set id = ##class(cysnet.utils.HelperGlobals).getIndex(..#GLBOPENEMR, 1, recurso, id)
		quit:id=""
		#; $$$LOGINFO("id: "_id)
		if (##class(cysnet.utils.HelperGlobals).existsGlobalKey(..#GLBOPENEMR, recurso, id, "lastUpdate")) {
			set fecha = ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBOPENEMR, recurso, id, "lastUpdate")
			// Comprobar el tiempo que ha pasado desde la fecha de última actualización. Si el tiempo es > 0, borrar global; sino, mantener
			if ($SYSTEM.SQL.Functions.DATEDIFF("ss", lastUpdate, $ZDT($ZDTH(fecha,3,7),3,1)) > 0) {
				do ##class(cysnet.utils.HelperGlobals).removeGlobalValue(..#GLBOPENEMR, recurso, id)
				#; $$$LOGINFO("Borrado id: "_id)
			}
		}
	}

	quit $$$OK
}

}
