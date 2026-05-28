Class cysnet.hyperobjects.entities.HyperObjects Extends (cysnet.hyperobjects.util.Util, cysnet.hyperobjects.util.Parameters)
{

ClassMethod syncEntity(pRequest As cysnet.syncEngine.core.msg.SincronizarEntidadRequest, hyperobject As %DynamicObject, identificadores As %DynamicObject, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse, bp As cysnet.syncEngine.core.bp.SyncEntity) As %Status
{
	#dim sc As %Status = $$$OK
	#dim actualizar As %Boolean = 0

	set pResponse = ##class(cysnet.syncEngine.core.msg.SincronizarEntidadResponse).%New()
	set pResponse.exito = 1

	try {
		if ( (pRequest.accion = "I")||(pRequest.accion = "U") ) { // Acción Upsert. Crear mensaje Upsert
			// *************************************************************************************************************
			// Para actualizar un recurso, tenemos que enviar todos los campos. Es por ello que primero hay que obtener
			// el recurso original (si es que existe) y aplicar lo que haya cambiado
			// *************************************************************************************************************
			
			set refId = "" // ID de la referencia
			set refOri = "" // Recurso de referencia original
			set resourceOri = "" // Recurso original

			// Si tenemos id en el objeto hyperobject, y además el ID coincide con el de la request, buscar por ID:
			if ((hyperobject.id '= "")&&(hyperobject.id = pRequest.id)) {
				// Es un UPDATE
				set filtro = "_id="_pRequest.id
			} else {
				// Es NUEVO
				set filtro = "identifier="_pRequest.id
			}
			
			$$$LOGWARNING("1. Obtener el recurso "_pRequest.entidad_" original de HO")
			set sc = ..searchHO("/"_pRequest.entidad_"?"_filtro, .pResponse, bp, .resourceOri)
			if ($$$ISOK(sc)) {
			} else {
				set pResponse.exito = 0 // La traza se generará al final del proceso
			}
			
			// Buscar todas las propiedades de tipo "reference", para obtener el ID original:
			if (pResponse.exito = 1) {
				// Obtener todas las propiedades de tipo referencia:
				set listaRef = ..getReferences(pRequest.entidad)

				if ($ll(listaRef) > 0) {
					$$$LOGWARNING("2. Comprobar si hay que crear/actualizar la referencia...")
					for i=1:1:$ll(listaRef) {
						#; $$$LOGINFO($li(listaRef,i))
						set prop = $li(listaRef,i)

						// Si la propiedad tiene ".", es que es una propiedad Padre quien tiene una propiedad hija de tipo Reference
						// Recorrer el array en busca de la segunda propiedad
						if ($f(prop, ".") > 0) {
							set propParent = $p(prop,".",1)
							set prop = $p(prop,".",2)

							// Si la propiedad es un array:
							if (hyperobject.%Get(propParent) '= "")&&($ClassName(hyperobject.%Get(propParent)) = "%Library.DynamicArray") {
								#; $$$LOGALERT(propParent_" ES UN ARRAY. Recorrer y buscar "_prop)
								for j=0:1:hyperobject.%Get(propParent).%Size()-1 {
									// Si hay referencia: buscar su recurso FHIR:
									if (hyperobject.%Get(propParent).%Get(j).%Get(prop) '= "")&&(hyperobject.%Get(propParent).%Get(j).%Get(prop).identifier.value '= "NULL")&&(hyperobject.%Get(propParent).%Get(j).%Get(prop).identifier.value '= "") {
										$$$LOGWARNING("2.1.1 ("_j_") Buscar "_hyperobject.%Get(propParent).%Get(j).%Get(prop).type_" en FHIR")

										set sc = ..searchHO("/"_hyperobject.%Get(propParent).%Get(j).%Get(prop).type_"?identifier="_hyperobject.%Get(propParent).%Get(j).%Get(prop).identifier.system_"|"_hyperobject.%Get(propParent).%Get(j).%Get(prop).identifier.value, .pResponse, bp, .refOri)
										if ($$$ISOK(sc)) {
											if (refOri '= "") {
												$$$LOGWARNING("2.1.2 ("_j_") Encontrada referencia: "_hyperobject.%Get(propParent).%Get(j).%Get(prop).type_"/"_refOri.id)
												set hyperobject.%Get(propParent).%Get(j).%Get(prop).reference = hyperobject.%Get(propParent).%Get(j).%Get(prop).type_"/"_refOri.id
												do hyperobject.%Get(propParent).%Get(j).%Get(prop).%Remove("identifier")
												#; do hyperobject.%Get(propParent).%Get(j).%Get(prop).%Remove("type")
												set actualizar = 1
												set refOri = ""
											} else {
												$$$LOGWARNING("2.1.2 ("_j_") Referencia "_propParent_"("_j_")."_prop_" no encontrada")
											}
										} else {
											set pResponse.exito = 0 // La traza se generará al final del proceso
										}
									}
								}
							} else {
								#; $$$LOGALERT(propParent_" es una propiedad normal. Comprobar "_prop)
								// Si hay referencia: buscar su recurso FHIR:
								if (hyperobject.%Get(propParent) '= "")&&(hyperobject.%Get(propParent).%Get(prop) '= "")&&(hyperobject.%Get(propParent).%Get(prop).identifier '= "")&&(hyperobject.%Get(propParent).%Get(prop).identifier.value '= "NULL")&&(hyperobject.%Get(propParent).%Get(prop).identifier.value '= "") {
									$$$LOGWARNING("2.2.1 Buscar "_hyperobject.%Get(propParent).%Get(prop).type_" en FHIR")

									set sc = ..searchHO("/"_hyperobject.%Get(propParent).%Get(prop).type_"?identifier="_hyperobject.%Get(propParent).%Get(prop).identifier.system_"|"_hyperobject.%Get(propParent).%Get(prop).identifier.value, .pResponse, bp, .refOri)
									if ($$$ISOK(sc)) {
										if (refOri '= "") {
											$$$LOGWARNING("2.2.2 Encontrada referencia: "_hyperobject.%Get(propParent).%Get(prop).type_"/"_refOri.id)
											set hyperobject.%Get(propParent).%Get(prop).reference = hyperobject.%Get(propParent).%Get(prop).type_"/"_refOri.id
											do hyperobject.%Get(propParent).%Get(prop).%Remove("identifier")
											#; do hyperobject.%Get(propParent).%Get(prop).%Remove("type")
											set actualizar = 1
											set refOri = ""
										} else {
											$$$LOGWARNING("2.2.2 Referencia "_propParent_"."_prop_" no encontrada")
										}
									} else {
										set pResponse.exito = 0 // La traza se generará al final del proceso
									}
								}
							}

						} else {
							// Si la propiedad es un array:
							if (hyperobject.%Get(prop) '= "")&&($ClassName(hyperobject.%Get(prop)) = "%Library.DynamicArray") {
								for j=0:1:hyperobject.%Get(prop).%Size()-1 {
									// Si hay referencia: buscar su recurso FHIR:
									if (hyperobject.%Get(prop).%Get(j) '= "")&&(hyperobject.%Get(prop).%Get(j).identifier.value '= "NULL")&&(hyperobject.%Get(prop).%Get(j).identifier.value '= "") {
										$$$LOGWARNING("2.3.1 ("_j_") Buscar "_hyperobject.%Get(prop).%Get(j).type_" en FHIR")

										set sc = ..searchHO("/"_hyperobject.%Get(prop).%Get(j).type_"?identifier="_hyperobject.%Get(prop).%Get(j).identifier.system_"|"_hyperobject.%Get(prop).%Get(j).identifier.value, .pResponse, bp, .refOri)
										if ($$$ISOK(sc)) {
											if (refOri '= "") {
												$$$LOGWARNING("2.3.2 ("_j_") Encontrada referencia: "_hyperobject.%Get(prop).%Get(j).type_"/"_refOri.id)
												set hyperobject.%Get(prop).%Get(j).reference = hyperobject.%Get(prop).%Get(j).type_"/"_refOri.id
												do hyperobject.%Get(prop).%Get(j).%Remove("identifier")
												#; do hyperobject.%Get(prop).%Get(j).%Remove("type")
												set actualizar = 1
												set refOri = ""
											} else {
												$$$LOGWARNING("2.3.2 ("_j_") Referencia "_prop_" no encontrada")
											}
										} else {
											set pResponse.exito = 0 // La traza se generará al final del proceso
										}
									}
								}
							} else {
								// Si hay referencia: buscar su recurso FHIR:
								if (hyperobject.%Get(prop) '= "")&&(hyperobject.%Get(prop).identifier '= "")&&(hyperobject.%Get(prop).identifier.value '= "NULL")&&(hyperobject.%Get(prop).identifier.value '= "") {
									$$$LOGWARNING("2.4.1 Buscar "_hyperobject.%Get(prop).type_" en FHIR")

									set sc = ..searchHO("/"_hyperobject.%Get(prop).type_"?identifier="_hyperobject.%Get(prop).identifier.system_"|"_hyperobject.%Get(prop).identifier.value, .pResponse, bp, .refOri)
									if ($$$ISOK(sc)) {
										if (refOri '= "") {
											$$$LOGWARNING("2.4.2 Encontrada referencia: "_hyperobject.%Get(prop).type_"/"_refOri.id)
											set hyperobject.%Get(prop).reference = hyperobject.%Get(prop).type_"/"_refOri.id
											do hyperobject.%Get(prop).%Remove("identifier")
											#; do hyperobject.%Get(prop).%Remove("type")
											set actualizar = 1
											set refOri = ""
										} else {
											$$$LOGWARNING("2.4.2 Referencia "_prop_" no encontrada")
										}
									} else {
										set pResponse.exito = 0 // La traza se generará al final del proceso
									}
								}
							}
						}
					}
				}
			}

			if (pResponse.exito = 1) {
				if ( (resourceOri = "")||( (resourceOri '= "")&&(..checkChanges(resourceOri, hyperobject)) ) ) {
					$$$LOGWARNING("2. Upsert "_pRequest.entidad)
					set sc = ..upsertHO("/"_pRequest.entidad_"?"_filtro, hyperobject, .pResponse, bp)
				} else {
					$$$LOGASSERT("No hay cambios. Seguir")
				}
			}
			
			if (pResponse.exito = 1) {
				// Si tenemos idConector y, no había id en el objeto o hemos hecho un cambio en "hyperobject" --> Actualizarlo y actualizar el global:
				if ( (pResponse.idConector '= "")&&((hyperobject.id = "")||(actualizar)) ) {
					$$$LOGALERT("Actualizar en HyperObjects el ID a "_pResponse.idConector_" de la entidad "_pRequest.entidad_" ""HO"","""_pRequest.id_""" y actualizar el global")
					set hyperobject.id = pResponse.idConector
					set json = hyperobject.%ToJSON()

					// Actualizar el JSON del recurso:					
					do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBPREFIX_pRequest.entidad, "HO", pRequest.id, json)
				}
				// Si tenemos versionId, registrarla en el global índice de versiones, para no obtenerla en la siguiente iteración de getChanges:
				if (pResponse.versionId '= "") {
					$$$LOGALERT("Actualizar en HyperObjects la versión de "_pRequest.entidad_" del ID "_pResponse.idConector_" al valor "_pResponse.versionId)
					do ##class(cysnet.utils.HelperGlobals).setGlobalValue(..#GLBHYPEROBJECTS, pRequest.entidad,pResponse.idConector, pResponse.versionId)
				}
			}
		} else {
			$$$LOGASSERT(pRequest.entidad_": Acción no controlada: "_pRequest.accion)
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	quit sc
}

}
