Class cysnet.openEmr.dtl.RelatedPersonToPatient Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.RelatedPerson, %DynamicObject) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.RelatedPerson' targetClass='%DynamicObject' create='existing' language='objectscript' >
<assign value='0' property='esGuardian' action='set' />
<assign value='0' property='posGuardian' action='set' />
<comment>
<annotation>Buscar si una de las relaciones es GUARD; si lo es, asignar propiedades</annotation>
</comment>
<if condition='source.relationship.Count() &gt; 0'  expanded='false' >
<true>
<foreach property='source.relationship()' key='k1' >
<if condition='source.relationship.(k1).coding.(1).code = "GUARD"' >
<true>
<assign value='1' property='esGuardian' action='set' />
<assign value='k1' property='posGuardian' action='set' />
<break/>
</true>
</if>
</foreach>
</true>
</if>
<if condition='esGuardian' >
<true>
<group expanded='false' >
<annotation>Asignar uuid</annotation>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' />
<if condition='pos &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(pos).value' property='target.uuid' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar id</annotation>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR/id")' property='pos' action='set' />
<if condition='pos &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(pos).value' property='target.id' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar guardiansname</annotation>
<if condition='source.name.Count() &gt; 0' >
<true>
<assign value='source.name.(1).text' property='target.guardiansname' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar guardianphone, guardianworkphone, guardianemail</annotation>
<if condition='source.telecom.Count() &gt; 0'  expanded='false' >
<true>
<foreach property='source.telecom()' key='k1' >
<if condition='(source.telecom.(k1).use = "home")&amp;&amp;(source.telecom.(k1).system = "phone")'  expanded='false' >
<true>
<assign value='source.telecom.(k1).value' property='target.guardianphone' action='set' />
</true>
</if>
<if condition='(source.telecom.(k1).use = "work")&amp;&amp;(source.telecom.(k1).system = "phone")'  expanded='false' >
<true>
<assign value='source.telecom.(k1).value' property='target.guardianworkphone' action='set' />
</true>
</if>
<if condition='(source.telecom.(k1).use = "home")&amp;&amp;(source.telecom.(k1).system = "email")'  expanded='false' >
<true>
<assign value='source.telecom.(k1).value' property='target.guardianemail' action='set' />
</true>
</if>
</foreach>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar guardianaddress, guardiancity, guardianstate, guardianpostalcode, guardiancountry</annotation>
<if condition='source.address.Count() &gt; 0' >
<true>
<if condition='(source.address.(1).line.Count() &gt; 0)&amp;&amp;(source.address.(1).line.(1) &apos;= "")'  expanded='false' >
<true>
<assign value='source.address.(1).line.(1)' property='target.guardianaddress' action='set' />
</true>
</if>
<if condition='source.address.(1).city &apos;= ""'  expanded='false' >
<true>
<assign value='source.address.(1).city' property='target.guardiancity' action='set' />
</true>
</if>
<if condition='source.address.(1).state &apos;= ""'  expanded='false' >
<true>
<assign value='source.address.(1).state' property='target.guardianstate' action='set' />
</true>
</if>
<if condition='source.address.(1).postalCode &apos;= ""'  expanded='false' >
<true>
<assign value='source.address.(1).postalCode' property='target.guardianpostalcode' action='set' />
</true>
</if>
<if condition='source.address.(1).country &apos;= ""'  expanded='false' >
<true>
<assign value='source.address.(1).country' property='target.guardiancountry' action='set' />
</true>
</if>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar guardianrelationship</annotation>
<comment>
<annotation>Si hay más de una relationship, buscar la que NO ES GUARD, para mapearla</annotation>
</comment>
<if condition='source.relationship.Count() &gt; 1' >
<true>
<assign value='0' property='posRel' action='set' />
<foreach property='source.relationship()' key='k1'  expanded='false' >
<if condition='k1 &apos;= posGuardian' >
<true>
<assign value='k1' property='posRel' action='set' />
<break/>
</true>
</if>
</foreach>
<if condition='posRel &gt; 0' >
<true>
<if condition='source.relationship.(posRel).coding.(1).code = "O"'  expanded='false' >
<true>
<assign value='"other"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "C"'  expanded='false' >
<true>
<assign value='"emergency_contact"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "E"'  expanded='false' >
<true>
<assign value='"employer"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "U"'  expanded='false' >
<true>
<assign value='"unknown"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "BRO"'  expanded='false' >
<true>
<assign value='"brother"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "CHILD"'  expanded='false' >
<true>
<assign value='"child"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "EXT"'  expanded='false' >
<true>
<assign value='"extended_family"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "CHLDFOST"'  expanded='false' >
<true>
<assign value='"foster_child"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "FRND"'  expanded='false' >
<true>
<assign value='"friend"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "FTH"'  expanded='false' >
<true>
<assign value='"father"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "GRNDCHILD"'  expanded='false' >
<true>
<assign value='"grandchild"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "GRPRN"'  expanded='false' >
<true>
<assign value='"grandparent"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "MTH"'  expanded='false' >
<true>
<assign value='"mother"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "NCHILD"'  expanded='false' >
<true>
<assign value='"natural_child"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "PRN"'  expanded='false' >
<true>
<assign value='"parent"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "STPCHLD"'  expanded='false' >
<true>
<assign value='"stepchild"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "ONESELF"'  expanded='false' >
<true>
<assign value='"self"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "SIB"'  expanded='false' >
<true>
<assign value='"sibling"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "SIS"'  expanded='false' >
<true>
<assign value='"sister"' property='target.guardianrelationship' action='set' />
</true>
</if>
<if condition='source.relationship.(posRel).coding.(1).code = "SPS"'  expanded='false' >
<true>
<assign value='"spouse"' property='target.guardianrelationship' action='set' />
</true>
</if>
</true>
</if>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar guardiansex</annotation>
<if condition='source.gender &apos;= ""'  expanded='false' >
<true>
<if condition='source.gender = "male"'  expanded='false' >
<true>
<assign value='"Male"' property='target.guardiansex' action='set' />
</true>
</if>
<if condition='source.gender = "female"'  expanded='false' >
<true>
<assign value='"Female"' property='target.guardiansex' action='set' />
</true>
</if>
<if condition='source.gender = "other"'  expanded='false' >
<true>
<assign value='"UNK"' property='target.guardiansex' action='set' />
</true>
</if>
</true>
</if>
</group>
</true>
</if>
</transform>
}

}
