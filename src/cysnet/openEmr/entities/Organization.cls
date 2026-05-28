Include Ensemble

Class cysnet.openEmr.entities.Organization Extends cysnet.hyperobjects.util.Util
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
		// Si la Organization es de tipo Departamento:
		#; if (hyperobject.%IsDefined("type"))&&(hyperobject.type.%Size() > 0)&&(hyperobject.type.%Get(0).coding.%Size() > 0)&&(hyperobject.type.%Get(0).coding.%Get(0).code = "dept") {
			if ((pRequest.accion = "I")||(pRequest.accion = "U")) { // Acción Upsert
				set facility = {}

				$$$LOGWARNING("1. Crear objeto Facility")
				set sc = ..createConnectorObject("cysnet.openEmr.dtl.OrganizationToFacility", hyperobject, .facility)

				if ($$$ISOK(sc)) {
					$$$LOGWARNING("2. Upsert Facility")

					if (facility."facility_npi" '= "") && (facility."facility_npi" '= "NULL") {
						// Crear una request
						set reqWS = ##class(cysnet.openEmr.msg.UpsertRequest).%New()
						if (facility.uuid '= "") {
							$$$LOGINFO("UPDATE")
							set reqWS.url = "/api/facility/"_facility.uuid
							set reqWS.uuid = facility.uuid
						} else {
							$$$LOGINFO("INSERT")
							set reqWS.url = "/api/facility"
						}
						set reqWS.body = ##class(%Stream.GlobalCharacter).%New()
						do reqWS.body.Write(facility.%ToJSON())

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
						$$$LOGASSERT("Organization no tiene facility_npi. No sincronizar")
					}

				}
				
			} else {
				$$$LOGASSERT(pRequest.entidad_": Acción no controlada: "_pRequest.accion)
			}
		#; } else {
		#; 	$$$LOGASSERT("Organization no es de tipo dept. No sincronizar")
		#; }

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}

	return sc
}

}
