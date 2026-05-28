Class cysnet.openEmr.dtl.PatientToRelatedPerson Extends Ens.DataTransformDTL [ DependsOn = (%DynamicObject, HS.FHIR.DTL.vR4.Model.Resource.RelatedPerson) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='%DynamicObject' targetClass='HS.FHIR.DTL.vR4.Model.Resource.RelatedPerson' create='existing' language='objectscript' >
<comment>
<annotation>Solamente crearemos RelatedPerson si guardiansname tiene valor</annotation>
</comment>
<if condition='source.guardiansname &apos;= ""' >
<true>
<assign value='""' property='text' action='set' />
<assign value='target.identifier.Count()' property='contId' action='set' />
<group expanded='false' >
<annotation>Asignaciones identifier</annotation>
<if condition='source.uuid &apos;= ""'  expanded='false' >
<true>
<assign value='"http://hyperobjects/OpenEMR"' property='target.patient.identifier.system' action='set' />
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' />
<if condition='pos = 0' >
<true>
<assign value='contId + 1' property='contId ' action='set' />
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
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/id")' property='pos' action='set' />
<if condition='pos = 0' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR/id"' property='target.identifier.(contId).system' action='set' />
<assign value='source.id' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.id' property='target.identifier.(pos).value' action='set' />
</false>
</if>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Inicializar relationship: GUARD</annotation>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(1).coding.(1).system ' action='set' />
<assign value='"GUARD"' property='target.relationship.(1).coding.(1).code ' action='set' />
<assign value='"guardian"' property='target.relationship.(1).text ' action='set' />
</group>
<group expanded='false' >
<annotation>Asignar name</annotation>
<if condition='target.name.Count() = 0'  expanded='false' >
<true>
<assign value='""' property='target.name.(1).text' action='set' />
</true>
</if>
<if condition='source.guardiansname &apos;= ""'  expanded='false' >
<true>
<assign value='source.guardiansname' property='target.name.(1).text' action='set' />
<assign value='text_" "_source.guardiansname' property='text' action='set' />
</true>
</if>
</group>
<group>
<annotation>Asignar referencia a Patient</annotation>
<if condition='source.uuid &apos;= ""' >
<true>
<assign value='"http://hyperobjects/OpenEMR"' property='target.patient.identifier.system' action='set' />
<assign value='source.uuid' property='target.patient.identifier.value' action='set' />
<assign value='"Patient"' property='target.patient.type' action='set' />
<if condition='source.fname &apos;= ""' >
<true>
<assign value='text_" guardian of "_$ZSTRIP($Replace(source.title_" "_source.fname_" "_source.lname,"null",""), "&lt;&gt;W")' property='text' action='set' />
</true>
<false>
<assign value='text_" guardian of patient/"_source.uuid' property='text' action='set' />
</false>
</if>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar relationship</annotation>
<comment>
<annotation>Si tenemos relationship, y es diferente a guardian, la mapeamos</annotation>
</comment>
<if condition='(source.guardianrelationship &apos;= "")&amp;&amp;($ZCONVERT(source.guardianrelationship,"L") &apos;= "guardian")' >
<true>
<assign value='source.guardianrelationship' property='target.relationship.(2).text ' action='set' />
<assign value='$lb("associate","care_giver","handicapped_dependent","life_partner","employee","manager","other_adult","other","trainer","ward_of_court")' property='lista' action='set' />
<if condition='$lf(lista, $ZCONVERT(source.guardianrelationship,"L")) &gt; 0'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v2-0131"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"O"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "emergency_contact"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v2-0131"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"C"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "employer"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v2-0131"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"E"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='($ZCONVERT(source.guardianrelationship,"L") = "none")||($ZCONVERT(source.guardianrelationship,"L") = "unknown")'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v2-0131"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"U"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "brother"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"BRO"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "child"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"CHILD"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "extended_family"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"EXT"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "foster_child"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"CHLDFOST"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "friend"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"FRND"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "father"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"FTH"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "grandchild"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"GRNDCHILD"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "grandparent"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"GRPRN"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "mother"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"MTH"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "natural_child"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"NCHILD"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='($ZCONVERT(source.guardianrelationship,"L") = "owner")||($ZCONVERT(source.guardianrelationship,"L") = "self")'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"ONESELF"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "parent"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"PRN"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "stepchild"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"STPCHLD"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "sibling"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"SIB"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "sister"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"SIS"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
<if condition='$ZCONVERT(source.guardianrelationship,"L") = "spouse"'  expanded='false' >
<true>
<assign value='"http://terminology.hl7.org/CodeSystem/v3-RoleCode"' property='target.relationship.(2).coding.(1).system ' action='set' />
<assign value='"SPS"' property='target.relationship.(2).coding.(1).code ' action='set' />
</true>
</if>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar telecom</annotation>
<assign value='target.telecom.Count()' property='contIdTelecom' action='set' />
<if condition='source.guardianphone &apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindListValuePosition(target.telecom,$lb("use","system"),$lb("home","phone"))' property='pos' action='set' />
<if condition='pos = 0'  expanded='false' >
<true>
<assign value='contIdTelecom + 1' property='contIdTelecom' action='set' />
<assign value='source."guardianphone"' property='target.telecom.(contIdTelecom).value' action='set' />
<assign value='"home"' property='target.telecom.(contIdTelecom).use' action='set' />
<assign value='"phone"' property='target.telecom.(contIdTelecom).system ' action='set' />
</true>
<false>
<assign value='source."guardianphone"' property='target.telecom.(pos).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='source.guardianworkphone &apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindListValuePosition(target.telecom,$lb("use","system"),$lb("work","phone"))' property='pos' action='set' />
<if condition='pos = 0'  expanded='false' >
<true>
<assign value='contIdTelecom + 1' property='contIdTelecom' action='set' />
<assign value='source."guardianworkphone"' property='target.telecom.(contIdTelecom).value' action='set' />
<assign value='"work"' property='target.telecom.(contIdTelecom).use' action='set' />
<assign value='"phone"' property='target.telecom.(contIdTelecom).system ' action='set' />
</true>
<false>
<assign value='source."guardianworkphone"' property='target.telecom.(pos).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='source.guardianemail &apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindListValuePosition(target.telecom,$lb("use","system"),$lb("home","email"))' property='pos' action='set' />
<if condition='pos = 0'  expanded='false' >
<true>
<assign value='contIdTelecom + 1' property='contIdTelecom' action='set' />
<assign value='source."guardianemail"' property='target.telecom.(contIdTelecom).value' action='set' />
<assign value='"home"' property='target.telecom.(contIdTelecom).use' action='set' />
<assign value='"email"' property='target.telecom.(contIdTelecom).system ' action='set' />
</true>
<false>
<assign value='source."guardianemail"' property='target.telecom.(pos).value' action='set' />
</false>
</if>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar address</annotation>
<if condition='target.address.Count() = 0'  expanded='false' >
<true>
<assign value='""' property='target.address.(1).city' action='set' />
</true>
</if>
<if condition='source.guardiancountry &apos;= ""'  expanded='false' >
<true>
<assign value='source."guardiancountry"' property='target.address.(1).country' action='set' />
</true>
</if>
<if condition='source.guardianstate &apos;= ""'  expanded='false' >
<true>
<assign value='source.guardianstate' property='target.address.(1).state' action='set' />
</true>
</if>
<if condition='source.guardiancity &apos;= ""'  expanded='false' >
<true>
<assign value='source.guardiancity' property='target.address.(1).city' action='set' />
</true>
</if>
<if condition='source.guardianpostalcode &apos;= ""'  expanded='false' >
<true>
<assign value='source."guardianpostalcode"' property='target.address.(1).postalCode' action='set' />
</true>
</if>
<if condition='source.guardianaddress &apos;= ""'  expanded='false' >
<true>
<assign value='source.guardianaddress' property='target.address.(1).line.(1)' action='set' />
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar sex</annotation>
<if condition='source.guardiansex&apos;= ""' >
<true>
<if condition='source.guardiansex = "Male"' >
<true>
<assign value='"male"' property='target.gender' action='set' />
</true>
</if>
<if condition='source.guardiansex = "Female"' >
<true>
<assign value='"female"' property='target.gender' action='set' />
</true>
</if>
<if condition='source.guardiansex = "UNK"' >
<true>
<assign value='"other"' property='target.gender' action='set' />
</true>
</if>
</true>
</if>
</group>
<group expanded='false' >
<annotation>Asignar text</annotation>
<assign value='"generated"' property='target.text.status' action='set' />
<assign value='"&lt;div xmlns=""http://www.w3.org/1999/xhtml""&gt;&lt;p&gt;RelatedPerson:"_text_"&lt;/p&gt;&lt;/div&gt;"' property='target.text.div' action='set' />
</group>
<group expanded='false' >
<annotation>Comprobaciones y ajustes en ciertas propiedades: name, address</annotation>
<if condition='(target.name.Count() = 0)||((target.name.(1).text = ""))'  expanded='false' >
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
<if condition='(target.address.Count() = 0)||((target.address.(1).city = "")&amp;&amp;(target.address.(1).line.Count() = 0))'  expanded='false' >
<true>
<comment>
<annotation>Si no hay address, o si hay, pero city y line son vacíos: borrar</annotation>
</comment>
<assign value='' property='target.address' action='remove' key='1' />
</true>
<false>
<comment>
<annotation>Comprobar si todos los elementos tienen use/type. Si no lo tienen, añadir por defecto</annotation>
</comment>
<comment>
<annotation>Si tenemos dirección, unificar todo en la propiedad text</annotation>
</comment>
<foreach property='target.address()' key='k1'  expanded='false' >
<if condition='target.address.(k1).use = ""' >
<true>
<assign value='"home"' property='target.address.(k1).use' action='set' />
</true>
</if>
<if condition='target.address.(k1).type = ""' >
<true>
<assign value='"both"' property='target.address.(k1).type' action='set' />
</true>
</if>
<assign value='""' property='target.address.(k1).text' action='set' />
<if condition='target.address.(k1).line.Count() &gt; 0' >
<true>
<foreach property='target.address.(k1).line()' key='k2' >
<assign value='target.address.(k1).text_" "_target.address.(k1).line.(k2)' property='target.address.(k1).text' action='set' />
</foreach>
<if condition='target.address.(k1).city &apos;= ""' >
<true>
<assign value='target.address.(k1).text_", "_target.address.(k1).city' property='target.address.(k1).text' action='set' />
</true>
</if>
<if condition='target.address.(k1).postalCode &apos;= ""' >
<true>
<assign value='target.address.(k1).text_", "_target.address.(k1).postalCode' property='target.address.(k1).text' action='set' />
</true>
</if>
<if condition='target.address.(k1).state &apos;= ""' >
<true>
<assign value='target.address.(k1).text_", "_target.address.(k1).state' property='target.address.(k1).text' action='set' />
</true>
</if>
<if condition='target.address.(k1).country &apos;= ""' >
<true>
<assign value='target.address.(k1).text_", "_target.address.(k1).country' property='target.address.(k1).text' action='set' />
</true>
</if>
<assign value='$ZSTRIP(target.address.(k1).text, "&lt;&gt;W")' property='target.address.(k1).text' action='set' />
</true>
</if>
</foreach>
</false>
</if>
</group>
</true>
</if>
</transform>
}

}
