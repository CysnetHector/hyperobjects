Class cysnet.openEmr.msg.GetTokenResponse Extends cysnet.rest.msg.RestResponse
{

Property token As %String(MAXLEN = "");

Storage Default
{
<Data name="GetTokenResponseDefaultData">
<Subscript>"GetTokenResponse"</Subscript>
<Value name="1">
<Value>token</Value>
</Value>
</Data>
<DefaultData>GetTokenResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
