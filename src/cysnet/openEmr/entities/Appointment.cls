Include Ensemble

Class cysnet.openEmr.entities.Appointment Extends cysnet.hyperobjects.util.Util
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
		if (pRequest.accion = "I") { // Acción Insert
			$$$LOGWARNING(pRequest.entidad_": Acción '"_pRequest.accion_"' no permitida")

			set cita = {}
			set patientOri = ""
			set practitionerOri = ""
			set practitionerRoleOri = ""

			$$$LOGWARNING("1. Crear objeto Appointment")
			set sc = ..createConnectorObject("cysnet.openEmr.dtl.HyperObjectsToAppointment", hyperobject, .cita)
			if ($$$ISERR(sc)) {
				set pResponse.exito = 0 // La traza se generará al final del proceso
			}

			if (pResponse.exito = 1) {
				if (hyperobject.participant.%Size() > 0) {
					$$$LOGWARNING("2 Recorrer participants")
					for i=0:1:hyperobject.participant.%Size()-1 {
						if (hyperobject.participant.%Get(i).actor '= "")&&(hyperobject.participant.%Get(i).actor.type = "Patient") {
							$$$LOGWARNING("2."_i_" Comprobar si hay que buscar Patient en FHIR")
							// Si hay centro: buscar su recurso FHIR:
							if (hyperobject.participant.%Get(i).actor.reference '= "NULL")&&(hyperobject.participant.%Get(i).actor.reference '= "") {
								$$$LOGWARNING("2."_i_".1 Buscar Patient en FHIR")
								set sc = ..getObjHO("/"_hyperobject.participant.%Get(i).actor.reference, .pResponse, bp, .patientOri)
								if ($$$ISOK(sc)) {
									if (patientOri '= "") {
										// Buscar el identificador:
										for j=0:1:patientOri.identifier.%Size()-1 {
											if (patientOri.identifier.%Get(j).system = "http://hyperobjects/OpenEMR") {
												set cita.puuid = patientOri.identifier.%Get(j).value
												
											} elseif (patientOri.identifier.%Get(j).system = "http://hyperobjects/OpenEMR/pid") {
												set cita.pid = $Number(patientOri.identifier.%Get(j).value)
											}

										}
									}
								} else {
									set pResponse.exito = 0 // La traza se generará al final del proceso
								}
							}
						}
						elseif (hyperobject.participant.%Get(i).actor '= "")&&(hyperobject.participant.%Get(i).actor.type = "Practitioner") {
							$$$LOGWARNING("2."_i_" Comprobar si hay que buscar Practitioner en FHIR")
							// Si hay centro: buscar su recurso FHIR:
							if (hyperobject.participant.%Get(i).actor.reference '= "NULL")&&(hyperobject.participant.%Get(i).actor.reference '= "") {
								$$$LOGWARNING("2."_i_".1 Buscar Practitioner en FHIR")
								set sc = ..getObjHO("/"_hyperobject.participant.%Get(i).actor.reference, .pResponse, bp, .practitionerOri)
								if ($$$ISOK(sc)) {
									if (practitionerOri '= "") {
										// Buscar el identificador:
										for j=0:1:practitionerOri.identifier.%Size()-1 {
											if (practitionerOri.identifier.%Get(j).system = "http://hyperobjects/OpenEMR") {
												set cita."pce_aid_uuid" = practitionerOri.identifier.%Get(j).value
											}
										}
									}
								} else {
									set pResponse.exito = 0 // La traza se generará al final del proceso
								}
							}
						}
						elseif (hyperobject.participant.%Get(i).actor '= "")&&(hyperobject.participant.%Get(i).actor.type = "PractitionerRole") {
							$$$LOGWARNING("2."_i_" Comprobar si hay que buscar Practitioner en FHIR")
							// Si hay centro: buscar su recurso FHIR:
							if (hyperobject.participant.%Get(i).actor.reference '= "NULL")&&(hyperobject.participant.%Get(i).actor.reference '= "") {
								$$$LOGWARNING("2."_i_".1 Buscar PractitionerRole en FHIR")
								set sc = ..getObjHO("/"_hyperobject.participant.%Get(i).actor.reference, .pResponse, bp, .practitionerRoleOri)
								if ($$$ISOK(sc)) {
									if (practitionerRoleOri '= "") {
										// Buscar el identificador:
										for j=0:1:practitionerRoleOri.identifier.%Size()-1 {
											if (practitionerRoleOri.identifier.%Get(j).system = "http://hyperobjects/OpenEMR/PFids") {
												set cita."pc_aid" = $Number($P(practitionerRoleOri.identifier.%Get(j).value,"__",1))
												set cita."pc_facility" = $Number($P(practitionerRoleOri.identifier.%Get(j).value,"__",2))
											}
										}
									}
								} else {
									set pResponse.exito = 0 // La traza se generará al final del proceso
								}
							}
						}
					} 
				}
			}

			if (pResponse.exito = 1) {
				$$$LOGWARNING("3. Upsert Appointment")
				// Crear una request
				set reqWS = ##class(cysnet.openEmr.msg.UpsertRequest).%New()
				set reqWS.url = "/api/patient/"_cita.pid_"/appointment"
				if (cita."pc_eid" '= "") {
					set reqWS.url = reqWS.url_"/"_cita."pc_eid"
					set reqWS.uuid = cita."pc_eid"
				}
				set reqWS.body = ##class(%Stream.GlobalCharacter).%New()
				do reqWS.body.Write(cita.%ToJSON())

				if (cita."pc_eid" '= "") {
					$$$LOGWARNING(pRequest.entidad_": La cita ya existe en OpenEMR ("_cita."pc_eid"_"). Acción 'U' no permitida")
					$$$LOGINFO(cita.%ToJSON())
					$$$LOGINFO(reqWS.url)
				} else {
					set sc = bp.SendRequestSync("OpenEMR", reqWS, .rspWS)
					
					if ($$$ISOK(sc)) {
						if (rspWS.exito = 1) {
							// Devolver el ID de OpenEMR
							// NOTA: En Appointment solamente se devuelve el id. El UUID no se devuelve
							set pResponse.idConector = rspWS.id

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
			}
			
		} else {
			$$$LOGASSERT(pRequest.entidad_": Acción no controlada: "_pRequest.accion)
		}
	} catch (err) {
		set sc = $SYSTEM.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	return sc
}

}
