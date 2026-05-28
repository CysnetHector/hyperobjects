Class cysnet.openEmr.dtl.HyperObjectsToPractitioner Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Practitioner, %DynamicObject) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Practitioner' targetClass='%DynamicObject' create='existing' language='objectscript' >
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' />
<if condition='pos &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(pos).value' property='target.uuid' action='set' />
</true>
</if>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR/id")' property='posid' action='set' />
<if condition='posid &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(posid).value' property='target.id' action='set' />
</true>
</if>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hl7.org/fhir/sid/us-npi")' property='posnpi' action='set' />
<if condition='posnpi &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(posnpi).value' property='target.npi' action='set' />
</true>
</if>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR/username")' property='posU' action='set' />
<if condition='posU &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(posU).value' property='target.username' action='set' />
</true>
</if>
<assign value='source.active' property='target.active' action='set' />
<if condition='source.name.Count() &gt; 0'  expanded='false' >
<true>
<assign value='source.name.(1).family' property='target.lname' action='set' />
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
<if condition='source.name.(1).given.Count() &gt; 1'  expanded='false' >
<true>
<assign value='source.name.(1).given.(2)' property='target.mname' action='set' />
</true>
</if>
</true>
</if>
<if condition='source.telecom.Count() &gt; 0' >
<true>
<foreach property='source.telecom()' key='k1'  expanded='false' >
<if condition='source.telecom.(k1).system = "phone"'  expanded='false' >
<true>
<assign value='source.telecom.(k1).value' property='target.phone' action='set' />
</true>
</if>
<if condition='source.telecom.(k1).system = "email"'  expanded='false' >
<true>
<assign value='source.telecom.(k1).value' property='target.email' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='target.username = ""' >
<true>
<comment>
<annotation>Si no tenemos username, si tenemos email, lo generaremos de ahí; sino, del nombre</annotation>
</comment>
<if condition='target.email &apos;= ""' >
<true>
<comment>
<annotation>Si hay email, usaremos como username la parte anterior a @, y si hay ., la primera parte, y todo en minúsculas</annotation>
</comment>
<assign value='$ZCONVERT($P($P(target.email,"@",1),".",1),"L")' property='target.username' action='set' />
</true>
<false>
<if condition='target.fname &apos;= ""' >
<true>
<comment>
<annotation>Si hay nombre, usaremos como username la primera palabra antes de &quot; &quot;, y todo en minúsculas</annotation>
</comment>
<assign value='$ZCONVERT($P(target.fname," ",1),"L")' property='target.username' action='set' />
</true>
</if>
</false>
</if>
</true>
</if>
</transform>
}

}
