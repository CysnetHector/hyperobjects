Class cysnet.openEmr.dtl.PractitionerToHyperObjects Extends Ens.DataTransformDTL [ DependsOn = (%DynamicObject, HS.FHIR.DTL.vR4.Model.Resource.Practitioner) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='%DynamicObject' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Practitioner' create='existing' language='objectscript' >
<assign value='target.identifier.Count()' property='contId' action='set' />
<assign value='"generated"' property='target.text.status' action='set' />
<assign value='"&lt;div xmlns=""http://www.w3.org/1999/xhtml""&gt;&lt;p&gt;Practitioner&lt;/p&gt;&lt;/div&gt;"' property='target.text.div' action='set' />
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
<if condition='source.id &apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/id")' property='posid' action='set' />
<if condition='posid = 0' >
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
<if condition='source.npi&apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hl7.org/fhir/sid/us-npi")' property='posnpi' action='set' />
<if condition='posnpi = 0'  expanded='false' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hl7.org/fhir/sid/us-npi"' property='target.identifier.(contId).system' action='set' />
<assign value='source.npi' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.npi' property='target.identifier.(posnpi).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='source.username&apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/username")' property='posU' action='set' />
<if condition='posU = 0'  expanded='false' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR/username"' property='target.identifier.(contId).system' action='set' />
<assign value='source.username' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.username' property='target.identifier.(posU).value' action='set' />
</false>
</if>
</true>
</if>
<assign value='source.active' property='target.active' action='set' />
<if condition='target.name.Count() = 0' >
<true>
<assign value='""' property='target.name.(1).family' action='set' />
</true>
</if>
<if condition='(source.title&apos;= "")&amp;&amp;(source.title&apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.title' property='target.name.(1).prefix.(1)' action='set' />
</true>
</if>
<if condition='(source.fname &apos;= "")&amp;&amp;(source.fname &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.fname' property='target.name.(1).given.(1)' action='set' />
</true>
</if>
<if condition='(source.mname &apos;= "")&amp;&amp;(source.mname &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.mname' property='target.name.(1).given.(2)' action='set' />
</true>
</if>
<if condition='source.lname &apos;= ""'  expanded='false' >
<true>
<assign value='source.lname' property='target.name.(1).family' action='set' />
</true>
</if>
<assign value='target.telecom.Count()' property='contIdTelecom' action='set' />
<if condition='source.phone&apos;= ""' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.telecom,"system","phone")' property='posphone' action='set' />
<if condition='posphone = 0' >
<true>
<assign value='contIdTelecom + 1' property='contIdTelecom' action='set' />
<assign value='"work"' property='target.telecom.(contIdTelecom).use' action='set' />
<assign value='"phone"' property='target.telecom.(contIdTelecom).system' action='set' />
<assign value='source.phone' property='target.telecom.(contIdTelecom).value' action='set' />
</true>
<false>
<assign value='source.phone' property='target.telecom.(posphone).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='source.email&apos;= ""' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.telecom,"system","email")' property='posemail' action='set' />
<if condition='posemail = 0' >
<true>
<assign value='contIdTelecom + 1' property='contIdTelecom' action='set' />
<assign value='"work"' property='target.telecom.(contIdTelecom).use' action='set' />
<assign value='"email"' property='target.telecom.(contIdTelecom).system' action='set' />
<assign value='source.email' property='target.telecom.(contIdTelecom).value' action='set' />
</true>
<false>
<assign value='source.email' property='target.telecom.(posemail).value' action='set' />
</false>
</if>
</true>
</if>
<group expanded='false' >
<annotation>Comprobaciones y ajustes en ciertas propiedades: name, address</annotation>
<if condition='(target.name.Count() = 0)||((target.name.(1).family = "")&amp;&amp;(target.name.(1).given.Count() = 0))' >
<true>
<comment>
<annotation>Si no hay name, o si hay, pero family y given son vacíos: borrar</annotation>
</comment>
<assign value='' property='target.name' action='remove' key='1' />
</true>
<false>
<comment>
<annotation>Comprobar si todos los elementos tienen use. Si no lo tienen, añadir uno por defecto</annotation>
</comment>
<foreach property='target.name()' key='k1' >
<if condition='target.name.(k1).use = ""' >
<true>
<assign value='"official"' property='target.name.(k1).use' action='set' />
</true>
</if>
</foreach>
</false>
</if>
</group>
</transform>
}

}
