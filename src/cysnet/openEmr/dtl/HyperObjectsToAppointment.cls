Class cysnet.openEmr.dtl.HyperObjectsToAppointment Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Appointment, %DynamicObject) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Appointment' targetClass='%DynamicObject' create='existing' language='objectscript' >
<group expanded='false' >
<annotation>Asignar pc_eid</annotation>
<comment>
<annotation>Buscar el pc_eid a partir del system http://hyperobjects/OpenEMR en la lista de identificadores</annotation>
</comment>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' />
<if condition='pos &gt; 0' >
<true>
<assign value='source.identifier.(pos).value' property='target."pc_eid"' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar pc_uuid</annotation>
<comment>
<annotation>Buscar el pc_uuid a partir del system http://hyperobjects/OpenEMR en la lista de identificadores</annotation>
</comment>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR/uuid")' property='pos' action='set' />
<if condition='pos &gt; 0' >
<true>
<assign value='source.identifier.(pos).value' property='target."pc_uuid"' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar pc_apptstatus</annotation>
<comment>
<annotation>Mapear los valores status del recurso FHIR con la propiedad pc_apptstatus</annotation>
</comment>
<if condition='source.status &apos;= ""'  expanded='false' >
<true>
<if condition='source.status = "proposed"'  expanded='false' >
<true>
<assign value='"*"' property='target."pc_apptstatus"' action='set' />
</true>
</if>
<if condition='source.status = "pending"'  expanded='false' >
<true>
<assign value='"^"' property='target."pc_apptstatus"' action='set' />
</true>
</if>
<if condition='source.status = "booked"'  expanded='false' >
<true>
<assign value='"AVM"' property='target."pc_apptstatus"' action='set' />
</true>
</if>
<if condition='source.status = "arrived"'  expanded='false' >
<true>
<assign value='"@"' property='target."pc_apptstatus"' action='set' />
</true>
</if>
<if condition='source.status = "fulfilled"'  expanded='false' >
<true>
<assign value='"&gt;"' property='target."pc_apptstatus"' action='set' />
</true>
</if>
<if condition='source.status = "cancelled"'  expanded='false' >
<true>
<assign value='"x"' property='target."pc_apptstatus"' action='set' />
</true>
</if>
<if condition='source.status = "noshow"'  expanded='false' >
<true>
<assign value='"?"' property='target."pc_apptstatus"' action='set' />
</true>
</if>
<if condition='source.status = "entered-in-error"'  expanded='false' >
<true>
<assign value='"-"' property='target."pc_apptstatus"' action='set' />
</true>
</if>
<if condition='source.status = "checked-in"'  expanded='false' >
<true>
<assign value='"&lt;"' property='target."pc_apptstatus"' action='set' />
</true>
</if>
</true>
</if>
</group>
<if condition='source.description &apos;= ""'  expanded='false' >
<true>
<assign value='source.description' property='target."pc_title"' action='set' />
</true>
<false>
<assign value='"Cita"' property='target."pc_title"' action='set' />
</false>
</if>
<if condition='source.comment &apos;= ""'  expanded='false' >
<true>
<assign value='source.comment' property='target."pc_hometext"' action='set' />
</true>
<false>
<assign value='"Sin comentarios"' property='target."pc_hometext"' action='set' />
</false>
</if>
<group>
<annotation>Asignar pc_duration, pc_eventDate, pc_startTime, pc_endTime</annotation>
<if condition='source.minutesDuration &apos;= ""'  expanded='false' >
<true>
<assign value='source.minutesDuration*60' property='target."pc_duration"' action='set' />
</true>
</if>
<if condition='source.start &apos;= ""'  expanded='false' >
<true>
<assign value='$ZD($ZDTH(source.start,3,7),3,1)' property='target."pc_eventDate"' action='set' />
<assign value='$ZT($P($ZDTH(source.start,3,7),",",2),2)' property='target."pc_startTime"' action='set' />
</true>
</if>
<if condition='source.end &apos;= ""'  expanded='false' >
<true>
<assign value='$ZT($P($ZDTH(source.end,3,7),",",2),2)' property='target."pc_endTime"' action='set' />
</true>
</if>
</group>
<assign value='10' property='target."pc_catid"' action='set' />
<assign value='0' property='target."pc_billing_location"' action='set' />
</transform>
}

}
