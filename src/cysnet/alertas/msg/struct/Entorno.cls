Class cysnet.alertas.msg.struct.Entorno Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property namespace As %String(MAXLEN = "");

Property produccion As %String(MAXLEN = "");

Property instancia As %String(MAXLEN = "");

Property nodo As %String(MAXLEN = "");

Property origen As %String(MAXLEN = "");

Property hora As %String(MAXLEN = "");

Storage Default
{
<Data name="EntornoState">
<Value name="1">
<Value>namespace</Value>
</Value>
<Value name="2">
<Value>produccion</Value>
</Value>
<Value name="3">
<Value>instancia</Value>
</Value>
<Value name="4">
<Value>nodo</Value>
</Value>
<Value name="5">
<Value>origen</Value>
</Value>
<Value name="6">
<Value>hora</Value>
</Value>
</Data>
<State>EntornoState</State>
<StreamLocation>^cysnet.alertas.msgC1E2.EntornoS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
