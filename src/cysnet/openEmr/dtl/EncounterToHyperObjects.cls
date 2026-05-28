Class cysnet.openEmr.dtl.EncounterToHyperObjects Extends Ens.DataTransformDTL [ DependsOn = (%DynamicObject, HS.FHIR.DTL.vR4.Model.Resource.Encounter) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='%DynamicObject' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Encounter' create='existing' language='objectscript' >
<assign value='target.identifier.Count()' property='contId' action='set' />
<assign value='"generated"' property='target.text.status' action='set' />
<assign value='"&lt;div xmlns=""http://www.w3.org/1999/xhtml""&gt;&lt;p&gt;Encounter&lt;/p&gt;&lt;/div&gt;"' property='target.text.div' action='set' />
<group expanded='false' >
<annotation>Asignar identifiers</annotation>
<if condition='source.euuid &apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' />
<if condition='pos = 0' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR"' property='target.identifier.(contId).system' action='set' />
<assign value='source.euuid' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.euuid' property='target.identifier.(pos).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='source.eid &apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/id")' property='posid' action='set' />
<if condition='posid = 0' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR/id"' property='target.identifier.(contId).system' action='set' />
<assign value='source.eid' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.eid' property='target.identifier.(posid).value' action='set' />
</false>
</if>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar class</annotation>
<if condition='source."class_code" &apos;= ""'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-ActCode"' property='target.class.system' action='set' />
<assign value='source."class_code"' property='target.class.code' action='set' />
</true>
</if>
<if condition='source."class_title" &apos;= ""'  expanded='false' >
<true>
<if condition='source."class_title" = "South Sudan"'  expanded='false' >
<true>
<assign value='"shot stay"' property='target.class.display' action='set' />
<assign value='"http://terminology.hl7.org/CodeSystem/v3-ActCode"' property='target.class.system' action='set' />
</true>
<false>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-ActCode"' property='target.class.system' action='set' />
<assign value='source."class_title"' property='target.class.display' action='set' />
</false>
</if>
</true>
</if>
</group>
<group>
<annotation>Asignar referencias: subject, participant.individual, serviceProvider</annotation>
<comment>
<annotation>Si tenemos puuid (paciente) rellenamos subject.identifier con los datos del identificador en HyperObjects</annotation>
</comment>
<if condition='source.puuid &apos;= ""'  expanded='false' >
<true>
<assign value='"http://hyperobjects/OpenEMR"' property='target.subject.identifier.system' action='set' />
<assign value='source.puuid' property='target.subject.identifier.value' action='set' />
<assign value='"Patient"' property='target.subject.type' action='set' />
</true>
</if>
<comment>
<annotation>Si tenemos provider_uuid (practitioner) rellenamos participant(1).individual.identifier con los datos del identificador en HyperObjects</annotation>
</comment>
<if condition='source."provider_uuid" &apos;= ""'  expanded='false' >
<true>
<assign value='"http://hyperobjects/OpenEMR"' property='target.participant.(1).individual.identifier.system' action='set' />
<assign value='source."provider_uuid"' property='target.participant.(1).individual.identifier.value' action='set' />
<assign value='"Practitioner"' property='target.participant.(1).individual.type' action='set' />
</true>
</if>
<comment>
<annotation>Si tenemos facility_uuid (organization) rellenamos serviceProvider.identifier con los datos del identificador en HyperObjects</annotation>
</comment>
<if condition='source."facility_uuid" &apos;= ""'  expanded='false' >
<true>
<assign value='"http://hyperobjects/OpenEMR"' property='target.serviceProvider.identifier.system' action='set' />
<assign value='source."facility_uuid"' property='target.serviceProvider.identifier.value' action='set' />
<assign value='"Organization"' property='target.serviceProvider.type' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar reason y period</annotation>
<if condition='source.reason &apos;= ""'  expanded='false' >
<true>
<assign value='source.reason' property='target.reasonCode.(1).text' action='set' />
</true>
</if>
<if condition='source.date &apos;= ""'  expanded='false' >
<true>
<assign value='$translate(source.date, " ", "T")_"Z"' property='target.period.start' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar status</annotation>
<assign value='"unknown"' property='target.status' action='set' />
<if condition='source.date &apos;= ""'  expanded='false' >
<true>
<comment>
<annotation>Calcular el tiempo (en segundos) que queda hasta la hora del encuentro. Si es mayor a 0, es a futuro; sino, es pasado</annotation>
</comment>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).DateDiffFromToday(source.date,"ss")' property='tiempoRestante' action='set' />
<if condition='tiempoRestante &gt; 0' >
<true>
<assign value='"planned"' property='target.status' action='set' />
</true>
<false>
<if condition='source."discharge_disposition" = ""' >
<true>
<if condition='(source."onset_date" &apos;= "")&amp;&amp;(source."onset_date" &apos;= "0000-00-00 00:00:00")' >
<true>
<assign value='"completed"' property='target.status' action='set' />
</true>
<false>
<assign value='"in-progress"' property='target.status' action='set' />
</false>
</if>
</true>
<false>
<assign value='"discharged"' property='target.status' action='set' />
</false>
</if>
</false>
</if>
</true>
</if>
</group>
</transform>
}

}
