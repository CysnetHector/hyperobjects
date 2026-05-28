Class cysnet.rest.msg.RestRequest Extends Ens.Request
{

Property url As %String(MAXLEN = "");

Property method As %String(MAXLEN = "");

Property input As %Stream.GlobalCharacter;

/// Lista de parámetros para el header
Property headerParams As list Of cysnet.rest.msg.struct.CampoValor;

/// Lista de parámetros
Property params As list Of cysnet.rest.msg.struct.CampoValor;

Property contentType As %String(MAXLEN = "");

/// Clase proxy para parsear la respuesta
Property proxyClass As %String(MAXLEN = "");

Storage Default
{
<Data name="RestRequestDefaultData">
<Subscript>"RestRequest"</Subscript>
<Value name="1">
<Value>url</Value>
</Value>
<Value name="2">
<Value>method</Value>
</Value>
<Value name="3">
<Value>input</Value>
</Value>
<Value name="4">
<Value>headerParams</Value>
</Value>
<Value name="5">
<Value>params</Value>
</Value>
<Value name="6">
<Value>contentType</Value>
</Value>
<Value name="7">
<Value>proxyClass</Value>
</Value>
</Data>
<DefaultData>RestRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
