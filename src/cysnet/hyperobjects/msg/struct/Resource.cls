Class cysnet.hyperobjects.msg.struct.Resource Extends (%SerialObject, %XML.Adaptor)
{

Property fullUrl As %String(MAXLEN = "");

Property resourceType As %String(MAXLEN = "");

Property id As %String(MAXLEN = "");

Property lastUpdated As %TimeStamp;

Property versionId As %String(MAXLEN = "");

Property content As %Stream.GlobalCharacter;

Storage Default
{
<Data name="ResourceState">
<Value name="1">
<Value>fullUrl</Value>
</Value>
<Value name="2">
<Value>resourceType</Value>
</Value>
<Value name="3">
<Value>id</Value>
</Value>
<Value name="4">
<Value>lastUpdated</Value>
</Value>
<Value name="5">
<Value>versionId</Value>
</Value>
<Value name="6">
<Value>content</Value>
</Value>
</Data>
<State>ResourceState</State>
<StreamLocation>^cysnet.hyperobjectE39.ResourceS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
