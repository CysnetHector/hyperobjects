Class cysnet.rest.msg.struct.Trace Extends (%SerialObject, %XML.Adaptor)
{

Property errors As list Of cysnet.rest.msg.struct.Error;

Property date As %DateTime;

Property stage As %String(MAXLEN = "");

ClassMethod generarTraza(stage As %String, msg As %String, assignTo As %String = "", datos As %String = "") As cysnet.rest.msg.struct.Trace
{
	#dim traza As cysnet.rest.msg.struct.Trace
	#dim error As cysnet.rest.msg.struct.Error
	
	set traza = ##class(cysnet.rest.msg.struct.Trace).%New()
	set traza.stage = stage
	set traza.date = $ZDT($H,3)
	
	set error = ##class(cysnet.rest.msg.struct.Error).%New()
	set error.assignTo = $s(assignTo'="":assignTo,1:"integraciones")
	set error.message = msg
	set error.datos = datos
	set error.stage = stage
	
	do traza.errors.Insert(error)
	
	quit traza
}

Storage Default
{
<Data name="TraceState">
<Value name="1">
<Value>errors</Value>
</Value>
<Value name="2">
<Value>date</Value>
</Value>
<Value name="3">
<Value>stage</Value>
</Value>
</Data>
<State>TraceState</State>
<StreamLocation>^cysnet.rest.msg.struct.TraceS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
