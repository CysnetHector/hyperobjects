Class cysnet.openEmr.dtl.OrganizationToFacility Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Organization, %DynamicObject) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Organization' targetClass='%DynamicObject' create='existing' language='objectscript' >
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR")' property='pos' action='set' >
<annotation>Buscar el UUID</annotation>
</assign>
<if condition='pos &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(pos).value' property='target.uuid' action='set' />
</true>
</if>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hyperobjects/OpenEMR/id")' property='posid' action='set' >
<annotation>Buscar el UUID</annotation>
</assign>
<if condition='posid &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(posid).value' property='target.id' action='set' />
</true>
</if>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(source.identifier,"system","http://hl7.org/fhir/sid/us-npi")' property='posnpi' action='set' >
<annotation>Buscar el UUID</annotation>
</assign>
<if condition='posnpi &gt; 0'  expanded='false' >
<true>
<assign value='source.identifier.(posnpi).value' property='target."facility_npi"' action='set' />
</true>
</if>
<assign value='source.name' property='target.name' action='set' />
<if condition='source.telecom.Count() &gt; 0'  expanded='false' >
<true>
<foreach property='source.telecom()' key='k1' >
<if condition='source.telecom.(k1).system = "phone"' >
<true>
<assign value='source.telecom.(k1).value' property='target.phone' action='set' />
</true>
</if>
</foreach>
</true>
</if>
<if condition='source.address.Count() &gt; 0' >
<true>
<if condition='source.address.(1).line.Count() &gt; 0'  expanded='false' >
<true>
<assign value='source.address.(1).line.(1)' property='target.street' action='set' />
</true>
</if>
<if condition='source.address.(1).city &apos;= ""'  expanded='false' >
<true>
<assign value='source.address.(1).city' property='target.city' action='set' />
</true>
</if>
<if condition='source.address.(1).state &apos;= ""'  expanded='false' >
<true>
<assign value='source.address.(1).state' property='target.state' action='set' />
</true>
</if>
<if condition='source.address.(1).postalCode &apos;= ""' >
<true>
<assign value='source.address.(1).postalCode' property='target."postal_code"' action='set' />
</true>
</if>
</true>
</if>
</transform>
}

}
