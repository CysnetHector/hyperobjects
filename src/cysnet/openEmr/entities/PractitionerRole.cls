Include Ensemble

Class cysnet.openEmr.entities.PractitionerRole Extends cysnet.hyperobjects.util.Util
{

ClassMethod syncEntity(pRequest As cysnet.syncEngine.core.msg.SincronizarEntidadRequest, hyperobject As %DynamicObject, identificadores As %DynamicObject, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse, bp As cysnet.syncEngine.core.bp.SyncEntity) As %Status
{
	#dim sc As %Status = $$$OK
	#dim reqWS As cysnet.openEmr.msg.UpsertRequest
	#dim rspWS As cysnet.openEmr.msg.UpsertResponse
	#dim idArray As %DynamicArray = []

	set pResponse = ##class(cysnet.syncEngine.core.msg.SincronizarEntidadResponse).%New()
	set pResponse.exito = 1

	try {
		if ((pRequest.accion = "I")||(pRequest.accion = "U")) { // Acción Upsert
			set organizationOri = ""
			set practitionerOri = ""
			set practitioner = {}
			set npi = ""

			$$$LOGWARNING("1. Crear objeto PractitionerRole")
			set sc = ..createConnectorObject("cysnet.openEmr.dtl.PractitionerRoleToPractitioner", hyperobject, .practitioner)

			if (pResponse.exito = 1) {
				if (hyperobject.organization.reference '= "NULL")&&(hyperobject.organization.reference '= "") {
					$$$LOGWARNING("2.1 Buscar Organization en FHIR")
					set sc = ..getObjHO("/"_hyperobject.organization.reference, .pResponse, bp, .organizationOri)
					if ($$$ISOK(sc)) {
						if (organizationOri '= "") {
							// Buscar el identificador:
							for i=0:1:organizationOri.identifier.%Size()-1 {
								if (organizationOri.identifier.%Get(i).system = "http://hyperobjects/OpenEMR/id") {
									set practitioner."facility_id" = $Number(organizationOri.identifier.%Get(i).value)
									set practitioner.facility = organizationOri.name
								}
							}
						}
					} else {
						set pResponse.exito = 0 // La traza se generará al final del proceso
					}
				}
			}

			if (pResponse.exito = 1) {
				if (hyperobject.practitioner.reference '= "NULL")&&(hyperobject.practitioner.reference '= "") {
					$$$LOGWARNING("2.2 Buscar Practitioner en FHIR")
					set sc = ..getObjHO("/"_hyperobject.practitioner.reference, .pResponse, bp, .practitionerOri)
					if ($$$ISOK(sc)) {
						if (practitionerOri '= "") {
							// Buscar el identificador:
							for i=0:1:practitionerOri.identifier.%Size()-1 {
								if (practitionerOri.identifier.%Get(i).system = "http://hyperobjects/OpenEMR/id") {
									set practitioner.id = practitionerOri.identifier.%Get(i).value
									set practitioner.fname = practitionerOri.name.%Get(0).given.%Get(0)
									set practitioner.lname = practitionerOri.name.%Get(0).family
								}
								if (practitionerOri.identifier.%Get(i).system = "http://hl7.org/fhir/sid/us-npi") {
									set npi = practitionerOri.identifier.%Get(i).value
								}
							}
						}
					} else {
						set pResponse.exito = 0 // La traza se generará al final del proceso
					}
				}
			}			

			if ($$$ISOK(sc)) {
                if (npi '= "") && (npi '= "NULL") {
					$$$LOGWARNING("3. Upsert Practitioner")
					// Crear una request
					set reqWS = ##class(cysnet.openEmr.msg.UpsertRequest).%New()
					if (practitioner.uuid '= "") {
						set reqWS.url = "/api/practitioner/"_practitioner.uuid
						set reqWS.uuid = practitioner.uuid
					} else {
						set reqWS.url = "/api/practitioner"
					}
					set reqWS.body = ##class(%Stream.GlobalCharacter).%New()
					do reqWS.body.Write(practitioner.%ToJSON())

					set sc = bp.SendRequestSync("OpenEMR", reqWS, .rspWS)
					
					if ($$$ISOK(sc)) {
						if (rspWS.exito = 1) {
							// Devolver el ID de OpenEMR
							set pResponse.idConector = rspWS.uuid
							
							// Crear un array dinámico, añadiendo todos los identificadores que queramos añadir (si no existen)
							set sc = ..createIdArray(identificadores, .idArray, 
								"http://hyperobjects/"_pRequest.direccion, pResponse.idConector,
								"http://hyperobjects/"_pRequest.direccion_"/id", rspWS.id
							)
							if ($$$ISERR(sc)) {
								set pResponse.exito = 0 // La traza se generará al final del proceso
							}
						} else {
							set pResponse.exito = 0
							set pResponse.trace = rspWS.trace
						}
					}
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
                } else {
                    $$$LOGASSERT(pRequest.entidad_" no tiene npi. No sincronizar")
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
