Class cysnet.hyperobjects.entities.TestEntities Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As Ens.StringRequest, Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse) As %Status
{
	set pResponse = ##class(cysnet.syncEngine.core.msg.SincronizarEntidadResponse).%New()

	if (pRequest.StringValue = "") {
		set pRequest.StringValue = "Patient"
	}
	$$$LOGWARNING("Probando "_pRequest.StringValue_", hacia HyperObjects")

	if (pRequest.StringValue = "Patient") {
		do ..testPatient(.pResponse)
	} else {
		$$$LOGALERT("Entidad "_pRequest.StringValue_" no controlada")
	}

	quit $$$OK
}

Method testPatient(Output pResponse As cysnet.syncEngine.core.msg.SincronizarEntidadResponse) As %Status
{
	set hyperobject = {}.%FromJSON(^cysnet.sync.Patient("HO",1025))

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
	set req.direccion = "HO"
	set req.entidad = "Patient"
	set req.id = 1025
	set req.idTransaccion = $System.Util.CreateGUID()
	set req.paquete = "hyperobjects"
	set req.paso = 0

	return ##class(cysnet.hyperobjects.entities.HyperObjects).syncEntity(req, hyperobject, identificadores, .pResponse, $this)
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
