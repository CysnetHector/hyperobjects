Class cysnet.rest.msg.RestResponse Extends Ens.Response
{

Property exito As %Boolean;

Property trace As cysnet.rest.msg.struct.Trace;

Property statusCode As %String(MAXLEN = "");

Property codError As %Integer;

Property msg As %String(MAXLEN = "");

Property objRsp As Ens.Response;

Property output As %Stream.GlobalCharacter;

/// Lista de cabeceras en la respuesta
Property rspHeaders As list Of cysnet.rest.msg.struct.CampoValor;

Method asignarExitoOk()
{
	set ..exito = 1
	set ..msg = "Operación realizada con éxito"
	set ..codError = 1000
}

Method asignarExitoKo(msg As %String, codError As %Integer)
{
	set ..exito = 0
	set ..msg = msg
	set ..codError = codError
}

Storage Default
{
<Data name="RestResponseDefaultData">
<Subscript>"RestResponse"</Subscript>
<Value name="1">
<Value>exito</Value>
</Value>
<Value name="2">
<Value>trace</Value>
</Value>
<Value name="3">
<Value>statusCode</Value>
</Value>
<Value name="4">
<Value>codError</Value>
</Value>
<Value name="5">
<Value>msg</Value>
</Value>
<Value name="6">
<Value>objRsp</Value>
</Value>
<Value name="7">
<Value>output</Value>
</Value>
<Value name="8">
<Value>rspHeaders</Value>
</Value>
</Data>
<DefaultData>RestResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
