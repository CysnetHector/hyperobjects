Class cysnet.hyperobjects.msg.UpsertResponse Extends cysnet.rest.msg.RestResponse
{

Property resourceURL As %String(MAXLEN = "");

Storage Default
{
<Data name="UpsertResponseDefaultData">
<Subscript>"UpsertResponse"</Subscript>
<Value name="1">
<Value>resourceURL</Value>
</Value>
</Data>
<DefaultData>UpsertResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
