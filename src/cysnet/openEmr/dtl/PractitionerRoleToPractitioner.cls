Class cysnet.openEmr.dtl.PractitionerRoleToPractitioner Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.PractitionerRole, %DynamicObject) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.PractitionerRole' targetClass='%DynamicObject' create='existing' language='objectscript' >
<group expanded='false' >
<annotation>Asignar uuid</annotation>
<comment>
<annotation>Buscar el uuid a partir del system http://hyperobjects/OpenEMR en la lista de identificadores</annotation>
</comment>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' />
<if condition='pos &gt; 0' >
<true>
<assign value='source.identifier.(pos).value' property='target.uuid' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar id</annotation>
<comment>
<annotation>Buscar el id a partir del system http://hyperobjects/OpenEMR/id en la lista de identificadores</annotation>
</comment>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR/id")' property='posid' action='set' />
<if condition='posid &gt; 0' >
<true>
<assign value='source.identifier.(posid).value' property='target.id' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>active</annotation>
<if condition='(source.active)' >
<true>
<assign value='1' property='target.active' action='set' />
</true>
<false>
<assign value='0' property='target.active' action='set' />
</false>
</if>
</group>
</transform>
}

}
