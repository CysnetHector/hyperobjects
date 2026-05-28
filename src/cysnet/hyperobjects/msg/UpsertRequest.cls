Class cysnet.hyperobjects.msg.UpsertRequest Extends Ens.Request
{

Property url As %String(MAXLEN = "");

Property body As %Stream.GlobalCharacter;

Storage Default
{
<Data name="UpsertRequestDefaultData">
<Subscript>"UpsertRequest"</Subscript>
<Value name="1">
<Value>url</Value>
</Value>
<Value name="2">
<Value>body</Value>
</Value>
</Data>
<DefaultData>UpsertRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
