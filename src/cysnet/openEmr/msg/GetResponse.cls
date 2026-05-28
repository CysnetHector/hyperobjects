Class cysnet.openEmr.msg.GetResponse Extends cysnet.rest.msg.RestResponse
{

Property resource As cysnet.openEmr.msg.struct.Resource;

Storage Default
{
<Data name="GetResponseDefaultData">
<Subscript>"GetResponse"</Subscript>
<Value name="1">
<Value>resource</Value>
</Value>
</Data>
<DefaultData>GetResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
