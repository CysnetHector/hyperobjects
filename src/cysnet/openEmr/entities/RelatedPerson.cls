Include Ensemble

Class cysnet.openEmr.entities.RelatedPerson Extends cysnet.openEmr.util.Util
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
			set paciente = {}
			set fhirPacienteOri = ""
			set pacienteOri = ""
			set pacienteID = ""

			if (pResponse.exito = 1) {
				$$$LOGWARNING("1. Comprobar si hay que crear/actualizar el Patient...")
				// Si hay empleado: buscar su recurso FHIR:
				if (hyperobject.patient.reference '= "NULL")&&(hyperobject.patient.reference '= "") {
					$$$LOGWARNING("1.1 Buscar PatientReference en HO")
					set sc = ..getObjHO("/"_hyperobject.patient.reference, .pResponse, bp, .fhirPacienteOri)
					if ($$$ISERR(sc)) {
						set pResponse.exito = 0 // La traza se generará al final del proceso
					} else {
						// Si tenemos identifiers, buscar el relativo al conector:
						if (fhirPacienteOri '= "")&&(fhirPacienteOri.identifier '= "")&&(fhirPacienteOri.identifier.%Size() > 0) {
							For i=0:1:fhirPacienteOri.identifier.%Size()-1 {
								if (fhirPacienteOri.identifier.%Get(i).system = ("http://hyperobjects/OpenEMR")) {
									set paciente.uuid = fhirPacienteOri.identifier.%Get(i).value
								}
							}
						}
					}
				}
			}

			if (identificadores.%Get("OpenEMR") '= "") {
				set pacienteID = identificadores.%Get("OpenEMR")
			} elseif (paciente.uuid '= "") {
				set pacienteID = paciente.uuid
			}
			
			if (pacienteID '= "") {
				$$$LOGWARNING("2. Obtener el paciente original ("_pacienteID_")")
				set sc = ..get("/api/patient/"_pacienteID, .pResponse, bp, .objID, .pacienteOri)
				if ($$$ISERR(sc)) {
					set pResponse.exito = 0 // La traza se generará al final del proceso
				} else {
					// Copiamos el objeto original en el que vamos a transformar (para no perder los valores originales)
					set strm = ##class(%Stream.TmpCharacter).%New()
					do pacienteOri.%ToJSON(strm)
					set paciente = ##class(%DynamicAbstractObject).%FromJSON(strm)
				}
			}

			if (pResponse.exito = 1) {
				$$$LOGWARNING("3. Crear objeto Patient")
				set sc = ..createConnectorObject("cysnet.openEmr.dtl.RelatedPersonToPatient", hyperobject, .paciente)
				if ($$$ISERR(sc)) {
					set pResponse.exito = 0 // La traza se generará al final del proceso
				}
			}

			if (pResponse.exito = 1) {
				$$$LOGWARNING("4. Comprobar si hay cambios")
				if (..checkChanges(pacienteOri, paciente)) {
					$$$LOGWARNING("5. Upsert Patient")
					// Crear una request
					set reqWS = ##class(cysnet.openEmr.msg.UpsertRequest).%New()
					if (paciente.uuid '= "") {
						set reqWS.url = "/api/patient/"_paciente.uuid
						set reqWS.uuid = paciente.uuid
					} else {
						set reqWS.url = "/api/patient"
					}
					set reqWS.body = ##class(%Stream.GlobalCharacter).%New()
					do reqWS.body.Write(paciente.%ToJSON())

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
					$$$LOGASSERT("No hay cambios en "_pRequest.entidad_". Seguir")
				}
			}
			
		} else {
			$$$LOGASSERT(pRequest.entidad_": Acción no controlada: "_pRequest.accion)
		}
	} catch (err) {
		set sc = $SYSTEM.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	Return sc
}

}
