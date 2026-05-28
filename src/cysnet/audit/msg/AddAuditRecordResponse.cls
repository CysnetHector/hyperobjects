Class cysnet.audit.msg.AddAuditRecordResponse Extends (Ens.Response, %JSON.Adaptor)
{

Property done As %Boolean;

Property error As %String(MAXLEN = "");

Storage Default
{
<Data name="AddAuditResponseDefaultData">
<Subscript>"AddAuditResponse"</Subscript>
<Value name="1">
<Value>done</Value>
</Value>
<Value name="2">
<Value>error</Value>
</Value>
</Data>
<DefaultData>AddAuditResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
