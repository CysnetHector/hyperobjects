Class cysnet.audit.msg.SyncAuditResponse Extends (Ens.Response, %JSON.Adaptor)
{

Property done As %Boolean;

Storage Default
{
<Data name="StartSyncResponseDefaultData">
<Subscript>"StartSyncResponse"</Subscript>
<Value name="1">
<Value>done</Value>
</Value>
</Data>
<DefaultData>StartSyncResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
