Class cysnet.openEmr.dtl.AppointmentToHyperObjects Extends Ens.DataTransformDTL [ DependsOn = (%DynamicObject, HS.FHIR.DTL.vR4.Model.Resource.Appointment) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='%DynamicObject' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Appointment' create='existing' language='objectscript' >
<assign value='target.identifier.Count()' property='contId' action='set' />
<assign value='"generated"' property='target.text.status' action='set' />
<assign value='"&lt;div xmlns=""http://www.w3.org/1999/xhtml""&gt;&lt;p&gt;Appointment&lt;/p&gt;&lt;/div&gt;"' property='target.text.div' action='set' />
<group>
<annotation>Asignar identifiers</annotation>
<comment>
<annotation>Comprobar si existe dato para http://hyperobjects/OpenEMR. Si no existe, generarlo</annotation>
</comment>
<if condition='source."pc_eid" &apos;= ""'  expanded='false' >
<true>
<assign value='0' property='pos' action='set' />
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' />
<if condition='pos=0'  expanded='false' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR"' property='target.identifier.(contId).system' action='set' />
<assign value='source."pc_eid"' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source."pc_eid"' property='target.identifier.(pos).value' action='set' />
</false>
</if>
</true>
</if>
<comment>
<annotation>Comprobar si existe dato para http://hyperobjects/OpenEMR/uuid. Si no existe, generarlo</annotation>
</comment>
<if condition='source."pc_uuid" &apos;= ""'  expanded='false' >
<true>
<assign value='0' property='pos' action='set' />
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/uuid")' property='pos' action='set' />
<if condition='pos=0'  expanded='false' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR/uuid"' property='target.identifier.(contId).system' action='set' />
<assign value='source."pc_uuid"' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source."pc_uuid"' property='target.identifier.(pos).value' action='set' />
</false>
</if>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar status</annotation>
<comment>
<annotation>Mapear los valores de pc_apptstatus con la propiedad status del recurso FHIR</annotation>
</comment>
<if condition='((source."pc_apptstatus" &apos;= "") &amp;&amp; (source."pc_apptstatus" &apos;= "NULL"))'  expanded='false' >
<true>
<assign value='"pending"' property='target.status' action='set' />
<if condition='source."pc_apptstatus" = "*"'  expanded='false' >
<true>
<assign value='"proposed"' property='target.status' action='set' />
</true>
</if>
<if condition='source."pc_apptstatus" = "^"'  expanded='false' >
<true>
<assign value='"pending"' property='target.status' action='set' />
</true>
</if>
<if condition='source."pc_apptstatus" = "AVM"'  expanded='false' >
<true>
<assign value='"booked"' property='target.status' action='set' />
</true>
</if>
<if condition='(source."pc_apptstatus" = "SMS")||(source."pc_apptstatus" = "EMAIL")||(source."pc_apptstatus" = "CALL")'  expanded='false' >
<true>
<assign value='"booked"' property='target.status' action='set' />
</true>
</if>
<if condition='source."pc_apptstatus" = "&gt;"'  expanded='false' >
<true>
<assign value='"fulfilled"' property='target.status' action='set' />
</true>
</if>
<if condition='source."pc_apptstatus" = "x"'  expanded='false' >
<true>
<assign value='"cancelled"' property='target.status' action='set' />
</true>
</if>
<if condition='source."pc_apptstatus" = "?"'  expanded='false' >
<true>
<assign value='"noshow"' property='target.status' action='set' />
</true>
</if>
<if condition='source."pc_apptstatus" = "-"'  expanded='false' >
<true>
<assign value='"entered-in-error"' property='target.status' action='set' />
</true>
</if>
<if condition='source."pc_apptstatus" = "&lt;"'  expanded='false' >
<true>
<assign value='"checked-in"' property='target.status' action='set' />
</true>
</if>
</true>
<false>
<assign value='"proposed"' property='target.status' action='set' />
</false>
</if>
</group>
<group expanded='false' >
<annotation>Asignar start y end. Calcular minutesDuration</annotation>
<comment>
<annotation>Construir el inico y fin de la cita en base a pc_eventDate, pc_startTime y pc_endTime</annotation>
</comment>
<assign value='""' property='horaIni' action='set' />
<assign value='""' property='horaFin' action='set' />
<if condition='source."pc_eventDate" &apos;= ""'  expanded='false' >
<true>
<if condition='source."pc_startTime" &apos;= ""'  expanded='false' >
<true>
<assign value='source."pc_eventDate"_"T"_source."pc_startTime"_"Z"' property='target.start' action='set' />
<assign value='$ZTIMEH(source."pc_startTime", 3)' property='horaIni' action='set' />
</true>
<false>
<assign value='""' property='target.start' action='set' />
</false>
</if>
<if condition='source."pc_endTime" &apos;= ""'  expanded='false' >
<true>
<assign value='source."pc_eventDate"_"T"_source."pc_endTime"_"Z"' property='target.end' action='set' />
<assign value='$ZTIMEH(source."pc_endTime", 3)' property='horaFin' action='set' />
</true>
<false>
<assign value='""' property='target.end' action='set' />
</false>
</if>
</true>
</if>
<if condition='source."pc_duration" &apos;= ""'  expanded='false' >
<true>
<assign value='(source."pc_duration")/60' property='target.minutesDuration' action='set' />
</true>
<false>
<if condition='(horaIni &apos;= "")&amp;&amp;(horaFin &apos;= "")' >
<true>
<assign value='(horaFin-horaIni)/60' property='target.minutesDuration' action='set' />
</true>
<false>
<assign value='""' property='target.minutesDuration' action='set' />
</false>
</if>
</false>
</if>
</group>
<group expanded='false' >
<annotation>Asignar pc_title y pc_hometext</annotation>
<if condition='source."pc_title" &apos;= ""'  expanded='false' >
<true>
<assign value='source."pc_title"' property='target.description' action='set' />
</true>
<false>
<assign value='""' property='target.description' action='set' />
</false>
</if>
<if condition='source."pc_hometext" &apos;= ""'  expanded='false' >
<true>
<assign value='source."pc_hometext"' property='target.comment' action='set' />
</true>
<false>
<assign value='""' property='target.comment' action='set' />
</false>
</if>
</group>
<group expanded='false' >
<annotation>Asignar participants: patient, practitioner, practitionerRole</annotation>
<comment>
<annotation>Si tenemos puuid (paciente) lo asignamos en la primera posición de participant. Rellenamos actor.identifier con los datos del identificador en HyperObjects</annotation>
</comment>
<if condition='source.puuid &apos;= ""'  expanded='false' >
<true>
<assign value='"http://hyperobjects/OpenEMR"' property='target.participant.(1).actor.identifier.system' action='set' />
<assign value='source.puuid' property='target.participant.(1).actor.identifier.value' action='set' />
<assign value='"Patient"' property='target.participant.(1).actor.type' action='set' />
<assign value='"accepted"' property='target.participant.(1).status' action='set' />
</true>
</if>
<comment>
<annotation>Si tenemos pce_aid_uuid (practitioner) lo asignamos en la segunda posición de participant. Rellenamos actor.identifier con los datos del identificador en HyperObjects</annotation>
</comment>
<if condition='source."pce_aid_uuid" &apos;= ""'  expanded='false' >
<true>
<assign value='"http://hyperobjects/OpenEMR"' property='target.participant.(2).actor.identifier.system' action='set' />
<assign value='source."pce_aid_uuid"' property='target.participant.(2).actor.identifier.value' action='set' />
<assign value='"Practitioner"' property='target.participant.(2).actor.type' action='set' />
<assign value='"accepted"' property='target.participant.(2).status' action='set' />
<assign value='"http://terminology.hl7.org/CodeSystem/v3-ParticipationType"' property='target.participant.(2).type.(1).coding.(1).system' action='set' />
<assign value='"ADM"' property='target.participant.(2).type.(1).coding.(1).code' action='set' />
</true>
</if>
<comment>
<annotation>Si tenemos pc_aid (practitioner, id interno) y pc_facility (organization, id interno) lo asignamos en la tercera posición de participant. Rellenamos actor.identifier con los datos del identificador en HyperObjects</annotation>
</comment>
<if condition='(source."pc_aid" &apos;= "") &amp;&amp; (source."pc_facility" &apos;= "")'  expanded='false' >
<true>
<assign value='"http://hyperobjects/OpenEMR/PFids"' property='target.participant.(3).actor.identifier.system' action='set' />
<assign value='source."pc_aid"_"__"_source."pc_facility"' property='target.participant.(3).actor.identifier.value' action='set' />
<assign value='"PractitionerRole"' property='target.participant.(3).actor.type' action='set' />
<assign value='"accepted"' property='target.participant.(3).status' action='set' />
<assign value='"http://terminology.hl7.org/CodeSystem/v3-ParticipationType"' property='target.participant.(3).type.(1).coding.(1).system' action='set' />
<assign value='"ADM"' property='target.participant.(3).type.(1).coding.(1).code' action='set' />
</true>
</if>
</group>
</transform>
}

}
