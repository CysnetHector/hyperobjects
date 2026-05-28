Class cysnet.openEmr.dtl.HyperObjectsToPatient Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Patient, %DynamicObject) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Patient' targetClass='%DynamicObject' create='existing' language='objectscript' >
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' >
<annotation>Buscar el UUID</annotation>
</assign>
<if condition='pos &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(pos).value' property='target.uuid' action='set' />
</true>
</if>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR/id")' property='pos' action='set' >
<annotation>Buscar el ID</annotation>
</assign>
<if condition='pos &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(pos).value' property='target.id' action='set' />
</true>
</if>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR/pubpid")' property='pos' action='set' >
<annotation>Buscar el pubpid</annotation>
</assign>
<if condition='pos &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(pos).value' property='target.pubpid' action='set' />
</true>
</if>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR/ss")' property='pos' action='set' >
<annotation>Buscar el ss</annotation>
</assign>
<if condition='pos &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(pos).value' property='target.ss' action='set' />
</true>
</if>
<if condition='source.name.Count() &gt; 0'  expanded='false' >
<true>
<if condition='source.name.(1).prefix.Count() &gt; 0'  expanded='false' >
<true>
<assign value='source.name.(1).prefix.(1)' property='target.title' action='set' />
</true>
</if>
<if condition='source.name.(1).given.Count() &gt; 0'  expanded='false' >
<true>
<assign value='source.name.(1).given.(1)' property='target.fname' action='set' />
</true>
</if>
<assign value='source.name.(1).family' property='target.lname' action='set' />
<if condition='source.name.(1).given.Count() &gt; 1'  expanded='false' >
<true>
<assign value='source.name.(1).given.(2)' property='target.mname' action='set' />
</true>
</if>
<if condition='source.name.(1).suffix.Count() &gt; 0'  expanded='false' >
<true>
<assign value='source.name.(1).suffix.(1)' property='target.suffix' action='set' />
</true>
</if>
</true>
</if>
<assign value='$ZCONVERT(source.gender,"W")' property='target.sex' action='set' />
<assign value='source.birthDate' property='target.DOB' action='set' />
<if condition='source.address.Count() &gt; 0'  expanded='false' >
<true>
<if condition='source.address.(1).line.Count() &gt; 0' >
<true>
<assign value='source.address.(1).line.(1)' property='target.street' action='set' />
<if condition='source.address.(1).line.Count() &gt; 1' >
<true>
<assign value='source.address.(1).line.(2)' property='target."street_line_2"' action='set' />
</true>
<false>
<assign value='""' property='target."street_line_2"' action='set' />
</false>
</if>
</true>
</if>
<if condition='source.address.(1).postalCode &apos;= ""'  expanded='false' >
<true>
<assign value='source.address.(1).postalCode' property='target."postal_code"' action='set' />
</true>
</if>
<if condition='source.address.(1).city &apos;= ""'  expanded='false' >
<true>
<assign value='source.address.(1).city' property='target.city ' action='set' />
</true>
</if>
<if condition='source.address.(1).state &apos;= ""'  expanded='false' >
<true>
<assign value='source.address.(1).state' property='target.state' action='set' />
</true>
</if>
<if condition='source.address.(1).country &apos;= ""'  expanded='false' >
<true>
<assign value='source.address.(1).country' property='target."country_code"' action='set' />
</true>
</if>
</true>
</if>
<if condition='source.telecom.Count() &gt; 0' >
<true>
<foreach property='source.telecom()' key='k1'  expanded='false' >
<if condition='(source.telecom.(k1).use = "home")&amp;&amp;(source.telecom.(k1).system = "phone")'  expanded='false' >
<true>
<assign value='source.telecom.(k1).value' property='target."phone_home"' action='set' />
</true>
</if>
<if condition='(source.telecom.(k1).use = "work")&amp;&amp;(source.telecom.(k1).system = "phone")'  expanded='false' >
<true>
<assign value='source.telecom.(k1).value' property='target."phone_biz"' action='set' />
</true>
</if>
<if condition='(source.telecom.(k1).use = "mobile")&amp;&amp;(source.telecom.(k1).system = "phone")'  expanded='false' >
<true>
<assign value='source.telecom.(k1).value' property='target."phone_cell"' action='set' />
</true>
</if>
<if condition='(source.telecom.(k1).use = "home")&amp;&amp;(source.telecom.(k1).system = "email")'  expanded='false' >
<true>
<assign value='source.telecom.(k1).value' property='target.email' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='(source.maritalStatus.coding)&amp;&amp;(source.maritalStatus.coding.Count() &gt;= 1)' >
<true>
<if condition='source.maritalStatus.coding.(1).display = "Married"'  expanded='false' >
<true>
<assign value='"married"' property='target.status' action='set' />
</true>
</if>
<if condition='source.maritalStatus.coding.(1).code = "unmarried"'  expanded='false' >
<true>
<assign value='"single"' property='target.status' action='set' />
</true>
</if>
<if condition='source.maritalStatus.coding.(1).code = "Divorced"'  expanded='false' >
<true>
<assign value='"divorced"' property='target.status' action='set' />
</true>
</if>
<if condition='source.maritalStatus.coding.(1).code = "Widowed"'  expanded='false' >
<true>
<assign value='"widowed"' property='target.status' action='set' />
</true>
</if>
<if condition='source.maritalStatus.coding.(1).code = "Legally Separated"'  expanded='false' >
<true>
<assign value='"separated"' property='target.status' action='set' />
</true>
</if>
<if condition='source.maritalStatus.coding.(1).code = "Domestic partner"'  expanded='false' >
<true>
<assign value='"domestic"' property='target.status' action='set' />
</true>
</if>
</true>
</if>
<if condition='source.deceasedDateTime &apos;= ""' >
<true>
<assign value='source.deceasedDateTime' property='target."deceased_date"' action='set' />
</true>
</if>
</transform>
}

}
