Class cysnet.audit.msg.ErrorResponse Extends (Ens.Response, %JSON.Adaptor)
{

Property error As %String(MAXLEN = "");

Storage Default
{
<Data name="ErrorResponseDefaultData">
<Subscript>"ErrorResponse"</Subscript>
<Value name="1">
<Value>error</Value>
</Value>
</Data>
<DefaultData>ErrorResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
