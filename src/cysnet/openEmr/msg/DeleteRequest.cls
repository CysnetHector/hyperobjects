Class cysnet.openEmr.msg.DeleteRequest Extends Ens.Request
{

Property url As %String(MAXLEN = "");

Storage Default
{
<Data name="DeleteRequestDefaultData">
<Subscript>"DeleteRequest"</Subscript>
<Value name="1">
<Value>url</Value>
</Value>
</Data>
<DefaultData>DeleteRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
