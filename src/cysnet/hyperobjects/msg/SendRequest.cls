Class cysnet.hyperobjects.msg.SendRequest Extends Ens.Request
{

Property verb As %String;

Property url As %String(MAXLEN = "");

Property body As %Stream.GlobalCharacter;

/// Lista de parámetros para el header
Property headerParams As list Of cysnet.rest.msg.struct.CampoValor;

/// Lista de parámetros
Property params As list Of cysnet.rest.msg.struct.CampoValor;

Storage Default
{
<Data name="SendRequestDefaultData">
<Subscript>"SendRequest"</Subscript>
<Value name="1">
<Value>verb</Value>
</Value>
<Value name="2">
<Value>url</Value>
</Value>
<Value name="3">
<Value>body</Value>
</Value>
<Value name="4">
<Value>headerParams</Value>
</Value>
<Value name="5">
<Value>params</Value>
</Value>
</Data>
<DefaultData>SendRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
