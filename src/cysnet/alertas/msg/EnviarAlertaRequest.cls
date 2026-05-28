Class cysnet.alertas.msg.EnviarAlertaRequest Extends (Ens.Request, %JSON.Adaptor)
{

Property entorno As cysnet.alertas.msg.struct.Entorno;

Property mensaje As cysnet.alertas.msg.struct.Mensaje;

Property infoJira As cysnet.alertas.msg.struct.InfoJira;

Storage Default
{
<Data name="EnviarAlertaRequestDefaultData">
<Subscript>"EnviarAlertaRequest"</Subscript>
<Value name="1">
<Value>entorno</Value>
</Value>
<Value name="2">
<Value>mensaje</Value>
</Value>
<Value name="3">
<Value>infoJira</Value>
</Value>
</Data>
<DefaultData>EnviarAlertaRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
