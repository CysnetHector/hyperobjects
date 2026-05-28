Class cysnet.openEmr.msg.SearchStandardResponse Extends (cysnet.rest.msg.RestResponse, %JSON.Adaptor)
{

Property total As %Integer [ InitialExpression = 0 ];

Property data As list Of cysnet.openEmr.msg.struct.Resource;

Storage Default
{
<Data name="SearchStandardResponseDefaultData">
<Subscript>"SearchStandardResponse"</Subscript>
<Value name="1">
<Value>total</Value>
</Value>
<Value name="2">
<Value>data</Value>
</Value>
</Data>
<DefaultData>SearchStandardResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
