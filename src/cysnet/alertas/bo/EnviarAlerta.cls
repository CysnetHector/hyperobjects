Class cysnet.alertas.bo.EnviarAlerta Extends cysnet.rest.bo.RestManager
{

Parameter SETTINGS = "Remitente,Destinatario,EmailIntegraciones,EmailGuardia,EmailCustom";

/// Email remitente
Property Remitente As %String(MAXLEN = "");

/// Email al que enviar las alertas
Property Destinatario As %String(MAXLEN = "");

/// Email integraciones
Property EmailIntegraciones As %String(MAXLEN = "");

/// Email guardia
Property EmailGuardia As %String(MAXLEN = "");

/// Email custom
Property EmailCustom As %String(MAXLEN = "");

Method enviarAlerta(pRequest As cysnet.alertas.msg.EnviarAlertaRequest, Output pResponse As cysnet.alertas.msg.EnviarAlertaResponse) As %Status
{
	quit ##class(cysnet.alertas.bo.core.EnviarAlertaCore).enviarAlerta(pRequest, .pResponse, $this)
}

Method enviarAlertaError(pRequest As Ens.AlertRequest, Output pResponse As cysnet.alertas.msg.EnviarAlertaResponse) As %Status
{
	quit ##class(cysnet.alertas.bo.core.EnviarAlertaCore).enviarAlertaError(pRequest, .pResponse, $this)
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="cysnet.alertas.msg.EnviarAlertaRequest"> 
		<Method>enviarAlerta</Method>
	</MapItem>
	<MapItem MessageType="Ens.AlertRequest"> 
		<Method>enviarAlertaError</Method>
	</MapItem>
</MapItems>
}

}
