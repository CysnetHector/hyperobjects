Class cysnet.rest.msg.RestBaseRequest Extends Ens.Request
{

/// Origen de la petición: Soap, Rest, HL7, ASTM, XML...
Property origen As %String(MAXLEN = "");

/// Método invocado (para servicios Soap, Rest)
Property metodo As %String(MAXLEN = "");

/// Destino de la petición (Nombre de la operación)
Property destino As %String(MAXLEN = "");

/// Contenido del mensaje de entrada
Property input As %Library.AbstractStream;

/// Lista de parámetros
Property params As list Of cysnet.rest.msg.struct.CampoValor;

/// Lista de parámetros para el header
Property headerParams As list Of cysnet.rest.msg.struct.CampoValor;

/// IP que realiza la petición
Property ipOrigen As %String(MAXLEN = "");

Storage Default
{
<Data name="RestBaseRequestDefaultData">
<Subscript>"RestBaseRequest"</Subscript>
<Value name="1">
<Value>origen</Value>
</Value>
<Value name="2">
<Value>metodo</Value>
</Value>
<Value name="3">
<Value>destino</Value>
</Value>
<Value name="4">
<Value>input</Value>
</Value>
<Value name="5">
<Value>params</Value>
</Value>
<Value name="6">
<Value>headerParams</Value>
</Value>
<Value name="7">
<Value>ipOrigen</Value>
</Value>
</Data>
<DefaultData>RestBaseRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
