Class cysnet.hyperobjects.msg.SearchRequest Extends Ens.Request
{

Property url As %String(MAXLEN = "");

Storage Default
{
<Data name="SearchRequestDefaultData">
<Subscript>"SearchRequest"</Subscript>
<Value name="1">
<Value>url</Value>
</Value>
</Data>
<DefaultData>SearchRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
