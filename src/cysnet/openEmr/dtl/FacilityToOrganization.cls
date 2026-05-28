Class cysnet.openEmr.dtl.FacilityToOrganization Extends Ens.DataTransformDTL [ DependsOn = (%DynamicObject, HS.FHIR.DTL.vR4.Model.Resource.Organization) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='%DynamicObject' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Organization' create='existing' language='objectscript' >
<assign value='target.identifier.Count()' property='contId' action='set' />
<assign value='"generated"' property='target.text.status' action='set' />
<assign value='"&lt;div xmlns=""http://www.w3.org/1999/xhtml""&gt;&lt;p&gt;Organization&lt;/p&gt;&lt;/div&gt;"' property='target.text.div' action='set' />
<if condition='source.id &apos;= ""'  expanded='false' >
<true>
<assign value='0' property='posid' action='set' />
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
<if condition='source.uuid &apos;= ""'  expanded='false' >
<true>
<assign value='0' property='pos' action='set' />
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' />
<if condition='pos = 0'  expanded='false' >
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
<if condition='source."facility_npi"&apos;= ""'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hl7.org/fhir/sid/us-npi")' property='posnpi' action='set' />
<if condition='posnpi = 0'  expanded='false' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hl7.org/fhir/sid/us-npi"' property='target.identifier.(contId).system' action='set' />
<assign value='source."facility_npi"' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source."facility_npi"' property='target.identifier.(posnpi).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='(source.name &apos;= "")&amp;&amp;(source.name &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.name' property='target.name' action='set' />
</true>
</if>
<assign value='1' property='target.active' action='set' />
<if condition='(source.phone&apos;= "")&amp;&amp;(source.phone&apos;= "NULL")'  expanded='false' >
<true>
<assign value='"phone"' property='target.telecom.(1).system' action='set' />
<assign value='source.phone' property='target.telecom.(1).value' action='set' />
</true>
</if>
<if condition='target.address.Count() = 0' >
<true>
<assign value='source.city' property='target.address.(1).city' action='set' />
</true>
</if>
<if condition='(source.street&apos;= "")&amp;&amp;(source.street&apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.street' property='target.address.(1).line.(1)' action='set' />
</true>
</if>
<if condition='(source.state&apos;= "")&amp;&amp;(source.state&apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.state' property='target.address.(1).state' action='set' />
</true>
</if>
<if condition='(source."postal_code"&apos;= "")&amp;&amp;(source."postal_code"&apos;= "NULL")'  expanded='false' >
<true>
<assign value='source."postal_code"' property='target.address.(1).postalCode' action='set' />
</true>
</if>
<if condition='(target.address.Count() = 0)||((target.address.(1).city = "")&amp;&amp;(target.address.(1).line.Count() = 0))'  expanded='false' >
<annotation>Si no hay dirección</annotation>
<true>
<assign value='' property='target.address' action='remove' key='1' />
</true>
<false>
<comment>
<annotation>Si tenemos dirección, unificar todo en la propiedad text</annotation>
</comment>
<foreach property='target.address()' key='k1'  expanded='false' >
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
</transform>
}

}
