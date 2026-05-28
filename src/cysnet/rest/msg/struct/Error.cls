Class cysnet.rest.msg.struct.Error Extends (%SerialObject, %XML.Adaptor)
{

Property message As %String(MAXLEN = "");

Property assignTo As %String(MAXLEN = "");

Property datos As %String(MAXLEN = "");

Property stage As %String(MAXLEN = "");

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
<Value name="4">
<Value>stage</Value>
</Value>
</Data>
<State>ErrorState</State>
<StreamLocation>^cysnet.rest.msg.struct.ErrorS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
