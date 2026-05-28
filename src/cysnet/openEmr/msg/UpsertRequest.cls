Class cysnet.openEmr.msg.UpsertRequest Extends Ens.Request
{

Property url As %String(MAXLEN = "");

Property uuid As %String(MAXLEN = "");

Property body As %Stream.GlobalCharacter;

Storage Default
{
<Data name="UpsertRequestDefaultData">
<Subscript>"UpsertRequest"</Subscript>
<Value name="1">
<Value>url</Value>
</Value>
<Value name="2">
<Value>uuid</Value>
</Value>
<Value name="3">
<Value>body</Value>
</Value>
</Data>
<DefaultData>UpsertRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
