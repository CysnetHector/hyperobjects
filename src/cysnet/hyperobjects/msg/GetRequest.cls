Class cysnet.hyperobjects.msg.GetRequest Extends Ens.Request
{

Property url As %String(MAXLEN = "");

Storage Default
{
<Data name="GetRequestDefaultData">
<Subscript>"GetRequest"</Subscript>
<Value name="1">
<Value>url</Value>
</Value>
</Data>
<DefaultData>GetRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
