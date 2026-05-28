Include Ensemble

Class cysnet.alertas.bo.core.EnviarAlertaCore Extends %RegisteredObject
{

ClassMethod enviarAlerta(pRequest As cysnet.alertas.msg.EnviarAlertaRequest, Output pResponse As cysnet.alertas.msg.EnviarAlertaResponse, bo As cysnet.alertas.bo.EnviarAlerta) As %Status
{
	set pRequest.entorno.namespace = $Namespace
	set pRequest.entorno.produccion = $get($$$EnsRuntime("Name"))
	set pRequest.entorno.instancia = ##class(%SYS.System).GetInstanceName()
	set pRequest.entorno.nodo = ##class(%SYS.System).GetNodeName()
	set pRequest.entorno.hora = $ZDT($H,3)
	
	if (pRequest.mensaje.destinatario = "integraciones") {
		set pRequest.mensaje.destinatario = bo.EmailIntegraciones
	}
	if (pRequest.mensaje.destinatario = "guardia") {
		set pRequest.mensaje.destinatario = bo.EmailGuardia
	}
	if (pRequest.mensaje.destinatario = "custom") {
		set pRequest.mensaje.destinatario = bo.EmailCustom
	}
	if (pRequest.mensaje.destinatario = "") {
		set pRequest.mensaje.destinatario = bo.Destinatario
	}
	if (pRequest.mensaje.remitente = "") {
		set pRequest.mensaje.remitente = bo.Remitente
	}
	
	if (pRequest.mensaje.destinatario = "no-enviar") {
		$$$LOGINFO("No enviar mensaje. Destinatario = no-enviar")
		quit $$$OK
	} else {
		set pRequest.mensaje.mensaje = ..limpiarMensaje(pRequest.mensaje.mensaje)
		
		quit ..sendAlert(pRequest, .pResponse, bo)
	}
	
	quit $$$OK
}

ClassMethod enviarAlertaError(pRequest As Ens.AlertRequest, Output pResponse As cysnet.alertas.msg.EnviarAlertaResponse, bo As cysnet.alertas.bo.EnviarAlerta) As %Status
{
	set req = ##class(cysnet.alertas.msg.EnviarAlertaRequest).%New()
	set req.entorno.namespace = $Namespace
	set req.entorno.produccion = $get($$$EnsRuntime("Name"))
	set req.entorno.instancia = ##class(%SYS.System).GetInstanceName()
	set req.entorno.nodo = ##class(%SYS.System).GetNodeName()
	set req.entorno.hora = $ZDT($H,3)
	set req.mensaje.destinatario = pRequest.AlertDestination
	if (req.mensaje.destinatario = "") {
		set req.mensaje.destinatario = bo.Destinatario
	}
	set req.mensaje.remitente = bo.Remitente
	set req.mensaje.asunto = req.entorno.namespace_": Ensemble alert from "_pRequest.SourceConfigName
	set req.mensaje.mensaje = ..limpiarMensaje("[Error en "_pRequest.SourceConfigName_"] "_pRequest.AlertText)
	
	quit ..sendAlert(req, .pResponse, bo)
}

ClassMethod sendAlert(pRequest As cysnet.alertas.msg.EnviarAlertaRequest, Output pResponse As cysnet.alertas.msg.EnviarAlertaResponse, bo As cysnet.alertas.bo.EnviarAlerta) As %Status
{
	#dim sc As %Status = $$$OK
	#dim proxyManager As cysnet.rest.proxy.Rest
	
	set pResponse = ##class(cysnet.alertas.msg.EnviarAlertaResponse).%New()
	set pResponse.exito = 1
	
	try {
		set proxyManager = ##class(cysnet.rest.proxy.Rest).%New()
		
		set sc = bo.runMethod(proxyManager, pRequest, "/enviar", "POST", "application/json;charset=UTF-8")
		if ($$$ISOK(sc)) {
			set pResponse = proxyManager.response
		}

	} catch (err) {
		set sc = $system.Status.Error(err.Code,err.Name,err.Location,err.InnerException)
	}
	
	if ($$$ISERR(sc)) {
		set pResponse.exito = 0
		set pResponse.trace = ##class(cysnet.rest.msg.struct.Trace).generarTraza("Alertas", "Error en enviarAlerta: "_$System.Status.GetErrorText(sc))
	}
	
	quit $$$OK
}

/// Quitar del mensaje todos aquellos caracteres que no son válidos:
ClassMethod limpiarMensaje(texto As %String) As %String
{
	#dim i As %Integer = 0
	
	// Códigos ASCII del 0 al 8
	for i=0:1:8 {
		set texto = $Replace(texto, $Char(i), "")
	}
	// Código ASCII 11
	set texto = $Replace(texto, $Char(11), "")
	// Código ASCII 12
	set texto = $Replace(texto, $Char(12), "")
	// Códigos ASCII del 14 al 31
	for i=14:1:31 {
		set texto = $Replace(texto, $Char(i), "")
	}
	
	quit texto
}

}
