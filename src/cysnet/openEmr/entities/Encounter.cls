Include Ensemble

Class cysnet.openEmr.entities.Encounter Extends cysnet.hyperobjects.util.Util
{

ClassMethod syncEntity(pRequest As cysnet.syncEngine.core.msg.SincronizarEntidadRequest, hyperobject As %DynamicObject, identificadores As %DynamicObject, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse, bp As cysnet.syncEngine.core.bp.SyncEntity) As %Status
{
    #dim sc As %Status = $$$OK
    #dim reqWS As cysnet.openEmr.msg.UpsertRequest
    #dim rspWS As cysnet.openEmr.msg.UpsertResponse
	#dim idArray As %DynamicArray = []

    // Crear una respuesta para sincronización
    set pResponse = ##class(cysnet.syncEngine.core.msg.SincronizarEntidadResponse).%New()
    set pResponse.exito = 1

    try {
        if ((pRequest.accion = "I") || (pRequest.accion = "U")) { // Acción Upsert
            set encounter = {}
			set patientOri = ""
			set practitionerOri = ""
			set organizationOri = ""


            $$$LOGWARNING("1. Crear objeto Encounter")
            // Crear el objeto de encuentro desde HyperObjects a FHIR Encounter
            set sc = ..createConnectorObject("cysnet.openEmr.dtl.HyperObjectsToEncounter", hyperobject, .encounter)
			if ($$$ISERR(sc)) {
				set pResponse.exito = 0 // La traza se generará al final del proceso
			}

			if (pResponse.exito = 1) {
                $$$LOGWARNING("2 Buscar referencias...")

				if (hyperobject.subject '= "")&&(hyperobject.subject.type = "Patient") {
                    $$$LOGWARNING("2.1 Comprobar si hay que buscar Patient en FHIR")
                    // Si hay centro: buscar su recurso FHIR:
                    if (hyperobject.subject.reference '= "NULL")&&(hyperobject.subject.reference '= "") {
                        $$$LOGWARNING("2.1.1 Buscar Patient en FHIR")
                        set sc = ..getObjHO("/"_hyperobject.subject.reference, .pResponse, bp, .patientOri)
                        if ($$$ISOK(sc)) {
                            if (patientOri '= "") {
                                // Buscar el identificador:
                                for j=0:1:patientOri.identifier.%Size()-1 {
                                    if (patientOri.identifier.%Get(j).system = "http://hyperobjects/OpenEMR") {
                                        set encounter.puuid = patientOri.identifier.%Get(j).value
                                        
                                    } elseif (patientOri.identifier.%Get(j).system = "http://hyperobjects/OpenEMR/id") {
                                        set encounter.pid = $Number(patientOri.identifier.%Get(j).value)
                                    }

                                }
                            }
                        } else {
                            set pResponse.exito = 0 // La traza se generará al final del proceso
                        }
                    }
                }

				if (hyperobject.participant.%Size() > 0) {
                    if (hyperobject.participant.%Get(0).individual '= "")&&(hyperobject.participant.%Get(0).individual.type = "Practitioner") {
                        $$$LOGWARNING("2.2 Comprobar si hay que buscar Practitioner en FHIR")
                        // Si hay centro: buscar su recurso FHIR:
                        if (hyperobject.participant.%Get(0).individual.reference '= "NULL")&&(hyperobject.participant.%Get(0).individual.reference '= "") {
                            $$$LOGWARNING("22.1 Buscar Patient en FHIR")
                            set sc = ..getObjHO("/"_hyperobject.participant.%Get(0).individual.reference, .pResponse, bp, .practitionerOri)
                            if ($$$ISOK(sc)) {
                                if (practitionerOri '= "") {
                                    // Buscar el identificador:
                                    for j=0:1:practitionerOri.identifier.%Size()-1 {
                                        if (practitionerOri.identifier.%Get(j).system = "http://hyperobjects/OpenEMR") {
                                            set encounter."provider_uuid" = practitionerOri.identifier.%Get(j).value
                                            
                                        } elseif (practitionerOri.identifier.%Get(j).system = "http://hyperobjects/OpenEMR/id") {
                                            set encounter."provider_id" = $Number(practitionerOri.identifier.%Get(j).value)
                                        }

                                    }
                                }
                            } else {
                                set pResponse.exito = 0 // La traza se generará al final del proceso
                            }
                        }
					} 
				}

				if (hyperobject.serviceProvider '= "")&&(hyperobject.serviceProvider.type = "Organization") {
                    $$$LOGWARNING("2.13Comprobar si hay que buscar Patient en FHIR")
                    // Si hay centro: buscar su recurso FHIR:
                    if (hyperobject.serviceProvider.reference '= "NULL")&&(hyperobject.serviceProvider.reference '= "") {
                        $$$LOGWARNING("2.3.1 Buscar Organization en FHIR")
                        set sc = ..getObjHO("/"_hyperobject.serviceProvider.reference, .pResponse, bp, .organizationOri)
                        if ($$$ISOK(sc)) {
                            if (organizationOri '= "") {
                                // Buscar el identificador:
                                for j=0:1:organizationOri.identifier.%Size()-1 {
                                    if (organizationOri.identifier.%Get(j).system = "http://hyperobjects/OpenEMR") {
                                        set encounter."facility_uuid" = organizationOri.identifier.%Get(j).value
                                        
                                    } elseif (organizationOri.identifier.%Get(j).system = "http://hyperobjects/OpenEMR/id") {
                                        set encounter."facility_id" = $Number(organizationOri.identifier.%Get(j).value)
                                    }

                                }
                            }
                        } else {
                            set pResponse.exito = 0 // La traza se generará al final del proceso
                        }
                    }
                }
			}

			if (pResponse.exito = 1) {
                $$$LOGWARNING("3. Upsert Encounter")
                // Crear una request de actualización o inserción
                set reqWS = ##class(cysnet.openEmr.msg.UpsertRequest).%New()
                if (encounter.euuid '= "") {
                    set reqWS.url = "/api/patient/"_encounter.puuid_"/encounter/"_encounter.euuid
                    set reqWS.uuid = encounter.euuid
                } else {
                    set reqWS.url = "/api/patient/"_encounter.puuid_"/encounter"
                }

                // Convertir el objeto encounter a JSON
                set reqWS.body = ##class(%Stream.GlobalCharacter).%New()
                do reqWS.body.Write(encounter.%ToJSON())

                // Enviar la request a OpenEMR
                set sc = bp.SendRequestSync("OpenEMR", reqWS, .rspWS)

                // Verificar si la operación fue exitosa
                if ($$$ISOK(sc)) {
                    if (rspWS.exito = 1) {
                        // Devolver el ID de OpenEMR
                        set pResponse.idConector = rspWS.uuid
                        
                        // Crear un array dinámico, añadiendo todos los identificadores que queramos añadir (si no existen)
                        set sc = ..createIdArray(identificadores, .idArray, 
                            "http://hyperobjects/"_pRequest.direccion, pResponse.idConector
                        )
                        if ($$$ISERR(sc)) {
                            set pResponse.exito = 0 // La traza se generará al final del proceso
                        }
                    } else {
                        set pResponse.exito = 0
                        set pResponse.trace = rspWS.trace
                    }
                }

                // Si la operación fue exitosa, actualizar los identificadores en HyperObjects
                if (pResponse.exito = 1) {
                    if (pResponse.idConector '= "") {
                        // Si hay elementos en el array de identificadores
                        if (idArray.%Size > 0) {
                            set sc = ..addIdentifiersHO(hyperobject, idArray, pRequest.entidad, pRequest.id, .pResponse, bp)
                            if ($$$ISERR(sc)) {
                                set pResponse.exito = 0 // La traza se generará al final del proceso
                            }
                        }
                    }
                }
            }
        } else {
            $$$LOGASSERT(pRequest.entidad_": Acción no controlada: "_pRequest.accion)
        }
    } catch (err) {
        set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
    }

    return sc
}

}
