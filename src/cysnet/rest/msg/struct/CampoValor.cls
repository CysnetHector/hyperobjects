Class cysnet.rest.msg.struct.CampoValor Extends (%SerialObject, %XML.Adaptor)
{

Property campo As %String(MAXLEN = "");

Property valor As %String(MAXLEN = "");

ClassMethod createNew(campo As %String, valor As %String) As cysnet.rest.msg.struct.CampoValor
{
	#dim cp As cysnet.rest.msg.struct.CampoValor
	
	set cp = ##class(cysnet.rest.msg.struct.CampoValor).%New()
	set cp.campo = campo
	set cp.valor = valor
	
	quit cp
}

Storage Default
{
<Data name="CampoValorState">
<Value name="1">
<Value>campo</Value>
</Value>
<Value name="2">
<Value>valor</Value>
</Value>
</Data>
<State>CampoValorState</State>
<StreamLocation>^cysnet.rest.msgE509.CampoValorS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
