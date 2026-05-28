Class cysnet.alertas.msg.struct.InfoJira Extends (%SerialObject, %XML.Adaptor, %JSON.Adaptor)
{

Property includeLinkJira As %Boolean;

Property jiraDestino As %String(MAXLEN = "");

Property comentario As %String(MAXLEN = "");

Property proyecto As %String(MAXLEN = "");

Property tipoIncidencia As %String(MAXLEN = "");

Property componente As %String(MAXLEN = "");

Property usuario As %String(MAXLEN = "");

Property responsable As %String(MAXLEN = "");

Property proyectoJira As %String(MAXLEN = "");

Property centro As %String(MAXLEN = "");

Property departamento As %String(MAXLEN = "");

Storage Default
{
<Data name="InfoJiraState">
<Value name="1">
<Value>includeLinkJira</Value>
</Value>
<Value name="2">
<Value>jiraDestino</Value>
</Value>
<Value name="3">
<Value>comentario</Value>
</Value>
<Value name="4">
<Value>proyecto</Value>
</Value>
<Value name="5">
<Value>tipoIncidencia</Value>
</Value>
<Value name="6">
<Value>componente</Value>
</Value>
<Value name="7">
<Value>usuario</Value>
</Value>
<Value name="8">
<Value>responsable</Value>
</Value>
<Value name="9">
<Value>proyectoJira</Value>
</Value>
<Value name="10">
<Value>centro</Value>
</Value>
<Value name="11">
<Value>departamento</Value>
</Value>
</Data>
<State>InfoJiraState</State>
<StreamLocation>^cysnet.alertas.msC1E2.InfoJiraS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
