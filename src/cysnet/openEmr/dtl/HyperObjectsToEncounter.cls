Class cysnet.openEmr.dtl.HyperObjectsToEncounter Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Encounter, %DynamicObject) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Encounter' targetClass='%DynamicObject' create='existing' language='objectscript' >
<group expanded='false' >
<annotation>Asignar euuid</annotation>
<comment>
<annotation>Buscar el euuid a partir del system http://hyperobjects/OpenEMR en la lista de identificadores</annotation>
</comment>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' />
<if condition='pos &gt; 0' >
<true>
<assign value='source.identifier.(pos).value' property='target.euuid' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar eid</annotation>
<comment>
<annotation>Buscar el eid a partir del system http://hyperobjects/OpenEMR/id en la lista de identificadores</annotation>
</comment>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR/id")' property='pos' action='set' />
<if condition='pos &gt; 0' >
<true>
<assign value='source.identifier.(pos).value' property='target.eid' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar class_code y class_title</annotation>
<if condition='source.class.code &apos;= ""'  expanded='false' >
<true>
<assign value='source.class.code' property='target."class_code"' action='set' />
</true>
</if>
<if condition='source.class.display &apos;= ""'  expanded='false' >
<true>
<assign value='source.class.display' property='target."class_title"' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar date</annotation>
<if condition='source.period.start &apos;= ""'  expanded='false' >
<true>
<assign value='source.period.start' property='target.date' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar reason</annotation>
<if condition='source.reasonCode.Count() &gt; 0'  expanded='false' >
<true>
<assign value='source.reasonCode.(1).text' property='target.reason' action='set' />
</true>
</if>
</group>
<assign value='10' property='target."pc_catid"' action='set' />
<assign value='"admin"' property='target.user' action='set' />
<assign value='"."' property='target.group' action='set' />
</transform>
}

}
