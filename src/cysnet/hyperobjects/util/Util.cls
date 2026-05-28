Include Ensemble

Class cysnet.hyperobjects.util.Util Extends cysnet.hyperobjects.util.Parameters
{

ClassMethod searchHO(url As %String, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse, bp As cysnet.syncEngine.core.bp.SyncEntity, Output objOri As %DynamicObject) As %Status
{
	#dim sc As %Status = $$$OK

	try {
		set reqSearch = ##class(cysnet.hyperobjects.msg.SearchRequest).%New()
		set reqSearch.url = url

		set sc = bp.SendRequestSync("HyperObjects", reqSearch, .rspSearch)
		if ($$$ISOK(sc)) {
			set pResponse.exito = rspSearch.exito
			set pResponse.trace = rspSearch.trace
			
			if (pResponse.exito = 1) {
				if (rspSearch.total = 1) {
					set objOri = ##class(%DynamicAbstractObject).%FromJSON(rspSearch.entry.GetAt(1).content)
				} elseif (rspSearch.total = 0) {
					// Si no existe, se creará en el siguiente bloque
				} else {
					$$$LOGWARNING("Hay más de un registro!!! ("_url_")")
					set pResponse.exito = 0
					set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("HyperObjects", "Hay más de un registro para la búsqueda solicitada. Total: "_rspSearch.total_", búsqueda: "_url)
				}
			}
		} else {
			set pResponse.exito = 0 // La traza se generará al final del proceso
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	quit sc
}

ClassMethod getObjHO(url As %String, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse, bp As cysnet.syncEngine.core.bp.SyncEntity, Output objOri As %DynamicObject) As %Status
{
	#dim sc As %Status = $$$OK

	try {
		set reqGet = ##class(cysnet.hyperobjects.msg.GetRequest).%New()
		set reqGet.url = url

		set sc = bp.SendRequestSync("HyperObjects", reqGet, .rspGet)
		if ($$$ISOK(sc)) {
			set pResponse.exito = rspGet.exito
			set pResponse.trace = rspGet.trace
			
			if (pResponse.exito = 1) {
				set objOri = ##class(%DynamicAbstractObject).%FromJSON(rspGet.resource.content)
			}
		} else {
			set pResponse.exito = 0 // La traza se generará al final del proceso
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	quit sc
}

ClassMethod upsertHO(url As %String, obj As %DynamicObject, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse, bp As cysnet.syncEngine.core.bp.SyncEntity) As %Status
{
	#dim sc As %Status = $$$OK

	try {
		// Upsert:
		set reqUpsert = ##class(cysnet.hyperobjects.msg.UpsertRequest).%New()
		set reqUpsert.url = url
		set reqUpsert.body = ##class(%Stream.GlobalCharacter).%New()
		do reqUpsert.body.Write(obj.%ToJSON())

		set sc = bp.SendRequestSync("HyperObjects", reqUpsert, .rspUpsert)
		if ($$$ISOK(sc)) {
			set pResponse.exito = rspUpsert.exito
			set pResponse.trace = rspUpsert.trace
			
			// Devolver el ID del recurso:
			set part1 = $P(rspUpsert.resourceURL,"/_history",1)
			set part2 = $P(rspUpsert.resourceURL,"/_history",2)
			set pResponse.idConector = $P(part1,"/",$l(part1,"/"))
			set pResponse.versionId = $P(part2,"/",$l(part2,"/"))
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	quit sc
}

/// Crea un array dinámico a partir de la lista de argumentos. 
/// Esta lista debe tener elementos pares, ya que crea un objeto con el primer y segundo valor de cada posición
ClassMethod createIdArray(identificadores As %DynamicObject, Output idArray As %DynamicArray, args...) As %Status
{
	#dim sc As %Status = $$$OK
	#dim obj As %DynamicObject
	#dim i As %Integer = 0

	try {
		set idArray = []

		if (args '= "") {
			// Comprobar que args sea par:
			if (args#2 = 0) {
				// Recorremos la lista de argumentos
				for i=1:1:args {
					// El primer elemento será la posición i
					set system = args(i)
					// El segundo, la posición i + 1. Incrementamos el valor para que a la hora de recorrerlo con el for, no pase por el mismo índice
					set value = args($i(i))

					// Si no existe entrada en "identificadores", o el valor es distinto, añadirlo:
					// NOTA: dentro de "identificadores" se elimina el texto "http://hyperobjects/", por eso hay que borrarlo a la hora de buscarlo
					if (identificadores.%Get($Replace(system,"http://hyperobjects/","")) = "")||(identificadores.%Get($Replace(system,"http://hyperobjects/","")) '= value) {
						// Creamos el objeto:
						set obj = {}
						set obj.system = system
						set obj.value = value

						// Añadimos el objeto al array y lo borramos
						do idArray.%Push(obj)
						k obj
					}
				}
			} else {
				set sc = $$$ERROR($$$EnsErrGeneral,"Lista de argumentos impar ("_args_"). No seguir")
			}
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	return sc
}

ClassMethod addIdentifierHO(hyperobject As %DynamicObject, entidad As %String, id As %String, conector As %String, idConector As %String, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse, bp As cysnet.syncEngine.core.bp.SyncEntity) As %Status
{
	#dim sc As %Status = $$$OK
	#dim sedeId = ""

	// Si no existe pResponse, instanciarlo:
	if ('$IsObject(pResponse)) {
		set pResponse = ##class(cysnet.syncEngine.core.msg.SincronizarEntidadResponse).%New()
		set pResponse.exito = 1
	}

	try {
		// Si tenemos recurso e id en Hyperobjects:
		if ( (entidad '= "")&&(hyperobject.id '= "") ) {
			set obj = "" // Recurso original

			$$$LOGWARNING("1. Obtener el recurso original de HO")
			set sc = ..getObjHO("/"_entidad_"/"_hyperobject.id, .pResponse, bp, .obj)
			if ($$$ISERR(sc)) {
				set pResponse.exito = 0 // La traza se generará al final del proceso
			}

			if (pResponse.exito = 1) {
				$$$LOGWARNING("2. Añadir el identificador nuevo...")
				set identifier = {}
				set identifier.system = "http://hyperobjects/"_conector
				set identifier.value = idConector

				// Si no está inicializado el array identifier, inicializarlo:
				if (obj.%IsDefined("identifier") = 0) {
					set obj.identifier = []
				}
				do obj.identifier.%Push(identifier)
			}

			if (pResponse.exito = 1) {
				$$$LOGWARNING("3. Update del recurso")
				set sc = ..upsertHO("/"_entidad_"/"_hyperobject.id, obj, .pResponse, bp)
			}

			if (pResponse.exito = 1) {
				$$$LOGWARNING("4. Actualizar el JSON del hyperobject ("_entidad_","_id_")")
				// Si todo ha ido bien, actualizar el registro en el global:
				set json = obj.%ToJSON()
				do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBPREFIX_entidad, "HO", id, json)
			}
		} else {
			$$$LOGASSERT($P($CLASSNAME($this), ".", $l($CLASSNAME($this),"."))_": Faltan datos obligatorios")
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	quit sc
}

ClassMethod addIdentifiersHO(hyperobject As %DynamicObject, idArray As %DynamicArray, entidad As %String, id As %String, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse, bp As cysnet.syncEngine.core.bp.SyncEntity) As %Status
{
	#dim sc As %Status = $$$OK
	#dim sedeId = ""

	// Si no existe pResponse, instanciarlo:
	if ('$IsObject(pResponse)) {
		set pResponse = ##class(cysnet.syncEngine.core.msg.SincronizarEntidadResponse).%New()
		set pResponse.exito = 1
	}

	try {
		// Si tenemos recurso e id en Hyperobjects:
		if ( (entidad '= "")&&(hyperobject.id '= "") ) {
			set obj = "" // Recurso original

			$$$LOGWARNING("1. Obtener el recurso original de HO")
			set sc = ..getObjHO("/"_entidad_"/"_hyperobject.id, .pResponse, bp, .obj)
			if ($$$ISERR(sc)) {
				set pResponse.exito = 0 // La traza se generará al final del proceso
			}

			if (pResponse.exito = 1) {
				$$$LOGWARNING("2. Añadir los nuevos identificadores...")
				for i=0:1:idArray.%Size()-1 {
					set identifier = {}
					set identifier.system = idArray.%Get(i).system
					set identifier.value = ""_idArray.%Get(i).value // Concatenarle "" para que lo convierta a String

					// Si no está inicializado el array identifier, inicializarlo:
					if (obj.%IsDefined("identifier") = 0) {
						set obj.identifier = []
					}
					do obj.identifier.%Push(identifier)
				}
			}

			if (pResponse.exito = 1) {
				$$$LOGWARNING("3. Update del recurso")
				set sc = ..upsertHO("/"_entidad_"/"_hyperobject.id, obj, .pResponse, bp)
			}

			if (pResponse.exito = 1) {
				$$$LOGWARNING("4. Actualizar el JSON del hyperobject ("_entidad_","_id_")")
				// Si todo ha ido bien, actualizar el registro en el global:
				set json = obj.%ToJSON()
				do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBPREFIX_entidad, "HO", id, json)

				$$$LOGWARNING("5. Actualizar en HO la versión de "_entidad_" del ID "_pResponse.idConector_" al valor "_pResponse.versionId)
				do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBHYPEROBJECTS, entidad, pResponse.idConector, pResponse.versionId)
			}
		} else {
			$$$LOGASSERT($P($CLASSNAME($this), ".", $l($CLASSNAME($this),"."))_": Faltan datos obligatorios")
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	quit sc
}

ClassMethod createConnectorObject(dtl As %String, hyperobject As %DynamicObject, Output finalObject As %DynamicObject) As %Status
{
	#dim sc As %Status = $$$OK

	set auditRecord = ##class(cysnet.audit.util.AuditRecord).newRecord($GET($$$JobSessionId))

	try {
		// Importar el JSON en un stream:
		set stream = ##class(%Stream.TmpCharacter).%New()
		do stream.Write(hyperobject.%ToJSON())

		// Obtener la clase destino a partir del target de la DTL:
		set targetResourceClass = $ClassMethod(dtl, "GetTargetType")

		// Obtener el docType destino a partir del target de la DTL:
		set targetDocType = $ClassMethod(dtl, "GetTargetDocType")
		
		// Obtener la clase del recurso FHIR a partir del source de la DTL:
		set fhirResourceClass = $ClassMethod(dtl, "GetSourceType")
		
		// Importar el stream en el objeto FHIR, a partir de la clase del recurso FHIR:
		set objFhir = $ClassMethod(fhirResourceClass, "FromJSON", stream, "vR4")
		
		// Transformar el objeto FHIR a objeto dinámico:
		set sc = $ClassMethod(dtl, "Transform", objFhir, .finalObject)
		
		do auditRecord.generateAuditContentDTL("FHIR", hyperobject.resourceType, $s(targetDocType '= "":targetDocType,1:targetResourceClass), dtl, hyperobject, finalObject)

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	if ($$$ISERR(sc)) {
		//Si se ha producido un error, se incluye en el registro de auditoria
		do auditRecord.error($System.Status.GetErrorText(sc))
	}

	do auditRecord.endRecord()

	return sc
}

ClassMethod getReferences(entidad As %String) As %List
{
	#dim listaRef As %List = $lb()
	#dim pos As %Integer = 0

	do ..getClassReferences("HS.FHIR.DTL.vR4.Model.Resource."_entidad, "", .pos, .listaRef)

	if (pos = 0) {
		set listaRef = ""
	} else {
		set listaRef = ..removeDuplicates(listaRef)
	}
	quit listaRef
}

ClassMethod getClassReferences(classname As %String, origin As %String, Output cont As %Integer = 0, Output references As %List)
{
	set class = ##class(%Dictionary.CompiledClass).IDKEYOpen(classname)

	if (class '= "") {
		set key = ""
		for {
			set property = class.Properties.GetNext(.key)
			quit:key=""
			

			// Si es un Base.Reference, añadirlo a la lista:
			if (property.Type = "HS.FHIR.DTL.vR4.Model.Base.Reference") {
				#; w "("_origin_") "_property.Name_" --> "_property.Type,!
				set cont = cont + 1
				set $li(references, cont) = $s(origin'="":origin_".",1:"")_property.Name
				#; set $li(references, cont) = property.Name

			// Sino, si NO ES un tipo Base de FHIR, y es de un tipo específico de FHIR, y no es la propiedad original, ni es extensión:
			} elseif ($f(property.Type, "HS.FHIR.DTL.vR4.Model.Base.") = 0)&&($f(property.Type, "HS.FHIR.DTL.vR4.") > 0)&&(property.Name '= origin)&&(property.Name '= "extension") {
				do ..getClassReferences(property.Type, property.Name, .cont, .references)
			}
		}
	}
}

ClassMethod removeDuplicates(lista As %List) As %List
{
	#dim newList As %List = $lb()
	#dim cont As %Integer = 0

	for i=1:1:$ll(lista) {
		// Si no está el elemento i en la nueva lista, añadirlo:
		if ($lf(newList, $li(lista,i)) = 0) {
			set cont = cont + 1
			set $li(newList, cont) = $li(lista,i)
		}
	}

	quit newList
}

/// Compara los dos objetos en busca de cambios. Devuelve true si hay que aplicar cambios
ClassMethod checkChanges(oldObj As %DynamicObject, newObj As %DynamicObject) As %Boolean
{
	#dim hayCambios As %Boolean = 0

	if (oldObj = "") {
		set hayCambios = 1
	} else {
		set result = ##class(cysnet.syncEngine.core.util.JSONComparator).compareJSONObj(oldObj, newObj, 1, "", ..#COMPAREJSONIGNORE, ..#COMPAREJSONLISTKEYS)

		set hayCambios = (result.%Size() > 0)
	}

	quit hayCambios
}

ClassMethod getEntityData(entidad As %String, id As %String) As %DynamicAbstractObject
{
	#dim json As %String = ""
	#dim hyperobject As %DynamicAbstractObject = {}

	// Obtener el JSON del recurso:
	set json = ##class(cysnet.utils.HelperGlobals).getGlobalValue(..#GLBPREFIX_entidad, "HO", id)

	// Convertir el JSON a objeto:
	set hyperobject = ##class(%DynamicAbstractObject).%FromJSON(json)

	return hyperobject
}

/// Método que realiza búsqueda de múltiples objetos de HyperObjets
/// Pendiente de refactorizar en un futuro para unifivcar las búsquedas en un sólo método
/// Métodos a revisar:
/// - searchHO
/// - searchMultipleHO
ClassMethod searchMultipleHO(url As %String, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse, bp As cysnet.syncEngine.core.bp.SyncEntity, Output objOri As %DynamicObject) As %Status
{
	#dim sc As %Status = $$$OK

	try {
		set reqSearch = ##class(cysnet.hyperobjects.msg.SearchRequest).%New()
		set reqSearch.url = url

		set sc = bp.SendRequestSync("HyperObjects", reqSearch, .rspSearch)

		set objOri = ##class(%DynamicObject).%New()

		if ($$$ISOK(sc)) {
			set pResponse.exito = rspSearch.exito
			set pResponse.trace = rspSearch.trace			
			if (pResponse.exito = 1) {	
				// Asignamos a objOri todos los objetos ServiceRequest obtenidos en la consulta
				set objOri = ##class(%DynamicObject).%New()
				set objOri.total = rspSearch.total
				set objOri.entry = []
				if (rspSearch.total >= 1) {					
					for i=1:1:rspSearch.total {		
						set entry = ##class(%DynamicAbstractObject).%FromJSON(rspSearch.entry.GetAt(i).content)
						do objOri.entry.%Push(entry)
						;$$$LOGINFO("Entry("_i_"): "_entry.%ToJSON())						
					}
					;$$$LOGINFO("objOri: "_objOri.%ToJSON())									
				} 		
			}
		} else {
			set pResponse.exito = 0 // La traza se generará al final del proceso
		}
	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	quit sc
}

}
