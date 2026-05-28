Class cysnet.openEmr.dtl.PatientToHyperObjects Extends Ens.DataTransformDTL [ DependsOn = (%DynamicObject, HS.FHIR.DTL.vR4.Model.Resource.Patient) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='%DynamicObject' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Patient' create='existing' language='objectscript' >
<assign value='target.identifier.Count()' property='contId' action='set' />
<assign value='"generated"' property='target.text.status' action='set' />
<assign value='"&lt;div xmlns=""http://www.w3.org/1999/xhtml""&gt;&lt;p&gt;Patient&lt;/p&gt;&lt;/div&gt;"' property='target.text.div' action='set' />
<group expanded='false' >
<annotation>Comprobar si existe dato para http://hyperobjects/NH. Si no existe, generarlo</annotation>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/NH")' property='pos' action='set' />
<if condition='pos = 0' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/NH"' property='target.identifier.(contId).system' action='set' />
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).GenerateNH()' property='target.identifier.(contId).value' action='set' />
</true>
</if>
</group>
<if condition='source.uuid &apos;= ""'  expanded='false' >
<true>
<assign value='0' property='pos' action='set' />
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
<assign value='0' property='pos' action='set' />
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/id")' property='pos' action='set' />
<if condition='pos = 0'  expanded='false' >
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
<if condition='source.pid &apos;= ""'  expanded='false' >
<true>
<assign value='0' property='pos' action='set' />
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/pid")' property='pos' action='set' />
<if condition='pos = 0'  expanded='false' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR/pid"' property='target.identifier.(contId).system' action='set' />
<assign value='source.pid' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.pid' property='target.identifier.(pos).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='(source.pubpid &apos;= "")&amp;&amp;(source.pubpid&apos;= "NULL")'  expanded='false' >
<true>
<assign value='0' property='pos' action='set' />
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/pubpid")' property='pos' action='set' />
<if condition='pos = 0'  expanded='false' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR/pubpid"' property='target.identifier.(contId).system' action='set' />
<assign value='source.pubpid' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.pubpid' property='target.identifier.(pos).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='(source.ss&apos;= "")&amp;&amp;(source.ss&apos;= "NULL")'  expanded='false' >
<true>
<assign value='0' property='pos' action='set' />
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindValuePosition(target.identifier,"system","http://hyperobjects/OpenEMR/ss")' property='pos' action='set' />
<if condition='pos = 0'  expanded='false' >
<true>
<assign value='contId + 1' property='contId' action='set' />
<assign value='"http://hyperobjects/OpenEMR/ss"' property='target.identifier.(contId).system' action='set' />
<assign value='source.ss' property='target.identifier.(contId).value' action='set' />
</true>
<false>
<assign value='source.ss' property='target.identifier.(pos).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='target.name.Count() = 0'  expanded='false' >
<true>
<assign value='""' property='target.name.(1).family' action='set' />
</true>
</if>
<if condition='(source.fname&apos;= "")&amp;&amp;(source.fname &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.fname' property='target.name.(1).given.(1)' action='set' />
</true>
</if>
<if condition='(source.lname&apos;= "")&amp;&amp;(source.lname &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.lname' property='target.name.(1).family' action='set' />
</true>
</if>
<if condition='(source.title&apos;= "")&amp;&amp;(source.title &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.title' property='target.name.(1).prefix.(1)' action='set' />
</true>
</if>
<if condition='(source.mname &apos;= "")&amp;&amp;(source.mname &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.mname' property='target.name.(1).given.(2)' action='set' />
</true>
</if>
<if condition='(source.suffix&apos;= "")&amp;&amp;(source.suffix &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.suffix' property='target.name.(1).suffix.(1)' action='set' />
</true>
</if>
<if condition='(source.sex&apos;= "")&amp;&amp;(source.sex &apos;= "NULL")'  expanded='false' >
<true>
<assign value='$ZCONVERT(source.sex,"L")' property='target.gender' action='set' />
</true>
</if>
<if condition='(source.DOB&apos;= "")&amp;&amp;(source.DOB &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.DOB' property='target.birthDate' action='set' />
</true>
</if>
<if condition='target.address.Count() = 0'  expanded='false' >
<true>
<assign value='""' property='target.address.(1).city' action='set' />
</true>
</if>
<if condition='(source."country_code" &apos;= "")&amp;&amp;(source."country_code" &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source."country_code"' property='target.address.(1).country' action='set' />
</true>
</if>
<if condition='(source.state &apos;= "")&amp;&amp;(source.state &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.state' property='target.address.(1).state' action='set' />
</true>
</if>
<if condition='(source.city &apos;= "")&amp;&amp;(source.city &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.city' property='target.address.(1).city' action='set' />
</true>
</if>
<if condition='(source."postal_code" &apos;= "")&amp;&amp;(source."postal_code" &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source."postal_code"' property='target.address.(1).postalCode' action='set' />
</true>
</if>
<if condition='(source.street &apos;= "")&amp;&amp;(source.street &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source.street' property='target.address.(1).line.(1)' action='set' />
<if condition='(source."street_line_2" &apos;= "")&amp;&amp;(source."street_line_2" &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source."street_line_2"' property='target.address.(1).line.(2)' action='set' />
</true>
<false>
<comment>
<annotation>Si hay segunda línea en la dirección, borrarla</annotation>
</comment>
<if condition='target.address.(1).line.Count() = 2' >
<true>
<assign value='' property='target.address.(1).line' action='remove' key='2' />
</true>
</if>
</false>
</if>
</true>
</if>
<assign value='target.telecom.Count()' property='contIdTelecom' action='set' />
<comment>
<annotation>Dejamos la parte de asignar fecha comentada, ya que en OpenEMR esta fecha cambia siempre. Asignaremos valor solamente si no lo tiene previamente.</annotation>
</comment>
<if condition='target.address.(1).period.start = ""'  expanded='false' >
<true>
<assign value='$ZDT($H,3,7)' property='target.address.(1).period.start' action='set' />
</true>
</if>
<if condition='(source.addresses &apos;= "")&amp;&amp;(source.addresses.%Size() &gt; 0)' disabled='1'  expanded='false' >
<true>
<if condition='(source.addresses.%Get(0)."period_start" &apos;= "")' >
<true>
<assign value='$ZDT($ZDTH(source.addresses.%Get(0)."period_start",3,1),3,7)' property='target.address.(1).period.start' action='set' />
</true>
</if>
<if condition='(source.addresses.%Get(0)."period_end" &apos;= "")' >
<true>
<assign value='$ZDT($ZDTH(source.addresses.%Get(0)."period_end",3,1),3,7)' property='target.address.(1).period.end' action='set' />
</true>
</if>
</true>
</if>
<if condition='(source."phone_home" &apos;= "")&amp;&amp;(source."phone_home" &apos;= "NULL")'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindListValuePosition(target.telecom,$lb("use","system"),$lb("home","phone"))' property='poshome' action='set' />
<if condition='poshome = 0'  expanded='false' >
<true>
<assign value='contIdTelecom + 1' property='contIdTelecom' action='set' />
<assign value='source."phone_home"' property='target.telecom.(contIdTelecom).value' action='set' />
<assign value='"home"' property='target.telecom.(contIdTelecom).use' action='set' />
<assign value='"phone"' property='target.telecom.(contIdTelecom).system ' action='set' />
</true>
<false>
<assign value='source."phone_home"' property='target.telecom.(poshome).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='(source."phone_biz" &apos;= "")&amp;&amp;(source."phone_biz" &apos;= "NULL")'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindListValuePosition(target.telecom,$lb("use","system"),$lb("work","phone"))' property='poswork' action='set' />
<if condition='poswork = 0'  expanded='false' >
<true>
<assign value='contIdTelecom + 1' property='contIdTelecom' action='set' />
<assign value='source."phone_biz"' property='target.telecom.(contIdTelecom).value' action='set' />
<assign value='"work"' property='target.telecom.(contIdTelecom).use' action='set' />
<assign value='"phone"' property='target.telecom.(contIdTelecom).system ' action='set' />
</true>
<false>
<assign value='source."phone_biz"' property='target.telecom.(poswork).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='(source."phone_cell" &apos;= "")&amp;&amp;(source."phone_cell" &apos;= "NULL")'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindListValuePosition(target.telecom,$lb("use","system"),$lb("mobile","phone"))' property='posmobile' action='set' />
<if condition='posmobile = 0'  expanded='false' >
<true>
<assign value='contIdTelecom + 1' property='contIdTelecom' action='set' />
<assign value='source."phone_cell"' property='target.telecom.(contIdTelecom).value' action='set' />
<assign value='"mobile"' property='target.telecom.(contIdTelecom).use' action='set' />
<assign value='"phone"' property='target.telecom.(contIdTelecom).system ' action='set' />
</true>
<false>
<assign value='source."phone_cell"' property='target.telecom.(posmobile).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='(source.email &apos;= "")&amp;&amp;(source.email &apos;= "NULL")'  expanded='false' >
<true>
<assign value='##class(cysnet.syncEngine.util.DTLFunctions).FindListValuePosition(target.telecom,$lb("use","system"),$lb("home","email"))' property='posemail' action='set' />
<if condition='posemail = 0'  expanded='false' >
<true>
<assign value='contIdTelecom + 1' property='contIdTelecom' action='set' />
<assign value='source."email"' property='target.telecom.(contIdTelecom).value' action='set' />
<assign value='"home"' property='target.telecom.(contIdTelecom).use' action='set' />
<assign value='"email"' property='target.telecom.(contIdTelecom).system ' action='set' />
</true>
<false>
<assign value='source."email"' property='target.telecom.(posemail).value' action='set' />
</false>
</if>
</true>
</if>
<if condition='source.status &apos;=""'  expanded='false' >
<true>
<if condition='source.status = "married"'  expanded='false' >
<true>
<assign value='"M"' property='target.maritalStatus.coding.(1).code' action='set' />
<assign value='"Married"' property='target.maritalStatus.coding.(1).display' action='set' />
</true>
</if>
<if condition='source.status = "single"'  expanded='false' >
<true>
<assign value='"S"' property='target.maritalStatus.coding.(1).code' action='set' />
<assign value='"unmarried"' property='target.maritalStatus.coding.(1).display' action='set' />
</true>
</if>
<if condition='source.status = "divorced"'  expanded='false' >
<true>
<assign value='"D"' property='target.maritalStatus.coding.(1).code' action='set' />
<assign value='"Divorced"' property='target.maritalStatus.coding.(1).display' action='set' />
</true>
</if>
<if condition='source.status = "widowed"'  expanded='false' >
<true>
<assign value='"W"' property='target.maritalStatus.coding.(1).code' action='set' />
<assign value='"Widowed"' property='target.maritalStatus.coding.(1).display' action='set' />
</true>
</if>
<if condition='source.status = "separated"'  expanded='false' >
<true>
<assign value='"L"' property='target.maritalStatus.coding.(1).code' action='set' />
<assign value='"Legally Separated"' property='target.maritalStatus.coding.(1).display' action='set' />
</true>
</if>
<if condition='source.status = "domestic"' >
<true>
<assign value='"T"' property='target.maritalStatus.coding.(1).code' action='set' />
<assign value='"Domestic partner"' property='target.maritalStatus.coding.(1).display' action='set' />
</true>
</if>
</true>
</if>
<if condition='(source."deceased_date" &apos;= "")&amp;&amp;(source."deceased_date" &apos;= "NULL")'  expanded='false' >
<true>
<assign value='source."deceased_date"' property='target.deceasedDateTime' action='set' />
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
<if condition='(target.address.Count() = 0)||((target.address.(1).city = "")&amp;&amp;(target.address.(1).line.Count() = 0))' >
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
</transform>
}

}
