Class cysnet.alertas.msg.EnviarAlertaResponse Extends (Ens.Response, %JSON.Adaptor)
{

Property exito As %Boolean;

Property trace As cysnet.alertas.msg.struct.Trace;

Storage Default
{
<Data name="EnviarAlertaResponseDefaultData">
<Subscript>"EnviarAlertaResponse"</Subscript>
<Value name="1">
<Value>exito</Value>
</Value>
<Value name="2">
<Value>trace</Value>
</Value>
</Data>
<DefaultData>EnviarAlertaResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
