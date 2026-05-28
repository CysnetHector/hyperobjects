Class cysnet.openEmr.dtl.PractitionerToPractitionerRole Extends Ens.DataTransformDTL [ DependsOn = (%DynamicObject, HS.FHIR.DTL.vR4.Model.Resource.PractitionerRole) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='%DynamicObject' targetClass='HS.FHIR.DTL.vR4.Model.Resource.PractitionerRole' create='existing' language='objectscript' >
<assign value='target.identifier.Count()' property='contId' action='set' />
<assign value='"generated"' property='target.text.status' action='set' />
<assign value='"&lt;div xmlns=""http://www.w3.org/1999/xhtml""&gt;&lt;p&gt;PractitionerRole&lt;/p&gt;&lt;/div&gt;"' property='target.text.div' action='set' />
<group expanded='false' >
<annotation>Asignar identifiers</annotation>
<comment>
<annotation>Comprobar si existe dato para http://hyperobjects/OpenEMR. Si no existe, generarlo</annotation>
</comment>
<if condition='source.uuid &apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' />
<if condition='pos = 0' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR"' property='target.identifier.(contId).system' action='set' />
<assign value='source.uuid' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.uuid' property='target.identifier.(pos).value' action='set' />
</false>
</if>
</true>
</if>
<comment>
<annotation>Comprobar si existe dato para http://hyperobjects/OpenEMR/id. Si no existe, generarlo</annotation>
</comment>
<if condition='source.id &apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/id")' property='posid' action='set' />
<if condition='posid = 0'  expanded='false' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR/id"' property='target.identifier.(contId).system' action='set' />
<assign value='source.id' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.id' property='target.identifier.(posid).value' action='set' />
</false>
</if>
</true>
</if>
<comment>
<annotation>Comprobar si existe dato para http://hyperobjects/OpenEMR/PFids. Si no existe, generarlo</annotation>
</comment>
<if condition='(source.id &apos;= "") &amp;&amp; (source."facility_id" &apos;= "")'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/PFids")' property='posid' action='set' />
<if condition='posid = 0' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR/PFids"' property='target.identifier.(contId).system' action='set' />
<assign value='source.id_"__"_source."facility_id"' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.id_"__"_source."facility_id"' property='target.identifier.(posid).value' action='set' />
</false>
</if>
</true>
</if>
</group>
<assign value='1' property='target.active' action='set' />
<group>
<annotation>Asignar references: Practitioner, Organization</annotation>
<comment>
<annotation>Si tenemos uuid rellenamos practitioner.identifier con los datos del identificador en HyperObjects</annotation>
</comment>
<if condition='source.uuid &apos;= ""'  expanded='false' >
<true>
<assign value='"http://hyperobjects/OpenEMR"' property='target.practitioner.identifier.system' action='set' />
<assign value='source.uuid' property='target.practitioner.identifier.value' action='set' />
<assign value='"Practitioner"' property='target.practitioner.type' action='set' />
</true>
</if>
<comment>
<annotation>Si tenemos facility_id rellenamos practitioner.identifier con los datos del id interno en HyperObjects</annotation>
</comment>
<if condition='source."facility_id" &apos;= ""' >
<true>
<assign value='"http://hyperobjects/OpenEMR/id"' property='target.organization.identifier.system' action='set' />
<assign value='source."facility_id"' property='target.organization.identifier.value' action='set' />
<assign value='"Organization"' property='target.organization.type' action='set' />
</true>
</if>
</group>
</transform>
}

}
