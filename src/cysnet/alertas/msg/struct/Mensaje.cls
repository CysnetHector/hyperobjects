Class cysnet.alertas.msg.struct.Mensaje Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property remitente As %String(MAXLEN = "");

Property destinatario As %String(MAXLEN = "");

Property asunto As %String(MAXLEN = "");

Property mensaje As %String(MAXLEN = "");

Property nextAviso As %String(MAXLEN = "");

/// 0: Crítica, 1: Alta, 2: Normal, 3: Baja, 4: Trivial
Property prioridad As %Integer [ InitialExpression = 2 ];

Storage Default
{
<Data name="MensajeState">
<Value name="1">
<Value>remitente</Value>
</Value>
<Value name="2">
<Value>destinatario</Value>
</Value>
<Value name="3">
<Value>asunto</Value>
</Value>
<Value name="4">
<Value>mensaje</Value>
</Value>
<Value name="5">
<Value>nextAviso</Value>
</Value>
<Value name="6">
<Value>prioridad</Value>
</Value>
</Data>
<State>MensajeState</State>
<StreamLocation>^cysnet.alertas.msgC1E2.MensajeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
