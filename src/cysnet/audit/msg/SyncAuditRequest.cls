Class cysnet.audit.msg.SyncAuditRequest Extends Ens.Request
{

Property maxitems As %Integer;

Storage Default
{
<Data name="SyncAuditRequestDefaultData">
<Subscript>"SyncAuditRequest"</Subscript>
<Value name="1">
<Value>maxitems</Value>
</Value>
</Data>
<DefaultData>SyncAuditRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
