Class cysnet.hyperobjects.bo.HyperObjects Extends cysnet.rest.bo.RestManager
{

Parameter SETTINGS = "ResetLastUpdate";

/// Fecha de la última búsqueda
/// Si este campo es distinto de vacío, se obtendrán los cambios desde este LastUpdate
Property ResetLastUpdate As %TimeStamp;

Method getChanges(pRequest As cysnet.syncEngine.core.msg.GetChangesRequest, Output pResponse As cysnet.syncEngine.core.msg.GetChangesResponse) As %Status
{
	quit ##class(cysnet.hyperobjects.bo.core.HyperObjectsCore).getChanges(pRequest, .pResponse, $this)
}

Method search(pRequest As cysnet.hyperobjects.msg.SearchRequest, Output pResponse As cysnet.hyperobjects.msg.SearchResponse) As %Status
{
	quit ##class(cysnet.hyperobjects.bo.core.HyperObjectsCore).search(pRequest, .pResponse, $this)
}

Method get(pRequest As cysnet.hyperobjects.msg.GetRequest, Output pResponse As cysnet.hyperobjects.msg.GetResponse) As %Status
{
	quit ##class(cysnet.hyperobjects.bo.core.HyperObjectsCore).get(pRequest, .pResponse, $this)
}

Method upsert(pRequest As cysnet.hyperobjects.msg.UpsertRequest, Output pResponse As cysnet.hyperobjects.msg.UpsertResponse) As %Status
{
	quit ##class(cysnet.hyperobjects.bo.core.HyperObjectsCore).upsert(pRequest, .pResponse, $this)
}

Method send(pRequest As cysnet.hyperobjects.msg.SendRequest, Output pResponse As cysnet.hyperobjects.msg.SendRequest) As %Status
{
	quit ##class(cysnet.hyperobjects.bo.core.HyperObjectsCore).send(pRequest, .pResponse, $this)
}

Method testPost(pRequest As Ens.Request, Output pResponse As cysnet.hyperobjects.msg.SendResponse) As %Status
{
	set req = ##class(cysnet.hyperobjects.msg.SendRequest).%New()
	set req.verb = "POST"
	set req.url = "/Organization"
	set req.headerParams = ##class(%ListOfObjects).%New()
	do req.headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("Accept", "application/fhir+json"))
	do req.headerParams.Insert(##class(cysnet.rest.msg.struct.CampoValor).createNew("If-None-Exist", "identifier=123&name=XXXX"))
	set req.body = ##class(%Stream.GlobalCharacter).%New()
	do req.body.Write("{  ""resourceType"": ""Organization"",  ""identifier"": [    {      ""value"": ""123""    }  ],  ""name"": ""XXXX"",  ""partOf"" : {    ""reference"": ""Organization/136""  },  ""type"": [{    ""coding"" : [{      ""system"" : ""http://terminology.hl7.org/CodeSystem/organization-type"",      ""code"" : ""dept"",      ""display"" : ""Hospital Department""    }]  }],  ""active"": true}")
	
	quit ##class(cysnet.hyperobjects.bo.core.HyperObjectsCore).send(req, .pResponse, $this)
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="cysnet.syncEngine.core.msg.GetChangesRequest"> 
		<Method>getChanges</Method>
	</MapItem>
	<MapItem MessageType="cysnet.hyperobjects.msg.SearchRequest"> 
		<Method>search</Method>
	</MapItem>
	<MapItem MessageType="cysnet.hyperobjects.msg.GetRequest"> 
		<Method>get</Method>
	</MapItem>
	<MapItem MessageType="cysnet.hyperobjects.msg.UpsertRequest"> 
		<Method>upsert</Method>
	</MapItem>
	<MapItem MessageType="cysnet.hyperobjects.msg.SendRequest"> 
		<Method>send</Method>
	</MapItem>
	<MapItem MessageType="Ens.StringRequest"> 
		<Method>testPost</Method>
	</MapItem>
</MapItems>
}

}
