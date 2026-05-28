Class cysnet.alertas.msg.struct.Error Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property message As %String(MAXLEN = "");

Property assignTo As %String(MAXLEN = "");

Property datos As %String(MAXLEN = "");

Storage Default
{
<Data name="ErrorState">
<Value name="1">
<Value>message</Value>
</Value>
<Value name="2">
<Value>assignTo</Value>
</Value>
<Value name="3">
<Value>datos</Value>
</Value>
</Data>
<State>ErrorState</State>
<StreamLocation>^cysnet.alertas.msg.sC1E2.ErrorS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
