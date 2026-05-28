Class cysnet.hyperobjects.msg.SearchResponse Extends (cysnet.rest.msg.RestResponse, %JSON.Adaptor)
{

Property total As %Integer [ InitialExpression = 0 ];

Property nextLink As %String(MAXLEN = "");

Property entry As list Of cysnet.hyperobjects.msg.struct.Resource;

Storage Default
{
<Data name="SearchResponseDefaultData">
<Subscript>"SearchResponse"</Subscript>
<Value name="1">
<Value>total</Value>
</Value>
<Value name="2">
<Value>nextLink</Value>
</Value>
<Value name="3">
<Value>entry</Value>
</Value>
</Data>
<DefaultData>SearchResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
