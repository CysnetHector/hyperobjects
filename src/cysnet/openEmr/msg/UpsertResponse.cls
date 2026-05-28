Class cysnet.openEmr.msg.UpsertResponse Extends cysnet.rest.msg.RestResponse
{

Property id As %String(MAXLEN = "");

Property uuid As %String(MAXLEN = "");

Storage Default
{
<Data name="UpsertResponseDefaultData">
<Subscript>"UpsertResponse"</Subscript>
<Value name="1">
<Value>id</Value>
</Value>
<Value name="2">
<Value>uuid</Value>
</Value>
</Data>
<DefaultData>UpsertResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
