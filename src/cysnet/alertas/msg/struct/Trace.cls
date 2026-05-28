Class cysnet.alertas.msg.struct.Trace Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property errors As list Of cysnet.alertas.msg.struct.Error;

Property date As %DateTime;

Property stage As %String(MAXLEN = "");

Storage Default
{
<Data name="TraceState">
<Value name="1">
<Value>errors</Value>
</Value>
<Value name="2">
<Value>date</Value>
</Value>
<Value name="3">
<Value>stage</Value>
</Value>
</Data>
<State>TraceState</State>
<StreamLocation>^cysnet.alertas.msg.sC1E2.TraceS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
