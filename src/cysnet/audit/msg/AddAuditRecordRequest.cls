Class cysnet.audit.msg.AddAuditRecordRequest Extends Ens.Request
{

Property jsonAudit As %Stream.GlobalCharacter;

Storage Default
{
<Data name="AddAuditRecordRequestDefaultData">
<Subscript>"AddAuditRecordRequest"</Subscript>
<Value name="1">
<Value>jsonAudit</Value>
</Value>
</Data>
<DefaultData>AddAuditRecordRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
