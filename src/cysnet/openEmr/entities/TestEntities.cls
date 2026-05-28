Class cysnet.openEmr.entities.TestEntities Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As Ens.StringRequest, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse) As %Status
{
	set pResponse = ##class(cysnet.syncEngine.core.msg.SincronizarEntidadResponse).%New()

	$$$LOGWARNING("Probando "_pRequest.StringValue_", de HyperObjects hacia OpenEmr")

	if (pRequest.StringValue = "Practitioner") {
		do ..testPractitioner(.pResponse)
	} elseif (pRequest.StringValue = "Patient") {
		do ..testPatient(.pResponse)
	} else {
		$$$LOGALERT("Entidad "_pRequest.StringValue_" no controlada")
	}

	quit $$$OK
}

Method testPractitioner(Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse) As %Status
{
	set hyperobject = {
		"resourceType": "Organization",
		"text": {
			"status": "generated",
			"div": "&lt;div xmlns=\"http://www.w3.org/1999/xhtml\"&gt;&lt;p&gt;Organization (type = prov)&lt;/p&gt;&lt;/div&gt;"
		},
		"identifier": [
			{
				"system": "http://hyperobjects/HIS",
				"value": "2"
			}
		],
		"name": "Madrid",
		"type": [
			{
				"coding": [
					{
						"system": "http://terminology.hl7.org/CodeSystem/organization-type",
						"code": "prov",
						"display": "Healthcare Provider"
					}
				]
			}
		],
		"active": true,
		"id": "8"
	}

	// Obtener lista identificadores (si tiene):
	set identificadores = {}
	if (hyperobject.identifier '= "") {
		for i=0:1:hyperobject.identifier.%Size()-1 {
			do identificadores.%Set($Replace(hyperobject.identifier.%Get(i).system,"http://hyperobjects/",""), hyperobject.identifier.%Get(i).value)
		}
	}

	// Para probar desde HyperObjects a OpenEmr:
	set req = ##class(cysnet.syncEngine.core.msg.SincronizarEntidadRequest).%New()
	set req.accion = "I"
	set req.direccion = "OpenEMR"
	set req.entidad = "Practitioner"
	set req.id = 1
	set req.idTransaccion = $System.Util.CreateGUID()
	set req.paquete = "openEmr"
	set req.paso = 0

	quit ##class(cysnet.openEmr.entities.Practitioner).syncEntity(req, hyperobject, identificadores, .rsp, $this)
}

Method testPatient(Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse) As %Status
{
	set hyperobject = {}.%FromJSON(^cysnet.sync.Patient("HO",1028))

	// Obtener lista identificadores (si tiene):
	set identificadores = {}
	if (hyperobject.identifier '= "") {
		for i=0:1:hyperobject.identifier.%Size()-1 {
			do identificadores.%Set($Replace(hyperobject.identifier.%Get(i).system,"http://hyperobjects/",""), hyperobject.identifier.%Get(i).value)
		}
	}

	// Para probar desde HyperObjects a OpenEmr:
	set req = ##class(cysnet.syncEngine.core.msg.SincronizarEntidadRequest).%New()
	set req.accion = "I"
	set req.direccion = "OpenEMR"
	set req.entidad = "Patient"
	set req.id = 1
	set req.idTransaccion = $System.Util.CreateGUID()
	set req.paquete = "openEmr"
	set req.paso = 0

	return ##class(cysnet.openEmr.entities.Patient).syncEntity(req, hyperobject, identificadores, .pResponse, $this)
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
